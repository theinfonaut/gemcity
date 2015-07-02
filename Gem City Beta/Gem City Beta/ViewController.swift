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
import Parse

class ViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {
    
    @IBOutlet weak var score: UILabel!

    @IBOutlet weak var theMap: MKMapView!
    
    var locationManager = CLLocationManager()
    var alltreesTotal = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        
        // LC - set initial location in SF
       let initialLocation = CLLocation(latitude: 37.7596429, longitude: -122.410573)
        
        centerMapOnLocation(initialLocation)
        
        loadInitialData()
        theMap.addAnnotations(alltrees)
        theMap.showsUserLocation = true
        theMap.delegate = self
        theMap.zoomEnabled = false 
        theMap.scrollEnabled = false
        collectingAnnotations(initialLocation)
       
        
    }

        func centerMapOnLocation(location: CLLocation) {
            let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate,
            regionRadius * 2.0, regionRadius * 2.0)
            
            theMap.setRegion(coordinateRegion, animated: false)
        }
    
        let regionRadius: CLLocationDistance = 200
    
    
    // this method will be call everytime the phone registers a new location
    func locationManager(manager: CLLocationManager!, didUpdateToLocation newLocation: CLLocation!, fromLocation oldLocation: CLLocation!) {
        collectingAnnotations(newLocation)
        
        var userLocation:CLLocation = newLocation
        
        var latitude = userLocation.coordinate.latitude
        var longitude = userLocation.coordinate.longitude
        
        
        // this sets how zoom in or zoomed out the user will be (1 = zoom out, .001 = zoomed in)
        var latDelta:CLLocationDegrees = 0.002
        var lonDelta:CLLocationDegrees = 0.002
        
        // Span - combination of latdelta and londelta
        var span:MKCoordinateSpan = MKCoordinateSpanMake(latDelta, lonDelta)
        
        // Location - coordinates based on longtitude and latitude of user
        var location:CLLocationCoordinate2D = CLLocationCoordinate2DMake(latitude, longitude)
        
        // Region based on combining the location and span vars
        var region:MKCoordinateRegion = MKCoordinateRegionMake(location, span)
        
        // Set the area of map region - self since its inside the fun
        self.theMap.setRegion(region, animated: false)
        
        println(newLocation)
    }

    
    

    // get tree data from json
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
    
    
    
    
    func collectingAnnotations(userLocation: CLLocation) {

        
        for (var i = 0; i < alltrees.count; i++) {
            
            if alltrees[i].hasBeenCollected == false {
                
                let currentTreeLocation = CLLocation(latitude: alltrees[i].coordinate.latitude, longitude:
                    
                    alltrees[i].coordinate.longitude)
                
                if (userLocation.distanceFromLocation(currentTreeLocation) < 50) {
                    
                    //MARK  collecting the gem
                    println("lat: \(alltrees[i].coordinate.latitude) lon: \(alltrees[i].coordinate.longitude)")
                    println("\(i)")
                    alltrees[i].hasBeenCollected = true
                    alltreesTotal += 1
                }
                
                if alltrees[i].hasBeenCollected == true {
                    theMap.removeAnnotation(alltrees[i])
                }
            }
        }
        
        score.text = "\(alltreesTotal)"
    }

    
    
    

    
}
