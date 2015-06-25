import UIKit
import MapKit
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate {
    @IBAction func zoomToCurrentLocation(mapView: MKMapView) {
        
        if let coordinate = theMap.userLocation.location?.coordinate {
            let region = MKCoordinateRegionMakeWithDistance(coordinate, 37.7596429, -122.410573)
            
        }
    }
    
    func zoomToUserLocationInMapView() {    }
    
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
        collectingAnnotations(initialLocation)
        //locationManagerTemp(locationManager, didUpdateLocations: alltrees)
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
                for treesJSON in jsonArray
                {
                    if let trees = Trees.fromJSON(treesJSON) {
                        alltrees.append(trees)
                    }
                }
        }
        
        
        // collecting "gems" in this case trees
        
    }
    
    
    func collectingAnnotations(userLocation: CLLocation) {
        
        
        // var userLocation = CLLocation(latitude: userLocation2D.latitude, longitude: userLocation2D.longitude)
        
        for (var i = 0; i < alltrees.count; i++) {
            if alltrees[i].hasBeenCollected == false {
                let currentTreeLocation = CLLocation(latitude: alltrees[i].coordinate.latitude, longitude: alltrees[i].coordinate.longitude)
                
                if (userLocation.distanceFromLocation(currentTreeLocation) < 30) {
                    //they collect the gem
                    println(alltrees[i].coordinate.latitude)
                    println(alltrees[i].coordinate.longitude)
                    alltrees[i].hasBeenCollected = true
                }
            }
            
            
        }
        
        
        
        
    }
    
    
    
}