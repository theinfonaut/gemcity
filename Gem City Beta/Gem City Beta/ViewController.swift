//
//  ViewController.swift
//  Gem City
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
        theMap.showsUserLocation = true
        
        loadInitialData()
        theMap.addAnnotations(alltrees)
        theMap.delegate = self
        theMap.zoomEnabled = false
        theMap.scrollEnabled = true
        collectingAnnotations(initialLocation)
        //paning enabled, zoom enabled = false
    }
    
    func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate,
            regionRadius * 2.0, regionRadius * 2.0)
        theMap.setRegion(coordinateRegion, animated: false)
    }
    
    let regionRadius: CLLocationDistance = 100
    
    // this method will be call everytime the phone registers a new location
    func locationManager(manager: CLLocationManager!, didUpdateToLocation newLocation: CLLocation!, fromLocation oldLocation: CLLocation!) {
        collectingAnnotations(newLocation)

        var userLocation:CLLocation = newLocation
        //[0] as! CLLocation
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
                //var counter = 0
                for treesJSON in jsonArray
                {
                    if let trees = Trees.fromJSON(treesJSON) {
                        //if counter % 10 == 0 {
                        alltrees.append(trees)
                        //}
                    }
                    //counter++
                }
        }
    }
    
//  Add an overlay over the user's current location
//    
//    func mapView(mapView: MKMapView!, rendererForOverlay overlay: MKOverlay!) -> MKOverlayRenderer! {
//        if overlay is MKCircle {
//            var circleRenderer = MKCircleRenderer(overlay: overlay)
//            circleRenderer.lineWidth = 1.0
//            circleRenderer.strokeColor = UIColor.purpleColor()
//            circleRenderer.fillColor = UIColor.purpleColor().colorWithAlphaComponent(0.4)
//            return circleRenderer
//        }
//        return nil
//    }

    
    func collectingAnnotations(userLocation: CLLocation) {
        //        var userRadius = MKMapRect(origin: MKMapPointForCoordinate(userLocation.coordinate), size: MKMapSize(width: 10000, height: 10000))
        //        let annotations = theMap.annotationsInMapRect(userRadius)
        //        println(annotations.count)
        //        for annotation in annotations {
        //        theMap.removeAnnotation(annotation as! MKAnnotation)
        // }
       // var userLocation = CLLocation(latitude: userLocation.coordinate.latitude, longitude: userLocation.coordinate.longitude)

        for (var i = 0; i < alltrees.count; i++) {

            if alltrees[i].hasBeenCollected == false {
                let currentTreeLocation = CLLocation(latitude: alltrees[i].coordinate.latitude, longitude: alltrees[i].coordinate.longitude)
                if (userLocation.distanceFromLocation(currentTreeLocation) < 50) {
                    //they collect the gem
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