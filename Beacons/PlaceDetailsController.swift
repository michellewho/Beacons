//
//  PlaceDetailsController.swift
//  Beacons
//
//  Created by Michelle Ho on 7/21/16.
//  Copyright © 2016 Michelle Ho. All rights reserved.
//

import UIKit

class PlaceDetailsController: UIViewController {
    var placeDetails: PlaceDetails!
    
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var placeName: UILabel!
    @IBOutlet weak var cityState: UILabel!
    @IBOutlet weak var beaconButton: UIButton!

    @IBOutlet weak var placeCollectionView: UICollectionView!
    @IBOutlet weak var placeImageView: UIImageView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // placeName Label Settings
        placeName.text = placeDetails.name
    }
    
}

//extension PlaceDetailsController: UICollectionViewDataSource {
//    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
//        return 1
//    }
//    
//    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        let referenceArray = placeDetails.references
//        return referenceArray.count
//    }
//    
//    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
//        return cell
//    }
//}
