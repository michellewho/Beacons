//
//  PlaceDetailsController.swift
//  Beacons
//
//  Created by Michelle Ho on 7/21/16.
//  Copyright © 2016 Michelle Ho. All rights reserved.
//


import UIKit
import GoogleMaps
import AlamofireImage

class PlaceDetailsController: UIViewController {
    var placeDetails: PlaceDetails!
    let place = VisitedPlaces()
    
    // Header
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var placeName: UILabel!
    @IBOutlet weak var cityState: UILabel!
    @IBOutlet weak var beaconButton: UIButton!
    @IBOutlet weak var visitedButton: UIButton!
    
    // Call Button
    @IBOutlet weak var callButton: UIButton!
    
    // Directions Button
    @IBOutlet weak var directionsButton: UIButton!
    
    
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
            placeDetails.isVisited = false
            beaconButton.selected = true
            visitedButton.selected = true
            headerView.backgroundColor = UIColor(red: 1.0, green: 0.675, blue: 0, alpha: 1.0)
            
            placeDetails.isVisited = true
            
        } else {
            placeDetails.isVisited = true
            beaconButton.selected = false
            visitedButton.selected = false
            headerView.backgroundColor = UIColor(red: 0.114, green: 0.447, blue: 0.761, alpha: 1.0)
            placeDetails.isVisited = false
            
            //print(placeDetails.isVisited)
        }
        
        place.isVisited = placeDetails.isVisited
        place.placeId = placeDetails.placeId
    }
    
    // Call Button pressed
    @IBAction func callButton(sender: AnyObject) {
        if case placeDetails.phoneNumber = placeDetails.phoneNumber {
            let formattedPhoneNumber:String = placeDetails.phoneNumber
            // (415) 581-3500
            var unformattedPhoneNumber = removeCharacters(formattedPhoneNumber, str: " ")
            unformattedPhoneNumber = removeCharacters(unformattedPhoneNumber, str: "-")
            unformattedPhoneNumber = removeCharacters(unformattedPhoneNumber, str: "(")
            unformattedPhoneNumber = removeCharacters(unformattedPhoneNumber, str: ")")
            
            let phoneNumber:String = "tel://\(unformattedPhoneNumber)"
            UIApplication.sharedApplication().openURL(NSURL(string:phoneNumber)!)
        }
    }
    
    // Visited Button pressed
    @IBAction func visitedButton(sender: AnyObject) {
        if !placeDetails.isVisited {
            visitedButton.selected = true
            beaconButton(beaconButton)
            
        } else {
            visitedButton.selected = false
            beaconButton(beaconButton)
            
        }
        
    }
    
    
    // Direction Button pressed
    @IBAction func directionsButton(sender: AnyObject) {
        if (UIApplication.sharedApplication().canOpenURL(NSURL(string:"comgooglemaps://")!)) {
            UIApplication.sharedApplication().openURL(NSURL(string:
                "comgooglemaps://?q=\(placeDetails.name.stringByReplacingOccurrencesOfString(" ", withString: "+"))&center=\(placeDetails.lat),\(placeDetails.long)")!)
            print("comgooglemaps://?q=\(placeDetails.name.stringByReplacingOccurrencesOfString(" ", withString: "+"))&center=\(placeDetails.lat),\(placeDetails.long)")
                        print(placeDetails.name)

        } else {
            // App not available
            UIApplication.sharedApplication().openURL(NSURL(string: "http://googlemaps.com//?q=\(placeDetails.name.stringByReplacingOccurrencesOfString(" ", withString: "+"))&center=\(placeDetails.lat),\(placeDetails.long)")!)
        }
    }
    
    
    func removeCharacters(actualString: String, str: String) -> String {
       return actualString.stringByReplacingOccurrencesOfString(str, withString: "")
    }
    
    // adds map to placeMapView located at selected point of interest
    func addMap(placeMapView: GMSMapView, placeDetails: PlaceDetails) {
        placeMapView.camera = GMSCameraPosition.cameraWithLatitude(placeDetails.lat, longitude: placeDetails.long, zoom: 14)
        let position = CLLocationCoordinate2DMake(placeDetails.lat, placeDetails.long)
        let marker = GMSMarker(position: position)
        marker.map = placeMapView
        marker.icon = UIImage(named: "pinbubble")
    }
    
    func updateHeaderView() {
        
        if place.isVisited {
            beaconButton.selected = true
            headerView.backgroundColor = UIColor(red: 1.0, green: 0.675, blue: 0, alpha: 1.0)
            visitedButton.selected = true
            
        } else {
            beaconButton.selected = false
            headerView.backgroundColor = UIColor(red: 0.114, green: 0.447, blue: 0.761, alpha: 1.0)
            visitedButton.selected = false
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // placeName Label Settings
        placeName.text = placeDetails.name
        
        // address Label Settings
        addressLabel.text = placeDetails.address
        
        let places = RealmHelper.retrievePlace()
        
        
        _ =  places.contains({ (place1) -> Bool in

            if place1.placeId == placeDetails.placeId {
                place.placeId = placeDetails.placeId
                place.isVisited = true
                return true
            }
            return false
        })
        updateHeaderView()
        addMap(placeMapView, placeDetails: placeDetails)
    }
    
    override func viewDidDisappear(animated: Bool) {
        if place.isVisited {
            RealmHelper.newPlace(place)
        } else {
            let places = RealmHelper.retrievePlace()
            
            for item in places {
                if item.placeId == place.placeId {
                     RealmHelper.deletePlace(item)
                    return
                }
            }

           // if RealmHelper.retrievePlace()(place.placeId).count > 0 {
              //  RealmHelper.deletePlace(place)
           // }
        }
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
