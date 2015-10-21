//
//  UserCell.swift
//  Instagram
//
//  Created by Old Scona on 2014-12-16.
//  Copyright (c) 2014 Old Scona. All rights reserved.
//

import UIKit

var followingUsers: [String] = []

class UserCell: UITableViewCell {
    
    @IBOutlet weak var checkBox: UISwitch!
    
    @IBOutlet weak var label: UILabel!
    
    @IBAction func checkPressed(sender: AnyObject) {
        
        if self.checkBox.on {
            
            followingUsers = PFUser.currentUser()["following"] as [String]
            
            followingUsers.append(self.label.text!)
            
            saveFollowingUsers(followingUsers)
            
        } else {
            
            followingUsers = PFUser.currentUser()["following"] as [String]
            
            let username = self.label.text
            var removeUsername: Int? = nil
            
            for (index, value) in enumerate(followingUsers) {
                
                println(index)
                
                if value == username {
                    
                    removeUsername = index
                    followingUsers.removeAtIndex(removeUsername!)
                    removeUsername = nil
                    
                    saveFollowingUsers(followingUsers)
                    
                }
                
            }
            
        }
        
    }
    
    func saveFollowingUsers(array: [String]) {
        
        let currentUser = PFUser.currentUser()
        currentUser.setObject(array, forKey: "following")
        
        currentUser.saveInBackgroundWithBlock({(success, error) in
            
            
        })

    }

}