//
//  Trees.swift
//  Gem City
//
//  Created by Leslie Chicoine on 6/22/15.
//  Copyright (c) 2015 Edrick Pascual. All rights reserved.
//

import Foundation
import MapKit

class Trees: NSObject, MKAnnotation {
    let treeid: String
    let planttype: String
    let coordinate: CLLocationCoordinate2D
    var hasBeenCollected: Bool = false
    
    init(treeid: String, planttype: String, coordinate: CLLocationCoordinate2D) {
        self.treeid = treeid
        self.planttype = planttype
        self.coordinate = coordinate
        
        super.init()
    }
    
    //    var subtitle: String {
    //        return planttype
    //    }
    
    class func fromJSON(json: NSArray) -> Trees? {
        // 1
        
        var latitude: Double? = nil
        if let latString = json[23] as? NSString {
            latitude = latString.doubleValue
        }
        
        var longitude: Double? = nil
        if let longString = json[24] as? NSString {
            longitude = longString.doubleValue}
        
        var treeid: String
        if let treeidOrNil = json[0] as? String {
            treeid = treeidOrNil
        } else {
            treeid = ""
        }
        
        let planttype = json[10] as? String
        
        // location
        
        
        if let latitude = latitude, longitude = longitude, planttype = planttype {
            return Trees(treeid: treeid, planttype: planttype, coordinate: CLLocationCoordinate2D(latitude: latitude, longitude: longitude))
        } else {
            return nil
        }
        
    }
    
    // pinImage for all pins
    
}