//
//  RealmHelper.swift
//  Beacons
//
//  Created by Michelle Ho on 7/28/16.
//  Copyright © 2016 Michelle Ho. All rights reserved.
//

import Foundation
import RealmSwift

class RealmHelper {
    static func doSomething() {
    }
    
    static func newPlace(place: VisitedPlaces) {
        let realm = try! Realm()
        try! realm.write() {
            realm.add(place)
        }
    }
    
    static func deletePlace(place: VisitedPlaces) {
        let realm = try! Realm()
        try! realm.write() {
            realm.delete(place)
        }
    }
    
    static func retrievePlace() -> Results<VisitedPlaces> {
        let realm = try! Realm()
        return realm.objects(VisitedPlaces)
    }
    
    //    static func retrievePlaceById(placeId: String) -> Results<VisitedPlaces> {
    //        let realm = try! Realm()
    //        return realm.objects(VisitedPlaces.self).filter("placeId contains \(placeId)")
    //    }
}