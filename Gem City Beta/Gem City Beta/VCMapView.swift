//
//  VCMapView.swift
//  Gem City Beta
//
//  Created by Leslie Chicoine on 6/22/15.
//  Copyright (c) 2015 Edrick Pascual. All rights reserved.
//

import MapKit

extension ViewController: MKMapViewDelegate {
    
    // 1
    func theMap(theMap: MKMapView!, viewForAnnotation annotation: MKAnnotation!) -> MKAnnotationView! {
        if let annotation = annotation as? Trees {
            let identifier = "pin"
            var view: MKPinAnnotationView
            if let dequeuedView = theMap.dequeueReusableAnnotationViewWithIdentifier(identifier)
                as? MKPinAnnotationView {
    // 2
                    dequeuedView.annotation = annotation
                    view = dequeuedView
            } else {
    // 3
                view = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
                view.canShowCallout = true
                view.calloutOffset = CGPoint(x: -5, y: 5)
                view.rightCalloutAccessoryView = UIButton.buttonWithType(.DetailDisclosure) as! UIView

            }
            return view
        }
        return nil
    }
}