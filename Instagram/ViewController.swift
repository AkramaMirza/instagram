//
//  ViewController.swift
//  Instagram
//
//  Created by Old Scona on 2014-12-15.
//  Copyright (c) 2014 Old Scona. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var passTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var message: UILabel!
    
    @IBAction func signUp(sender: AnyObject) {
        
        if nameTextField.text != "" && passTextField.text != "" && emailTextField.text != "" {
            
            var newUser = PFUser()
            newUser.username = nameTextField.text
            newUser.password = passTextField.text
            newUser.email = emailTextField.text
            newUser["following"] = []
            
            newUser.signUpInBackgroundWithBlock({(success: Bool!, error: AnyObject!) in
                
                if success == true {
                    
                    self.performSegueWithIdentifier("showFeed", sender: self)
                    
                } else {
                    
                    let userInfo = error.userInfo as NSDictionary
                    let errorString = userInfo["error"] as NSString
                    
                    self.displayErrorAlert(errorString)
                    
                }
            })
            
        } else {
            
            displayErrorAlert("Please fill out all fields")
            
        }
    }
    
    
    
    @IBAction func login(sender: AnyObject) {
        
        if nameTextField.text != "" && passTextField.text != "" {
            
            PFUser.logInWithUsernameInBackground(nameTextField.text, password: passTextField.text) {
                (user: PFUser!, error: AnyObject!) -> Void in
                if user != nil {
                    
                    self.performSegueWithIdentifier("showFeed", sender: self)
                    
                } else {
                    
                    let userInfo = error.userInfo as NSDictionary
                    let errorString = userInfo["error"] as NSString
                    
                    self.displayErrorAlert(errorString)
                    
                }
            }
            
        } else {
            
            displayErrorAlert("Please fill out all fields")
            
        }
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(animated: Bool) {
        self.navigationController?.navigationBarHidden = true
    }
    
    override func viewWillDisappear(animated: Bool) {
        self.navigationController?.navigationBarHidden = false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    
    // ERROR ALERT:
    func displayErrorAlert(message: String) {
        
        var alert = UIAlertController(title: "Error", message: message, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: { (action) in
            
            self.dismissViewControllerAnimated(true, completion: nil)
            
        }))
        
        self.presentViewController(alert, animated: true, completion: nil)
        
    }


}

