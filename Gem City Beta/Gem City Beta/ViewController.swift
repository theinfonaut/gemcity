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
import CoreLocation


class ViewController: UIViewController, CLLocationManagerDelegate {
    @IBOutlet weak var theMap: MKMapView!
 
    @IBOutlet weak var score: UILabel!
    var locationManager = CLLocationManager()
    @IBAction func zoomToCurrentLocation(mapView: MKMapView) {
        zoomToUserLocationInMapView(theMap)
    }
    
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
        theMap.delegate = self
        theMap.showsUserLocation = true
        var location:CLLocationCoordinate2D = CLLocationCoordinate2DMake(initialLocation.coordinate.latitude, initialLocation.coordinate.longitude)
        collectingAnnotations(initialLocation)
        //locationManagerTemp(locationManager, didUpdateLocations: alltrees)
        
        
    }
    
    func  zoomToUserLocationInMapView(mapView: MKMapView) {
        if let coordinate = theMap.userLocation.location?.coordinate {
            let region = MKCoordinateRegionMakeWithDistance(coordinate, 20, 20)
            theMap.setRegion(region, animated: true)
        }
    }
    
    func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate,
            regionRadius * 2.0, regionRadius * 2.0)
        theMap.setRegion(coordinateRegion, animated: false)
    }
    
    let regionRadius: CLLocationDistance = 200
    
    
    
    
    func locationManager(manager: CLLocationManager!, didUpdateToLocation newLocation: CLLocation!, fromLocation oldLocation: CLLocation!) {
        collectingAnnotations(newLocation)
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
                var counter = 0
                for treesJSON in jsonArray
                {
                    if let trees = Trees.fromJSON(treesJSON) {
                       
                        if counter % 10 == 0 {
                             alltrees.append(trees)
                        }
                    }
                    counter++
                }
        }
        
        
        // collecting "gems" in this case trees
        
    }
    
    
    func collectingAnnotations(userLocation: CLLocation) {
//        var userRadius = MKMapRect(origin: MKMapPointForCoordinate(userLocation.coordinate), size: MKMapSize(width: 10000, height: 10000))
//        let annotations = theMap.annotationsInMapRect(userRadius)
//        println(annotations.count)
//        for annotation in annotations {
//        theMap.removeAnnotation(annotation as! MKAnnotation)
       // }
         var userLocation = CLLocation(latitude: userLocation.coordinate.latitude, longitude: userLocation.coordinate.longitude)
        
        for (var i = 0; i < alltrees.count; i++) {
            
            if alltrees[i].hasBeenCollected == false {
                let currentTreeLocation = CLLocation(latitude: alltrees[i].coordinate.latitude, longitude: alltrees[i].coordinate.longitude)
                
                if (userLocation.distanceFromLocation(currentTreeLocation) < 300) {
                    //they collect the gem
                    println("lat: \(alltrees[i].coordinate.latitude) lon:  \(alltrees[i].coordinate.longitude)")
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
    
    



