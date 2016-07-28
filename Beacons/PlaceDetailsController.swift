//
//  PlaceDetailsController.swift
//  Beacons
//
//  Created by Michelle Ho on 7/21/16.
//  Copyright © 2016 Michelle Ho. All rights reserved.
//


import UIKit
import GoogleMaps

class PlaceDetailsController: UIViewController {
    var placeDetails: PlaceDetails!
    
    // Header
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var placeName: UILabel!
    @IBOutlet weak var cityState: UILabel!
    @IBOutlet weak var beaconButton: UIButton!
    @IBOutlet weak var callButton: UIButton!
    
    
    // Address Label
    @IBOutlet weak var addressLabel: UILabel!
    
    // placeMapView
    @IBOutlet weak var placeMapView: GMSMapView!
    
    
    // Scrollview place photos
    @IBOutlet weak var placeCollectionView: UICollectionView!

    // Cancel button
    @IBAction func cancelButton(sender: AnyObject) {
    }

    // Beacon Button pressed
    @IBAction func beaconButton(sender: AnyObject) {
        
        if !placeDetails.isVisited {
            beaconButton.selected = true
            headerView.backgroundColor = UIColor(red: 1.0, green: 0.675, blue: 0, alpha: 1.0)
            placeDetails.isVisited = true
            //print(placeDetails.isVisited)

        } else {
            beaconButton.selected = false
            headerView.backgroundColor = UIColor(red: 0.114, green: 0.447, blue: 0.761, alpha: 1.0)
            placeDetails.isVisited = false
            //print(placeDetails.isVisited)
    
        }
    }
    
    // Call Button pressed
    @IBAction func callButton(sender: AnyObject) {
        if case placeDetails.phoneNumber = placeDetails.phoneNumber {
            let formattedPhoneNumber:String = placeDetails.phoneNumber
            // (415) 581-3500
            var unformattedPhoneNumber: String = formattedPhoneNumber.stringByReplacingOccurrencesOfString(" ", withString: "")
            unformattedPhoneNumber = unformattedPhoneNumber.stringByReplacingOccurrencesOfString("-", withString: "")
            unformattedPhoneNumber = unformattedPhoneNumber.stringByReplacingOccurrencesOfString("(", withString: "")
            unformattedPhoneNumber = unformattedPhoneNumber.stringByReplacingOccurrencesOfString(")", withString: "")
        
            let phoneNumber:String = "tel://\(unformattedPhoneNumber)"
            UIApplication.sharedApplication().openURL(NSURL(string:phoneNumber)!)
        }
        

    }
    
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // placeName Label Settings
        placeName.text = placeDetails.name
        // address Label Settings
        addressLabel.text = placeDetails.address
        
        addMap(placeMapView, placeDetails: placeDetails)
        
    }

    // adds map to placeMapView located at selected point of interest
    func addMap(placeMapView: GMSMapView, placeDetails: PlaceDetails) {
        placeMapView.camera = GMSCameraPosition.cameraWithLatitude(placeDetails.lat, longitude: placeDetails.long, zoom: 14)
        let position = CLLocationCoordinate2DMake(placeDetails.lat, placeDetails.long)
        let marker = GMSMarker(position: position)
        marker.map = placeMapView
        marker.icon = UIImage(named: "pinbubble")
    }
}


extension PlaceDetailsController: UICollectionViewDataSource {
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return placeDetails.references.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("photoCell", forIndexPath: indexPath) as! PhotoViewCell
        
        let urlString = "https://maps.googleapis.com/maps/api/place/photo?maxwidth=400&photoreference=\(placeDetails.references[indexPath.row])&key=\(API_KEY)"
        let url = NSURL(string: urlString)
        if let url = url {
            let data = NSData(contentsOfURL: url)
            cell.photoView.image = UIImage(data: data!)
        }
        
   
        return cell
    }
}
