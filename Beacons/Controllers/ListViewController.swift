//
//  ListViewController.swift
//  Beacons
//
//  Created by Michelle Ho on 7/28/16.
//  Copyright © 2016 Michelle Ho. All rights reserved.
//

import UIKit
import RealmSwift

class ListViewController: UIViewController {
    
    @IBOutlet weak var mapButton: UIButton!
    @IBOutlet weak var placesTableView: UITableView!
    
    @IBAction func mapButtonPressed(sender: AnyObject) {
    
    }
    
    var sfplaces: [String: [String]]?
    var places: Results<VisitedPlaces>?
    

    override func viewDidLoad() {
        super.viewDidLoad()
        

    }
}

extension ListViewController: UITableViewDataSource {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sfplaces!.count
    }
    
     func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell") as! PlaceTableViewCell
//        let index = places!.startIndex.advancedBy(indexPath.row)
        cell.placeLabel.text = (Array(sfplaces!.keys)[indexPath.row])
        cell.visitedButton.selected = false
        let values = (Array(sfplaces!.values)[indexPath.row])
        if let places = places {
            for item in places {
                if item.placeId == values[0] {

                    cell.visitedButton.selected = true
                    break
                }
            }
        }
        return cell
        
    }
    
    func tableView(tableView: UITableView!, didSelectRowAtIndexPath indexPath: NSIndexPath!) {
        // Go to PlaceDetailsController with details of place
        let values = (Array(sfplaces!.values)[indexPath.row])
        let selectedPlaceId = values[0]
        
        AlamofireHelper.getPlaceInfo(selectedPlaceId) { (placeDetail) in
            let controller = self.storyboard?.instantiateViewControllerWithIdentifier("PlaceDetailsController") as? PlaceDetailsController
            controller?.placeDetails = placeDetail
            self.presentViewController(controller!, animated: true, completion: nil)
        
        }
    }
}




