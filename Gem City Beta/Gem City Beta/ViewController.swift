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
    
    var locationManager = CLLocationManager()
    
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
        collectingAnnotations(location)
        //locationManagerTemp(locationManager, didUpdateLocations: alltrees)
    }
    
    func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate,
            regionRadius * 2.0, regionRadius * 2.0)
        theMap.setRegion(coordinateRegion, animated: false)
    }
    
    let regionRadius: CLLocationDistance = 200
    
    
    
    
    // this method will be call everytime the phone registers a new location
    func locationManagerTemp(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        
        var userLocation:CLLocation = locations[0] as! CLLocation
        
        var latitude = userLocation.coordinate.latitude
        var longitude = userLocation.coordinate.longitude
        
        // this sets how zoom in or zoomed out the user will be (1 = zoom out, .001 = zoomed in)
        var latDelta:CLLocationDegrees = 0.002
        
        var lonDelta:CLLocationDegrees = 0.002
        
        // Span - combination of latdelta and londelta
        var span:MKCoordinateSpan = MKCoordinateSpanMake(latDelta, lonDelta)
        
        // Location - coordinates based on longtitude and latitude of user
        var location:CLLocationCoordinate2D = CLLocationCoordinate2DMake(latitude, longitude)
        collectingAnnotations(location)
        
        // Region based on combining the location and span vars
        var region:MKCoordinateRegion = MKCoordinateRegionMake(location, span)
        
        // Set the area of map region - self since its inside the fun
        self.theMap.setRegion(region, animated: false)
        
        println(locations)
        
      
        
        //        MKPinAnnotationView.customPinView = UIImage imageNamed:@"myCarImage.png"];
        //
        //
        
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
        // collecting "gems" in this case trees
        
    }
    
    
    func collectingAnnotations(userLocation2D: CLLocationCoordinate2D) {
        
        
        var userLocation = CLLocation(latitude: userLocation2D.latitude, longitude: userLocation2D.longitude)
        
        for (var i = 0; i < alltrees.count; i++) {
            let currentTreeLocation = CLLocation(latitude: alltrees[i].coordinate.latitude, longitude: alltrees[i].coordinate.longitude)
            
            if (userLocation.distanceFromLocation(currentTreeLocation) < 1000) {
                //they collect the gem
                println("collected")
            }
        }
        
        
        
        //            let locattionnotification = UILocalNotification()
        //            locattionnotification.alertBody = "Collected!"
        //            locattionnotification.regionTriggersOnce = false
        //            locattionnotification.region = CLCircularRegion(circularRegionWithCenter: CLLocationCoordinate2D(latitude:
        //                latitude, longitude: longitude), radius: 30, identifier: "trees")
        //            UIApplication.sharedApplication().scheduleLocalNotification(locattionnotification)
        
        
    }

    
//    var manager: CLLocationManager?
//
//    @IBOutlet weak var mapView: MKMapView!
//    @IBOutlet weak var address: UILabel!
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        manager = CLLocationManager()
//        manager?.delegate = self;
//        manager?.desiredAccuracy = kCLLocationAccuracyBest
//        
//    }
//    
//    override func didReceiveMemoryWarning() {
//        super.didReceiveMemoryWarning()
//        // Dispose of any resources that can be recreated.
//    }
//    
//    
//    @IBAction func getLocation(sender: AnyObject) {
//        let available = CLLocationManager.isMonitoringAvailableForClass(CLCircularRegion)
//        manager?.requestWhenInUseAuthorization()
//        manager?.startUpdatingLocation()
//        
//        
//    }
//    
//    
//    @IBAction func regionMonitoring(sender: AnyObject) {
//        manager?.requestAlwaysAuthorization()
//        
//        let currRegion = CLCircularRegion(center: CLLocationCoordinate2D(latitude: 37.411822, longitude: -121.941125), radius: 200, identifier: "Home")
//        manager?.startMonitoringForRegion(currRegion)
//        
//    }
//    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
//        manager.stopUpdatingLocation()
//        let location = locations[0] as! CLLocation
//        CLPlacemark(
//                    let placeMarks = alltrees as [CLPlacemark]
//            let loc: CLPlacemark = placeMarks[0]
//            
//            self.mapView.centerCoordinate = location.coordinate
//            let addr = loc.locality
//            self.address.text = addr
//            let reg = MKCoordinateRegionMakeWithDistance(location.coordinate, 1500, 1500)
//            self.mapView.setRegion(reg, animated: true)
//            self.mapView.showsUserLocation = true
//            
//        }
//    }
//    
//    func locationManager(manager: CLLocationManager!, didEnterRegion region: CLRegion!) {
//        NSLog("Entering region")
//    }
//    
//    func locationManager(manager: CLLocationManager!, didExitRegion region: CLRegion!) {
//        NSLog("Exit region")
//    }
//    
//    func locationManager(manager: CLLocationManager!, didFailWithError error: NSError!) {
//        NSLog("\(error)")
//    }

    




}

