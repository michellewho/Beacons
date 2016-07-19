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
    var myCoordinates = [0.0, 0.0]
    var currentCity = ""
    var currentCountry = ""
    var streetAddress = ""
    
    var searchResultController:SearchResultsController!         // Reference to SearchResultsController class
    var resultsArray = [String]()                               // Array of strings that will hold autocompletes
    
    var sfPlaces: [String: [String]] = ["Golden Gate Bridge": ["ChIJw____96GhYARCVVwg5cT7c0", "37.8199", "-122.4783"], "Fisherman's Wharf": ["ChIJueOuefqAhYARapAU-YtbztA", "37.8080", "-122.4177"], "Alcatraz Island":["ChIJmRyMs_mAhYARpViaf6JEWNE", "37.8270", "-122.4230"], "Golden Gate Park": ["ChIJY_dFYHKHhYARMKc772iLvnE", "37.7694", "-122.4862"], "Chinatown": ["ChIJHYqlWIuAhYARrIAPZpIwnyg", "37.7941", "-122.4078"], "Union Square": ["ChIJu0D9046AhYARurZMmbXZQf4", "40.7359", "-73.9911"], "California Academy of Sciences": ["ChIJIUT7rEOHhYARucp3wM-HhBs", "37.7699","-122.4661"], "Exploratorium": ["ChIJk2vl5NSGhYARwPGvs_ubIws", "37.8009", "-122.3986"], "AT&T Park": ["ChIJ_T25cNd_j4ARehGmHe0pT84", "37.7786", "-122.3893"], "San Francisco Ferry Building": ["ChIJhWnoKmSAhYAR6GjrsMeoOcE", "37.7956", "-122.3933"], "Ghirardelli Square": ["ChIJvXl2weCAhYARjSxnhzrBfNc", "37.8060", "-122.4230"], "Lombard Street": ["ChIJgQ-3a-aAhYARmRLswQrO0xA", "37.8021", "-122.4187"], "Coit Tower": ["ChIJbyyyIfeAhYARmg3wBb7t4Ww", "37.8024", "-122.4058"], "Aquarium of the Bay": ["ChIJ9UMKePyAhYAR0qMWDYjn0aM", "37.8088", "-122.4093"], "Twin Peaks": ["ChIJp71fQgh-j4ARV7YEtWUmni0", "34.2384", "-117.2358"], "Presidio of San Francisco": ["ChIJmxVaCN-GhYARYH--_Fayr7Q", "37.7989", "-122.4662"], "Asian Art Museum of San Francisco": ["ChIJkQQVTZqAhYARHxPt2iJkm1Q", "37.7799", "-122.4168"], "Palace of Fine Arts Theatre": ["ChIJz0_rX9WGhYARrtB9AwkQsno", "37.8029", "-122.4484"], "Japanese Tea Garden": ["ChIJhVvouY-AhYARt6oYQBabsr8", "37.7701", "-122.4704"], "San Francisco Cable Car Museum": ["ChIJX1oMlvKAhYARNZquwetszd8", "37.7947", "-122.4117"], "Muir Woods": ["ChIJrWJnvbSRhYAR-a__aHZY_3o", "37.8954", "-122.5781"], "San Francisco Museum of Modern Art": ["ChIJ53I1Yn2AhYAR_Vl1vNygfMg", "37.7855", "-122.4009"], "Legion of Honor": ["ChIJmUsJz6yHhYARS9zv8DkGiEQ", "37.7845", "-122.5008"], "San Francisco-Oakland Bay Bridge": ["ChIJ8yqBQBOAhYARU-WeAqu8_K4", "37.7983", "-122.3778"], "Crissy Field": ["ChIJVbMlhdyGhYARADaqASKRFVs", "37.8039", "-122.4641"], "Walt Disney Family Museum": ["ChIJ5f7ZKtiGhYAR9WaYFS6bH1U", "37.8014", "-122.4587"], "Cliff House, San Francisco": ["ChIJ7dtznbWHhYAR81fEwzi58F4", "37.7785", "-122.5140"], "Musée Méchanique": ["ChIJCQAzVOKAhYARuOpiALmomu0", "37.8097", "-122.4167"], "Conservatory of Flowers": ["ChIJ5abCmkWHhYARH3zgiLVc_Ew", "37.7726", "-122.4603"], "San Francisco Maritime National Historical Park": ["ChIJ7bPtqOGAhYARlc1YRlOfGrc", "37.8077", "-122.4241"], "Angel Island": ["ChIJ1Rtu3uyDhYARYkTv738oYhk", "37.8609", "-122.4326"], "Ripley's Believe It or Not! Museum": ["ChIJf1rSC-OAhYARTxu37gYw8RU", "37.7750", "-122.4183"], "Land's End": ["ChIJud4Rs7KHhYARZX7u45tQsjA", "37.7849", "-122.5075"], "Fort Point, San Francisco": ["ChIJ_fRRLeqGhYAROWsCl5027X8", "37.8106", "-122.4771"], "Painted Ladies": ["ChIJuX92JKWAhYARxVmeb8DQIYQ", "37.7763", "-122.4327"], "Yerba Buena Gardens": ["ChIJCUsDnIeAhYARWCBpPTrHJpQ", "37.7848", "-122.4027"], "Grace Cathedral": ["ChIJY0dQvZKAhYARcB4643GOKCE", "37.7920", "-122.4134"], "Mission San Francisco de Asís": ["ChIJFcynIBl-j4ARhkCe4XekDDs", "37.7644", "-122.4269"], "Ocean Beach": ["ChIJY8btaZSHhYAR_GctC494Hoo", "32.7495", "-117.2470"], "Contemporary Jewish Museum": ["ChIJQ4ofxYeAhYARnLQjgdsj76k", "37.7860", "-122.4037"], "Mission Dolores Park": ["ChIJp3CqeRd-j4ARYI0i8e_kGKY", "37.7598", "-122.4271"], "Marin Headlands": ["ChIJ81s-UdeFhYAR7MRKRpoyDKs", "37.8262", "-122.4997"], "Transamerica Pyramid": ["ChIJKSXBv4qAhYARNoqlkeKg9to", "37.7952", "-122.4028"], "Children's Creativity Museum": ["ChIJt1SMQ4eAhYAR-8dkWSoHKZI", "37.7833", "-122.4021"], "Yerba Buena Center for the Arts": ["ChIJiZyN7IeAhYARfJshHJaQckc", "37.7861", "-122.4020"]]
    
    //var googleMapsView:GMSMapView!
    // Reference to Google map on screen
    
    //IBOutlets
    @IBOutlet weak var mapView: GMSMapView!
    
    // Presents the search results view controller
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
        showPOI()
        
    }
    
    // Goes to current location on map
    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        
        if !didFindMyLocation {
            let myLocation: CLLocation = change![NSKeyValueChangeNewKey] as! CLLocation
            mapView.camera = GMSCameraPosition.cameraWithTarget(myLocation.coordinate, zoom: 14.5)
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
        
        // If the user allows permission
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.requestAlwaysAuthorization()
            locationManager.startUpdatingLocation()
        }
        
    }
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        print("Error while updating location " + error.localizedDescription)
    }
    
    func showPOI() {
        for (place, info) in sfPlaces {
            let sfPlace = place
            let sfPlaceLat = Double(info[1])
            let sfPlaceLong = Double(info[2])
            
            let marker = GMSMarker()
            marker.position = CLLocationCoordinate2DMake(sfPlaceLat!, sfPlaceLong!)
            marker.title = sfPlace
            marker.snippet = "San Francisco"
            marker.map = mapView
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
    
    func locationManager(manager: CLLocationManager, didUpdateLocations myLocation: [CLLocation]) {
        myCoordinates[0] = ((mapView.myLocation?.coordinate.latitude)!)
        myCoordinates[1] = ((mapView.myLocation?.coordinate.longitude)!)
        
        let location = CLLocation(latitude: myCoordinates[0], longitude: myCoordinates[1])
        CLGeocoder().reverseGeocodeLocation(location, completionHandler: { (placemarks, error) -> Void in
            
            // Place details
            var placeMark: CLPlacemark!
            placeMark = placemarks?[0]
            
            // Location name
            if let locationName = placeMark.addressDictionary!["Name"] as? NSString {
                self.streetAddress = locationName as String
            }
            
            // City
            if let city = placeMark.addressDictionary!["City"] as? NSString {
                self.currentCity = city as String
                print(self.currentCity)
            }
            
            // Country
            if let country = placeMark.addressDictionary!["Country"] as? NSString {
                self.currentCountry = country as String
            }
        })
       self.locationManager.stopUpdatingLocation()
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


