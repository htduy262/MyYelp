//
//  FiltersViewController.swift
//  Yelp
//
//  Created by Duy Huynh Thanh on 10/20/16.
//  Copyright © 2016 Timothy Lee. All rights reserved.
//

import UIKit

@objc protocol FiltersViewControllerDelegate {
    @objc optional func filtersViewController(filtersViewController:FiltersViewController, didUpdateFilter filters: [String], sort: Int, deals: Bool, distance: Double)
}

class FiltersViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    weak var delegate:FiltersViewControllerDelegate?
    
    var isSortAll = false
    var isDistanceAll = false
    var isCategoryAll = false
    var offerDealState = false
    var switchCategoryStates = [Int: Bool]()
    
    var sortNames = ["Best matched", "Distance", "Highest Rated"]
    var sortValues:[Int] = [0, 1, 2]
    var selectedSort = 0

    
    var distanceCategoryNames = ["Auto", "0.3 mile", "1 mile", "5 miles", "20 miles"]
    var distanceCategoryValues:[Double] = [40000, 482, 1609, 8046, 32186]
    var selectedDistance = 0
    
    let categories: [Dictionary<String, String>] = [["name" : "Afghan", "code": "afghani"],
                                     ["name" : "African", "code": "african"],
                                     ["name" : "American, New", "code": "newamerican"],
                                     ["name" : "American, Traditional", "code": "tradamerican"],
                                     ["name" : "Arabian", "code": "arabian"],
                                     ["name" : "Argentine", "code": "argentine"],
                                     ["name" : "Armenian", "code": "armenian"],
                                     ["name" : "Asian Fusion", "code": "asianfusion"],
                                     ["name" : "Asturian", "code": "asturian"],
                                     ["name" : "Australian", "code": "australian"],
                                     ["name" : "Austrian", "code": "austrian"],
                                     ["name" : "Baguettes", "code": "baguettes"],
                                     ["name" : "Bangladeshi", "code": "bangladeshi"],
                                     ["name" : "Barbeque", "code": "bbq"],
                                     ["name" : "Basque", "code": "basque"],
                                     ["name" : "Bavarian", "code": "bavarian"],
                                     ["name" : "Beer Garden", "code": "beergarden"],
                                     ["name" : "Beer Hall", "code": "beerhall"],
                                     ["name" : "Beisl", "code": "beisl"],
                                     ["name" : "Belgian", "code": "belgian"],
                                     ["name" : "Bistros", "code": "bistros"],
                                     ["name" : "Black Sea", "code": "blacksea"],
                                     ["name" : "Brasseries", "code": "brasseries"],
                                     ["name" : "Brazilian", "code": "brazilian"],
                                     ["name" : "Breakfast & Brunch", "code": "breakfast_brunch"],
                                     ["name" : "British", "code": "british"],
                                     ["name" : "Buffets", "code": "buffets"],
                                     ["name" : "Bulgarian", "code": "bulgarian"],
                                     ["name" : "Burgers", "code": "burgers"],
                                     ["name" : "Burmese", "code": "burmese"],
                                     ["name" : "Cafes", "code": "cafes"],
                                     ["name" : "Cafeteria", "code": "cafeteria"],
                                     ["name" : "Cajun/Creole", "code": "cajun"],
                                     ["name" : "Cambodian", "code": "cambodian"],
                                     ["name" : "Canadian", "code": "New)"]]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        tableView.dataSource = self
        tableView.delegate = self
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    @IBAction func onBack(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }

    @IBAction func onSearch(_ sender: UIBarButtonItem) {
        var filters = [String]()
        
        for (row, selected) in switchCategoryStates {
            if selected {
                filters.append(categories[row]["code"]!)
            }
        }
        
        delegate?.filtersViewController!(filtersViewController: self, didUpdateFilter: filters, sort: sortValues[selectedSort], deals: offerDealState, distance: distanceCategoryValues[selectedDistance])
        
        dismiss(animated: true, completion: nil)
    }
    
    func onTapSeeAllCategoryCell() {
        let cell = tableView.cellForRow(at: NSIndexPath(row: 0, section: 4) as IndexPath) as! SeeAllCell
        
        if isCategoryAll {
            cell.seeAllLabel.text = "See All"
            isCategoryAll = false
        }
        else {
            cell.seeAllLabel.text = "Collapse"
            isCategoryAll = true
        }
        
        tableView.reloadSections(NSIndexSet(index: 3) as IndexSet, with: .automatic)
    }
    

    
    func onTapResetAll() {
        switchCategoryStates.removeAll(keepingCapacity: false)
        selectedSort = 0
        selectedDistance = 0
        offerDealState = false
        
        let cell = tableView.cellForRow(at: NSIndexPath(row: 0, section: 4) as IndexPath) as! SeeAllCell
        
        if isCategoryAll {
            cell.seeAllLabel.text = "See All"
            isCategoryAll = false
        }
        
        if isDistanceAll {
            isDistanceAll = false
        }
        
        if isSortAll {
            isSortAll = false
        }
        
        tableView.reloadSections(NSIndexSet(index: 0) as IndexSet, with: .automatic)
        tableView.reloadSections(NSIndexSet(index: 1) as IndexSet, with: .automatic)
        tableView.reloadSections(NSIndexSet(index: 2) as IndexSet, with: .automatic)
        tableView.reloadSections(NSIndexSet(index: 3) as IndexSet, with: .automatic)
    }
    
    
}

