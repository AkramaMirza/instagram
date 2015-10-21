//
//  postViewController.swift
//  Instagram
//
//  Created by Old Scona on 2014-12-17.
//  Copyright (c) 2014 Old Scona. All rights reserved.
//

import UIKit

class postViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    var photoSelected: Bool = false

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var captionTextField: UITextField!
    
    @IBAction func chooseImage(sender: AnyObject) {
        
        var image = UIImagePickerController()
        image.delegate = self
        image.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        image.allowsEditing = false
        
        self.presentViewController(image, animated: true, completion: nil)
        
    }
    
    func imagePickerController(picker: UIImagePickerController!, didFinishPickingImage image: UIImage!, editingInfo: [NSObject : AnyObject]!) {
        
        self.dismissViewControllerAnimated(true, completion: nil)
        
        imageView.image = image
        
        photoSelected = true
    }

    
    @IBAction func post(sender: AnyObject) {
        
        if !photoSelected {
            
            displayErrorAlert("Please select an image")
            
        } else if captionTextField.text == ""{
            
            displayErrorAlert("Please enter a caption")
            
        } else {
            
            var post = PFObject(className: "Post")
            post.setValue(captionTextField.text, forKey: "caption")
            
            let imageData = UIImagePNGRepresentation(imageView.image)
            
            let imageFile = PFFile(name: "image.png", data: imageData)
            
            post.setValue(imageFile, forKey: "imageFile")
            
            post.setValue(PFUser.currentUser().username, forKey: "posterUsername")
            
            post.saveInBackgroundWithBlock({(success: Bool!, error: AnyObject!) in
                
                if success == false {
                    /*
                    let anyDict = error.userInfo as NSDictionary!
                    let errorDict = anyDict["error"] as NSError!
                    let userInfo = errorDict.userInfo as NSDictionary!
                    let errorString = userInfo["NSLocalizedDescription"] as String!
                    
                    
                    println("STARTS HERE: ----> \(errorString)") //
                    
                    //self.displayErrorAlert(errorString) // not working
                    */

                } else {
                    
                    self.displayErrorAlert("Image posted successfully!")
                    
                    self.photoSelected = false
                    
                    self.imageView.image = UIImage(named: "placeholder.jpg")
                    
                    self.captionTextField.text = ""
                    
                }
                
            })
        
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        photoSelected = false
        
        imageView.image = UIImage(named: "placeholder.jpg")
        
        captionTextField.text = ""

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func displayErrorAlert(message: String) {
        
        var alert = UIAlertController(title: "Error", message: message, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: { (action) in
            
            self.dismissViewControllerAnimated(true, completion: nil)
            
        }))
        
        self.presentViewController(alert, animated: true, completion: nil)
        
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
