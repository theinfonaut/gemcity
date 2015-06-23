//
//  Trees.swift
//  Gem City Beta
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
    
    init(treeid: String, planttype: String, coordinate: CLLocationCoordinate2D) {
        self.treeid = treeid
        self.planttype = planttype
        self.coordinate = coordinate
        
    super.init()
    }
    
//    var subtitle: String {
//        return planttype
//    }
    
    class func fromJSON(json: [JSONValue]) -> Trees? {
        // 1
        var treeid: String
        if let treeidOrNil = json[16].string {
            treeid = treeidOrNil
        } else {
            treeid = ""
        }
        let planttype = json[12].string
        
        // 2
        let latitude = (json[18].string! as NSString).doubleValue
        let longitude = (json[19].string! as NSString).doubleValue
        let coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        
        // 3
        return Trees(treeid: treeid, planttype: planttype!, coordinate: coordinate)
    }
    
    // pinImage for all pins

}