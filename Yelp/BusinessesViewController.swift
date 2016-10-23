//
//  BusinessesViewController.swift
//  Yelp
//
//  Created by Timothy Lee on 4/23/15.
//  Copyright (c) 2015 Timothy Lee. All rights reserved.
//

import UIKit

class BusinessesViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var networkErrorView: UIView!
    
    var searchBar = UISearchBar()
    var loadingMoreView: InfiniteScrollActivityView?
    var notificationLabel = UILabel()
    
    var term = ""
    var currentSort = 0
    var currentDistance:Double = 40000
    var currentOfferDealState = false
    var currentOffset = 0
    var currentFilters = [String]()
    var isMoreDataLoading = false
    
    var businesses = [Business]()
    var filteredData = [Business]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 100

        let frame = CGRect(x: 0, y: tableView.contentSize.height, width: tableView.bounds.size.width, height: InfiniteScrollActivityView.defaultHeight)
        loadingMoreView = InfiniteScrollActivityView(frame: frame)
        loadingMoreView!.isHidden = true
        loadingMoreView?.startAnimating()
        tableView.tableFooterView = loadingMoreView
        
        networkErrorView.backgroundColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.7)
        tableView.tableFooterView?.addSubview(networkErrorView)
        hideNetworkError()
        
        notificationLabel = UILabel(frame: CGRect(x: 0, y: 0, width: tableView.superview!.frame.width, height: 50))
        notificationLabel.text = "No result found"
        notificationLabel.textAlignment = NSTextAlignment.center
        notificationLabel.isHidden = true
        tableView.tableFooterView?.addSubview(notificationLabel)
        
        searchBar.placeholder = "Search"
        searchBar.delegate = self
        self.navigationItem.titleView = searchBar
        
        loadData()
        
/* Example of Yelp search with more search options specified
        Business.search(with: "Restaurants", sort: .Distance, categories: ["asianfusion", "burgers"], deals: true) { (businesses: [Business]!, error: NSError!) -> Void in
            self.businesses = businesses
            
            for business in businesses {
                print(business.name!)
                print(business.address!)
            }
        }
*/
    }
    
    func loadData() {
        print("loadData()")
        
        term = self.searchBar.text!
        Business.search(with: term, sort: YelpSortMode(rawValue: currentSort), categories: currentFilters, deals: currentOfferDealState, currentOffset: currentOffset, distance: currentDistance) { (businesses:[Business]?, errors:Error?) in
            if let businesses = businesses {
                self.businesses = businesses
                self.loadingMoreView?.stopAnimating()
                
                self.currentOffset = businesses.count
                self.tableView.reloadData()
                
                self.notificationLabel.isHidden = self.currentOffset == 0 ? false : true
            }
            else {
                self.showNetworkError()
            }
        }
    }

    func loadMoreData() {
        print("loadMoreData()")
        
        term = self.searchBar.text!
        Business.search(with: term, sort: YelpSortMode(rawValue: currentSort), categories: currentFilters, deals: currentOfferDealState, currentOffset: currentOffset, distance: currentDistance) { (businesses:[Business]?, errors:Error?) in
            
            self.isMoreDataLoading = false
            
            if let businessesGot = businesses {
                self.businesses.append(contentsOf: businessesGot)
                self.loadingMoreView?.stopAnimating()
                
                self.currentOffset = self.businesses.count
                self.tableView.reloadData()
                
                self.notificationLabel.isHidden = self.currentOffset == 0 ? false : true
            }
            else {
                self.showNetworkError()
            }
        }
        
    }
    
    func showNetworkError() {
        print("showNetworkError()")
        self.loadingMoreView?.stopAnimating(isHiddenItself: false)
        UIView.animate(withDuration: 0.5, animations: {
            self.networkErrorView.alpha = 1
        })
    }
    
    func hideNetworkError() {
        print("hideNetworkError()")
        UIView.animate(withDuration: 0.1, animations: {
            self.networkErrorView.alpha = 0
        })
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if sender is UITableViewCell {
            let indexPath = tableView.indexPath(for: sender as! BusinessCell)
            let viewControllerDestination = segue.destination as? DetailViewController
            viewControllerDestination?.businessData = self.businesses[(indexPath?.row)!]
        }
        else {
            let navigation = segue.destination as! UINavigationController
            let filtersViewController = navigation.topViewController as! FiltersViewController
            
            filtersViewController.delegate = self
        }
    }
}

extension BusinessesViewController: FiltersViewControllerDelegate {
    
    func filtersViewController(filtersViewController: FiltersViewController, didUpdateFilter filters: [String], sort: Int, deals: Bool, distance: Double) {
        currentFilters = filters
        currentSort = sort
        currentOfferDealState = deals
        currentDistance = distance
        currentOffset = 0
        
        self.businesses.removeAll()
        self.tableView.reloadSections(NSIndexSet(index: 0) as IndexSet, with: .automatic)
        
        print("Filtered")
        loadingMoreView?.startAnimating()
        loadData()
        
    }
}

extension BusinessesViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if (!isMoreDataLoading) {
            
            // Calculate the position of one screen length before the bottom of the results
            let scrollViewContentHeight = tableView.contentSize.height
            let scrollOffsetThreshold = scrollViewContentHeight - tableView.bounds.size.height
            
            // When the user has scrolled past the threshold, start requesting
            if(scrollView.contentOffset.y > scrollOffsetThreshold && tableView.isDragging) {
                
                isMoreDataLoading = true
                loadingMoreView?.startAnimating()
                self.hideNetworkError()
                self.notificationLabel.isHidden = true
                
                // Code to load more results
                loadMoreData()
            }
            
        }
    }
}

extension BusinessesViewController: UISearchBarDelegate {
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(true, animated: true)
        searchBar.barTintColor = UIColor.black
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(false, animated: true)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        searchBar.endEditing(true)
        
        if term != "" {
            
            self.businesses.removeAll()
            self.tableView.reloadSections(NSIndexSet(index: 0) as IndexSet, with: .automatic)
            
            print("Clear search")
            loadingMoreView?.startAnimating()
            loadData()
        }
        
        return
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
        hideNetworkError()
        loadingMoreView?.startAnimating()
        
        currentOffset = 0
        loadData()
        return
    }
}

extension BusinessesViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(businesses.count)
        return businesses.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BusinessCell") as! BusinessCell
        
        cell.businessData = businesses[indexPath.row]
        
        return cell
    }
    
    
}
