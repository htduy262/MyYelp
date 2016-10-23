//
//  DetailViewController.swift
//  Yelp
//
//  Created by Duy Huynh Thanh on 10/23/16.
//  Copyright © 2016 Timothy Lee. All rights reserved.
//

import UIKit
import GoogleMaps
import AFNetworking

class DetailViewController: UIViewController {

    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var starRateImageView: UIImageView!
    @IBOutlet weak var reviewCountLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    
    @IBOutlet weak var googleMapsView: GMSMapView!
    
    var businessData: Business!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        loadDetail()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loadDetail() {
        avatarImageView.alpha = 0
        if let url = businessData.imageURL {
            avatarImageView.setImageWith(url)
            
            UIView.animate(withDuration: 0.6) {
                self.avatarImageView.alpha = 1
            }
        }
        
        nameLabel.text = businessData.name
        distanceLabel.text = businessData.distance
        
        starRateImageView.alpha = 0
        if let url = businessData.ratingImageURL {
            starRateImageView.setImageWith(url)
            
            UIView.animate(withDuration: 0.6) {
                self.starRateImageView.alpha = 1
            }
        }
        
        if let reviewCount = businessData.reviewCount {
            reviewCountLabel.text = "\(reviewCount) Reviews"
        }
        
        addressLabel.text = businessData.address
        categoryLabel.text = businessData.categories
        phoneLabel.text = businessData.phone
        
        loadMap()
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    func loadMap() {
        print("Load map for latitude = \(businessData.latitude) and longitude = \(businessData.longitude)")
        let camera = GMSCameraPosition.camera(withLatitude: businessData.latitude!, longitude: businessData.longitude!, zoom: 15)
        googleMapsView.camera = camera
        googleMapsView.isMyLocationEnabled = true
        
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: businessData.latitude!, longitude: businessData.longitude!)
        marker.title = businessData.name!
        marker.map = googleMapsView
    }
    
    @IBAction func getDirection(_ sender: AnyObject) {
        let myLatitude = 37.785771
        let myLongitude = -122.406165
        let destLatitude = "\(businessData.latitude!)"
        let destLongitude = "\(businessData.longitude!)"
        
        var destLatitudeArray = [Double]()
        var destLongitudeArray = [Double]()
        
        googleMapsView.isMyLocationEnabled = true
        
        let urlString = "http://maps.googleapis.com/maps/api/directions/json?origin=\(myLatitude),\(myLongitude)&destination=\(destLatitude),\(destLongitude)&mode=driving"
        let request = NSURLRequest(url: URL(string: urlString)!)
        
        do {
            let data = try NSURLConnection.sendSynchronousRequest(request as URLRequest, returning: nil)
            
            let json = try JSONSerialization.jsonObject(with: data, options: []) as? NSDictionary
            
            if let json = json {
                let stepArray = json.value(forKeyPath: "routes.legs.steps") as! NSArray
                
                let array = stepArray[0] as! NSArray
                let array2 = array[0] as! [NSDictionary]
                
                destLatitudeArray.append(myLatitude)
                destLongitudeArray.append(myLongitude)
                
                for step in array2 {
                    let desLat = step.value(forKeyPath: "end_location.lat") as! Double
                    let desLong = step.value(forKeyPath: "end_location.lng") as! Double
                    
                    destLatitudeArray.append(desLat)
                    destLongitudeArray.append(desLong)
                }
            }
            
        } catch  { }
        
        
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2DMake(37.785771, -122.406165)
        marker.title = "My location"
        marker.icon = UIImage(named: "location")
        marker.map = googleMapsView
        
        let path = GMSMutablePath()
        
        for i in 0..<destLatitudeArray.count {
            path.addLatitude(CLLocationDegrees(destLatitudeArray[i]), longitude: CLLocationDegrees(destLongitudeArray[i]))
        }
        
        let polyline = GMSPolyline(path: path)
        polyline.strokeColor = UIColor(red: 213/255, green: 28/255, blue: 24/255, alpha: 1.0)
        polyline.strokeWidth = 5
        polyline.map = googleMapsView
    }
}
