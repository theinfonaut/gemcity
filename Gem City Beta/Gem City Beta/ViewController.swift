//
//  ViewController.swift
//  Gem City Beta
//
//  Created by Edrick Pascual on 6/19/15.
//  Copyright (c) 2015 Edrick Pascual. All rights reserved.
//

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

    
    
    }

    
    
    // this method will be call everytime the phone registers a new location
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        
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
        
        // Region based on combining the location and span vars
        var region:MKCoordinateRegion = MKCoordinateRegionMake(location, span)
        
        // Set the area of map region - self since its inside the fun
        self.theMap.setRegion(region, animated: true)
        
        
        println(locations)
        
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