extension FiltersViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // 0. Deals : Bool
        // 1. Distance : Double
        // 2. Sort : Int
        // 3. Categorys : [String]
        // 4. See All Category
        // 5. Reset All Filters
        
        return 6
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        switch indexPath.section {
        case 1:
            if !isDistanceAll {
                if indexPath.row > 0 {
                    return 0
                }
            }
        case 2:
            if !isSortAll {
                if indexPath.row > 0 {
                    return 0
                }
            }
        case 3:
            if !isCategoryAll {
                if categories.count > 2 && indexPath.row > 2 {
                    return 0
                }
            }
        default:
            return 50
        }
        
        return 50
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 || section == 4 {
            return 0
        }
        else if section == 5 {
            return 10
        }
        return 45
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 || section == 4 {
            return nil
        }
        
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 100))
        headerView.backgroundColor = UIColor(red: 255/255, green: 239/255, blue: 71/255, alpha: 1)
        
        let titleLabel = UILabel(frame: CGRect(x: 20, y: 8, width: tableView.frame.width, height: 30))
        titleLabel.textColor = UIColor(red: 254/255, green: 163/255, blue: 75/255, alpha: 1)
        titleLabel.font = UIFont(name: "Helvetica", size: 20)
        
        switch section {
        case 0:
            titleLabel.text = "Offering a deal"
        case 1:
            titleLabel.text = "Distance"
        case 2:
            titleLabel.text = "Sort By"
        case 3:
            titleLabel.text = "Category"
        default:
            return nil
        }
        
        headerView.addSubview(titleLabel)
        
        return headerView
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        case 1:
            return 5
        case 2:
            return 3
        case 3:
            return categories.count
        case 4:
            return 1
        case 5:
            return 1
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "OfferDealCell") as! OfferDealCell
            
            cell.switchButton.isOn = offerDealState
            
            cell.delegate = self
            
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "DistanceCell") as! DistanceCell
            
            if !isDistanceAll {
                if indexPath.row == 0 {
                    cell.nameLabel.text = distanceCategoryNames[selectedDistance]
                    cell.upDownImageView.alpha = 0
                    cell.upDownImageView.image = UIImage(named: "selected")
                    UIView.animate(withDuration: 0.3, animations: {
                        cell.upDownImageView.alpha = 1
                    })
                }
            }
            else {
                cell.nameLabel.text = distanceCategoryNames[indexPath.row]
                cell.upDownImageView.alpha = 0
                if indexPath.row == selectedDistance {
                    cell.upDownImageView.image = UIImage(named: "selected")
                }
                else {
                    cell.upDownImageView.image = UIImage(named: "non_selected")
                }
                UIView.animate(withDuration: 0.3, animations: {
                    cell.upDownImageView.alpha = 1
                })
            }
            
            cell.delegate = self
            
            return cell
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: "SortCell") as! SortCell
            
            if !isSortAll {
                if indexPath.row == 0 {
                    cell.nameLabel.text = sortNames[selectedSort]
                    cell.upDownImageView.alpha = 0
                    cell.upDownImageView.image = UIImage(named: "selected")
                    UIView.animate(withDuration: 0.3, animations: {
                        cell.upDownImageView.alpha = 1
                    })
                }
            }
            else {
                cell.nameLabel.text = sortNames[indexPath.row]
                cell.upDownImageView.alpha = 0
                if indexPath.row == selectedSort {
                    cell.upDownImageView.image = UIImage(named: "selected")
                }
                else {
                    cell.upDownImageView.image = UIImage(named: "non_selected")
                }
                UIView.animate(withDuration: 0.3, animations: {
                    cell.upDownImageView.alpha = 1
                })
            }
            
            cell.delegate = self
            
            return cell
        case 3:
            let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell") as! CategoryCell
            
            cell.categoryNameLabel.text = categories[indexPath.row]["name"]
            
            cell.switchButton.isOn = switchCategoryStates[indexPath.row] ?? false
            
            cell.delegate = self
            
            return cell
        case 4:
            let cell = tableView.dequeueReusableCell(withIdentifier: "SeeAllCell") as! SeeAllCell
            
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(onTapSeeAllCategoryCell))
            cell.addGestureRecognizer(tapGesture)
            return cell
        case 5:
            let cell = tableView.dequeueReusableCell(withIdentifier: "ResetAllCell") as! ResetAllCell
            
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(onTapResetAll))
            cell.addGestureRecognizer(tapGesture)
            return cell
        default:
            return UITableViewCell()
        }
    }
}

extension FiltersViewController: CategoryCellDelegate {
    
    func categoryCell(categoryCell: CategoryCell, didChangeValue value: Bool) {
        let indexPath = tableView.indexPath(for: categoryCell)
        switchCategoryStates[(indexPath?.row)!] = value
    }
}

extension FiltersViewController: OfferDealCellDelegate {
    
    func offerDealCell(offerDealCell: OfferDealCell, didChangeValue value: Bool) {
        offerDealState = value
    }
}

extension FiltersViewController: DistanceCellDelegate {
    func distanceCell(distanceCell: DistanceCell) {
        if let indexPath = tableView.indexPath(for: distanceCell) {
            if isDistanceAll {
                if indexPath.row != selectedDistance {
                    selectedDistance = indexPath.row
                    print("selectedDistance = \(selectedDistance)")
                }
                
                isDistanceAll = false
            }
            else {
                isDistanceAll = true
            }
            
            tableView.reloadSections(NSIndexSet(index: 1) as IndexSet, with: .automatic)
        }
    }
}

extension FiltersViewController: SortCellDelegate {
    func sortCell(sortCell: SortCell) {
        if let indexPath = tableView.indexPath(for: sortCell) {
            if isSortAll {
                if indexPath.row != selectedSort {
                    selectedSort = indexPath.row
                    print("selectedSort = \(selectedSort)")
                }
                
                isSortAll = false
            }
            else {
                isSortAll = true
            }
            
            tableView.reloadSections(NSIndexSet(index: 2) as IndexSet, with: .automatic)
        }
    }
}
