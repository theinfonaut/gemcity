//
//  ViewController.swift
//  Gem City Beta
//
//  Created by Edrick Pascual on 6/19/15.
//  Copyright (c) 2015 Edrick Pascual. All rights reserved.
//

// tree locations in SF: https://data.sfgov.org/resource/337t-q2b4.json


import UIKit
import MapKit
//import CoreLocation

class ViewController: UIViewController {

    @IBOutlet weak var theMap: MKMapView!

    let regionRadius: CLLocationDistance = 200

    override func viewDidLoad() {
        super.viewDidLoad()

        // set initial location in SF
        let initialLocation = CLLocation(latitude: 37.7596429, longitude: -122.410573)
        centerMapOnLocation(initialLocation)

        loadInitialData()
        theMap.addAnnotations(alltrees)
        
        theMap.delegate = self
       
        // show trees on map
//        let trees = Trees(treeid: "01010",
//            planttype: "Eucalyptus sideroxylon :: Red Ironbark",
//            coordinate: CLLocationCoordinate2D(latitude: 37.7392189485182, longitude: -122.377869364283))
//        theMap.addAnnotation(trees)
    }

    var alltrees = [Trees]()
    func loadInitialData() {
        // 1
        let fileName = NSBundle.mainBundle().pathForResource("SFTrees", ofType: "json");

        var readError : NSError?
        var data: NSData = NSData(contentsOfFile: fileName!, options: NSDataReadingOptions(0),
            error: &readError)!
        
        // 2
        var error: NSError?
        let jsonObject: AnyObject! = NSJSONSerialization.JSONObjectWithData(data,
            options: NSJSONReadingOptions(0), error: &error)
        
        // 3
        if let jsonObject = jsonObject as? [String: AnyObject] where error == nil,
            // 4
            let jsonArray = jsonObject["data"] as? [NSArray] {
                for treesJSON in jsonArray
                {
                    if let trees = Trees.fromJSON(treesJSON) {
                        alltrees.append(trees)
                    }
            }
        }
    }
    
    func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate,
            regionRadius * 2.0, regionRadius * 2.0)
        theMap.setRegion(coordinateRegion, animated: true)
    }

    
}
