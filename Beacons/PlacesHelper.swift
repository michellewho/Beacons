//
//  PlacesHelper.swift
//  Beacons
//
//  Created by Michelle Ho on 7/14/16.
//  Copyright © 2016 Michelle Ho. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

struct PlacesHelper {
    
    func getPlaces() {
    
        let currentLocation = ""    // Get lat/lon of either CL or searched location
        let radius = 2200
        let type = "point+of+interest"
        let key = API_KEY
        
        let apiToContact = "https://maps.googleapis.com/maps/api/place/nearbysearch/json?parameters"

    
        Alamofire.request(.GET, apiToContact, parameters: ["location": currentLocation, "radius": radius, "type": type, "key": key]).validate().responseJSON() {
    
            response in
            switch response.result {
            case .Success:
                if let value = response.result.value {
                    let json = JSON(value)
    
                    
                    print(json)
    
    
                }
            case .Failure(let error):
                print(error)
            }
        }
    }

}
