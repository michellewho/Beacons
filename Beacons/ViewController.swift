//
//  ViewController.swift
//  Beacons
//
//  Created by Michelle Ho on 7/12/16.
//  Copyright © 2016 Michelle Ho. All rights reserved.
//

import UIKit
import GoogleMaps
import CoreLocation

class ViewController: UIViewController {
    
    let locationManager = CLLocationManager()
    var didFindMyLocation = false
    var searchResultController:SearchResultsController!         // Reference to SearchResultsController class
    var resultsArray = [String]()                               // Array of strings that will hold autocompletes
    //var googleMapsView:GMSMapView!  
    // Reference to Google map on screen
    
    //IBOutlets
    @IBOutlet weak var mapView: GMSMapView!
    
    
    @IBAction func showSearchController(sender: AnyObject) {
        let searchController = UISearchController(searchResultsController: searchResultController)
        searchController.view.backgroundColor = UIColor.lightGrayColor()
        searchController.searchBar.delegate = self
        self.presentViewController(searchController, animated: true, completion: nil)
        
    }
    
    // Constructs an object for the SearchResultsController class and sets the current class as delegate for SearchResultsController
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(false)
        searchResultController = SearchResultsController()
        searchResultController.delegate = self
        

    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
//        let marker = GMSMarker()
//        marker.position = CLLocationCoordinate2DMake(47.6062, -122.3321)
//        marker.title = "San Francisco"
//        marker.snippet = "California"
//        marker.map = mapView
        
        mapView.myLocationEnabled = true
        mapView.addObserver(self, forKeyPath: "myLocation", options: NSKeyValueObservingOptions.New, context: nil)
        
        setupLocationManager()
        
    
    }
    
    // Goes to current location on map
    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        
        if !didFindMyLocation {
            let myLocation: CLLocation = change![NSKeyValueChangeNewKey] as! CLLocation
            mapView.camera = GMSCameraPosition.cameraWithTarget(myLocation.coordinate, zoom: 15.0)
            mapView.settings.myLocationButton = true
            
            didFindMyLocation = true
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setupLocationManager() {
        
        // For Current Location
        self.locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.requestAlwaysAuthorization()
            locationManager.startUpdatingLocation()
        }
        
    }

}

extension ViewController: UISearchBarDelegate {
    func searchBar(searchBar: UISearchBar,
                   textDidChange searchText: String){
        
        let placesClient = GMSPlacesClient()
        placesClient.autocompleteQuery(searchText, bounds: nil, filter: nil) { (results, error:NSError?) -> Void in
            self.resultsArray.removeAll()
            if results == nil {
                return
            }
            for result in results!{
                if let result = result as? GMSAutocompletePrediction{
                    self.resultsArray.append(result.attributedFullText.string)
                }
            }
            self.searchResultController.reloadDataWithArray(self.resultsArray)
        }
    }
}

extension ViewController: CLLocationManagerDelegate {
    
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        if status == CLAuthorizationStatus.AuthorizedWhenInUse {
            mapView.myLocationEnabled = true
        }
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print(locations)
    }
}

extension ViewController: LocateOnTheMap {
    // Called from within SearchResultsController class to show selected address on the map. Marks the location on the map
    func locateWithLongitude(lon: Double, andLatitude lat: Double, andTitle title: String) {
        
        dispatch_async(dispatch_get_main_queue()) { () -> Void in
            //let position = CLLocationCoordinate2DMake(lat, lon)
            //            let marker = GMSMarker(position: position)
            
            let camera  = GMSCameraPosition.cameraWithLatitude(lat, longitude: lon, zoom: 15)
            self.mapView.camera = camera
            
            //            marker.title = title
            //            marker.map = self.mapView
        }
    }
}

