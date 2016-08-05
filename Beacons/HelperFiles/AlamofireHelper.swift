//
//  AlamofireHelper.swift
//  Beacons
//
//  Created by Michelle Ho on 7/25/16.
//  Copyright © 2016 Michelle Ho. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

struct AlamofireHelper {
    static func getPlaceInfo(selectedPlaceId: String, completionHandler: (placeDetail: PlaceDetails)->Void) {
        
        let apiToContact = "https://maps.googleapis.com/maps/api/place/details/json?&parameters"
        
        let key = API_KEY
        
        Alamofire.request(.GET, apiToContact, parameters: ["placeid": selectedPlaceId,"key": key]).validate().responseJSON() {
            
            response in
            switch response.result {
            case .Success:
                if let value = response.result.value {
                    let json = JSON(value)
                    
                   //print(json)
                    
                    // Gets place details from JSON file
                    let placeId = json["result"]["place_id"].stringValue
                    var arrayOfPhotoReferences = [String]()
                    let placeName = json["result"]["name"].stringValue
                    let placeHours = json["result"]["opening_hours"]["weekday_text"].stringValue
                    let placeAddress = json["result"]["formatted_address"].stringValue
                    let placeNumber = json["result"]["formatted_phone_number"].stringValue
                    let placeWebsite = json["result"]["website"].stringValue
                    let placeRating = json["result"]["rating"].doubleValue
                    let placeLat = json["result"]["geometry"]["location"]["lat"].doubleValue
                    let placeLong = json["result"]["geometry"]["location"]["lng"].doubleValue
                    
                    for (reference, subJson) in json["result"]["photos"] {
                        if let photo_reference = subJson["photo_reference"].string {
                            arrayOfPhotoReferences.append(photo_reference)
                        }
                    }

                    let placeDetail = PlaceDetails(placeId: placeId, name: placeName, hours: placeHours, address: placeAddress, phoneNumber: placeNumber, website: placeWebsite, rating: placeRating, references: arrayOfPhotoReferences, lat: placeLat, long: placeLong, isVisited: false)
                    
                    completionHandler(placeDetail: placeDetail)
                }
            case .Failure(let error):
                print(error)
            }
        }
    
    
    }
    // Creates new array of photos using photo references
    static func getPhotos(references: [String], completionHandler: (arrayOfPhotos: [String])->Void) {
        
        let apiToContact = "https://maps.googleapis.com/maps/api/place/photo?parameters"
        let key = API_KEY
        let maxwidth = 400
        var arrayOfPlacePhotoURLs = [String]()

        
        for reference in references {
            arrayOfPlacePhotoURLs.append("https://maps.googleapis.com/maps/api/place/photo?maxwidth=\(maxwidth)&photoreference=\(reference)&key=\(key)")
        }
        
        //print(arrayOfPlacePhotoURLs)
//
//        for reference in references {
//            //arrayOfPlacePhotos.append("photo")
//            Alamofire.request(.GET, apiToContact).validate().responseString() {
//            
//                response in
//                switch response.result {
//                case .Success:
//                    if let value = response.result.value {
//                        let json = JSON(value)
//                        
//                        arrayOfPlacePhotoURLs.append(NSURL)
//                
//                    }
//                case .Failure(let error):
//                    print(error)
//                }
//        
//            }
//        }
        //print(arrayOfPlacePhotos)
    
    
        completionHandler(arrayOfPhotos: arrayOfPlacePhotoURLs)
    }
}