//
//  ShareViewController.swift
//  Gem City Beta
//
//  Created by Rob Block on 7/1/15.
//  Copyright (c) 2015 Edrick Pascual. All rights reserved.
//

import UIKit
import MessageUI
import MapKit
import CoreLocation

class ShareViewController: UIViewController, MFMailComposeViewControllerDelegate, UINavigationControllerDelegate, CLLocationManagerDelegate, MKMapViewDelegate {

    @IBOutlet weak var backgroundMap: MKMapView!
    @IBOutlet weak var facebookButton: UIButton!
    @IBOutlet weak var twitterButton: UIButton!
    @IBOutlet weak var emailButton: UIButton!
    @IBOutlet weak var messageButton: UIButton!
    
    var locationManager = CLLocationManager()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Move the buttons off screen (bottom)
        let translateDown = CGAffineTransformMakeTranslation(0, 500)
        facebookButton.transform = translateDown
        messageButton.transform = translateDown
        
        // Move the buttons off screen (top)
        let translateUp = CGAffineTransformMakeTranslation(0, -500)
        twitterButton.transform = translateUp
        emailButton.transform = translateUp
        
        //Blurring BackgroundMap
        var blurEffect = UIBlurEffect(style: UIBlurEffectStyle.Light)
        var blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = view.bounds
        backgroundMap.addSubview(blurEffectView)
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        
        backgroundMap.delegate = self
        backgroundMap.showsUserLocation = true


    }
    
    override func viewDidAppear(animated: Bool) {
        
        let translate = CGAffineTransformMakeTranslation(0, 0)
        facebookButton.hidden = false
        twitterButton.hidden = false
        emailButton.hidden = false
        messageButton.hidden = false
        
        UIView.animateWithDuration(0.8, delay: 0.0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.5, options: nil, animations: {
            
            self.facebookButton.transform = translate
            self.emailButton.transform = translate
            
            }, completion: nil)
        
        UIView.animateWithDuration(0.8, delay: 0.5, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.5, options: nil, animations: {
            
            self.twitterButton.transform = translate
            self.messageButton.transform = translate
            
            }, completion: nil)
        
    }
    
    func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate,
            regionRadius * 2.0, regionRadius * 2.0)
        
        backgroundMap.setRegion(coordinateRegion, animated: false)
    }
    
    let regionRadius: CLLocationDistance = 200
    
    // MARK: - EMAIL CONFIG
    @IBAction func contactUsButton(sender: UIButton) {
        if MFMailComposeViewController.canSendMail() {
            var composer = MFMailComposeViewController()
            
            composer.mailComposeDelegate = self
            composer.setToRecipients([""])
            composer.navigationBar.tintColor = UIColor.whiteColor()
            
            //            presentViewController(composer, animated: true, completion: nil)
            presentViewController(composer, animated: true, completion: {
                
                UIApplication.sharedApplication().setStatusBarStyle(.LightContent, animated: false)
                
                //setStatusBarStyle:UIStatusBarStyleLightContent];
                
            })
        }
    }
    
    func mailComposeController(controller: MFMailComposeViewController!, didFinishWithResult result: MFMailComposeResult, error: NSError!) {
        
        switch result.value {
        case MFMailComposeResultCancelled.value:
            println("Mail cancelled")
            
        case MFMailComposeResultSaved.value:
            println("Mail saved")
            
        case MFMailComposeResultSent.value:
            println("Mail sent")
            
        case MFMailComposeResultFailed.value:
            println("Failed to send mail: \(error.localizedDescription)")
            
        default:
            break
        }
        
        // Dismiss the Mail interface
        dismissViewControllerAnimated(true, completion: nil)
    }


}
