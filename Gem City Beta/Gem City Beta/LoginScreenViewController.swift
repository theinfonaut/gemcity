//
//  LoginScreenViewController.swift
//  Gem City Beta
//
//  Created by Edrick Pascual on 6/29/15.
//  Copyright (c) 2015 Edrick Pascual. All rights reserved.
//

import UIKit
import Parse

class LoginScreenViewController: UIViewController {

    
    var signupActive = true
    
    @IBOutlet var username: UITextField!
    
    @IBOutlet var password: UITextField!
    
    @IBOutlet var signupOutletButton: UIButton!
    
    @IBOutlet var registeredText: UILabel!
    
    @IBOutlet var loginButton: UIButton!
    
    
    
    var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
    
    func displayAlert(title: String, message: String) {

        var alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction((UIAlertAction(title: "OK", style: .Default, handler: { (action) -> Void in
            
            self.dismissViewControllerAnimated(true, completion: nil)
            
        })))
        
        self.presentViewController(alert, animated: true, completion: nil)
        
        
    }

    
    
    @IBAction func login(sender: AnyObject) {
        
        if signupActive == true {
            
            signupOutletButton.setTitle("Login", forState: UIControlState.Normal)
            
            registeredText.text = "Not Registered"
            
            loginButton.setTitle("Sign Up", forState: UIControlState.Normal)
            
            signupActive = false
        
        } else {
            
            signupOutletButton.setTitle("Sign Up", forState: UIControlState.Normal)
            
            registeredText.text = "Already Registered"
            
            loginButton.setTitle("Login", forState: UIControlState.Normal)
            
            signupActive = true
            
            
            
        }
        
        
        
        
    }
    
    @IBAction func signUp(sender: AnyObject) {
        
        if username.text == "" || password.text == "" {
           
            displayAlert("Error in form", message: "Please enter a username and password")
            
        } else {
            
            // MARK - Spinner display
            activityIndicator = UIActivityIndicatorView(frame: CGRectMake(0, 0, 50, 50))
            activityIndicator = UIActivityIndicatorView(frame: CGRectMake(0, 0, 50, 50))
            activityIndicator.center = self.view.center
            activityIndicator.hidesWhenStopped = true
            activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.Gray
            view.addSubview(activityIndicator)
            activityIndicator.startAnimating()
            UIApplication.sharedApplication().beginIgnoringInteractionEvents()
        
            
            var errorMessage = "Please try again later"
            
            // MARK - Check Login user
            
            if signupActive == true {
            
            // MARK - Add User for Parse
            
            var user = PFUser()
            user.username = username.text
            user.password = password.text
            
            
            user.signUpInBackgroundWithBlock({ (success, error) -> Void in
                
                self.activityIndicator.stopAnimating()
                UIApplication.sharedApplication().endIgnoringInteractionEvents()
            
                if error == nil {
                    
                    // Signup successful
                    self.performSegueWithIdentifier("login", sender: self)
                    
                } else {
                    
                    if let errorString = error!.userInfo?["error"] as? String {

                        errorMessage = errorString
                    
                }
                
                    self.displayAlert("Failed Signup", message: errorMessage)
                
                }
                
                
            })
            
        } else {
                
            PFUser.logInWithUsernameInBackground(username.text, password: password.text, block: { (user, error) -> Void in
                
                self.activityIndicator.stopAnimating()
                UIApplication.sharedApplication().endIgnoringInteractionEvents()
                
                if user != nil {
                    
                    //Logged in
                    self.performSegueWithIdentifier("login", sender: self)
                    
                } else {
                    
                    if let errorString = error!.userInfo?["error"] as? String {
                        
                        errorMessage = errorString
                        
                    }
                    
                    self.displayAlert("Failed Login", message: errorMessage)
                    
                }
                
            })
            
            
        }
        
    }
    
    
    
     func viewDidLoad() {
        super.viewDidLoad()
        
        let testObject = PFObject(className: "TestObject")
        testObject["foo"] = "bar"
        testObject.saveInBackgroundWithBlock { (success: Bool, error: NSError?) -> Void in
            println("Object has been saved.")
        }

       
    }

     func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */


    }
}