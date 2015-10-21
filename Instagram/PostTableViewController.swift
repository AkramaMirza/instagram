//
//  PostTableViewController.swift
//  Instagram
//
//  Created by Old Scona on 2014-12-18.
//  Copyright (c) 2014 Old Scona. All rights reserved.
//

import UIKit

class PostTableViewController: UITableViewController {
    
    var posts: [PFObject] = []
    var followingUsers: [String] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    override func viewWillAppear(animated: Bool) {
        /*
        var toolbarView = UIToolbar(frame: CGRectMake(0, self.view.frame.height - 60, self.view.frame.width, 44))
        
        let showUsersButton = UIBarButtonItem(title: "Show Users", style: UIBarButtonItemStyle.Bordered, target: self, action: Selector()) // fix action, it does action on load
        
        let toolbarBtns = [showUsersButton]
        
        toolbarView.setItems(toolbarBtns, animated: true)
        
        self.navigationController?.navigationBar.addSubview(toolbarView)
        */
        followingUsers = []
        
        posts = []
        
        let currentUser = PFUser.currentUser()
        
        if currentUser == nil {
            
            self.performSegueWithIdentifier("feedToLogin", sender: self)
            
        } else {
            
            currentUser.fetchInBackgroundWithBlock({(user, error) in
                
                self.followingUsers = user.valueForKey("following") as [String]
                                
                if self.followingUsers != [] {
                    
                    self.getPosts(0, array: [AnyObject]())
                                        
                } else {
                    
                    self.performSegueWithIdentifier("feedToEditFollowing", sender: self)
                    
                }
                
            })
            
        }

    }
    
    func getPosts(position: Int!, array: [AnyObject]!) {
        
        var tempArray = array as [PFObject]
        
        if position < followingUsers.count {
            
            var query = PFQuery(className: "Post")
            
            query.whereKey("posterUsername", equalTo: followingUsers[position])
            
            query.findObjectsInBackgroundWithBlock({(objects: [AnyObject]!, error: NSError!) in
                
                for post: PFObject in objects as [PFObject] {
                    
                    tempArray.append(post)
                    
                }
                
                self.getPosts(position + 1, array: tempArray)
                
            })
            
        } else if position == followingUsers.count {
            
            self.posts = tempArray
            
            dispatch_async(dispatch_get_main_queue(), {
                self.tableView.reloadData()
            })
            
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return posts.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell: PostCell = self.tableView.dequeueReusableCellWithIdentifier("postCell", forIndexPath: indexPath) as PostCell
        
        if posts != [] {
            
            let post = posts[indexPath.row] as PFObject
            
            cell.captionLabel.text = (post["caption"] as String)
            
            cell.posterUsernameLabel.text = (post["posterUsername"] as String)
            
            post["imageFile"].getDataInBackgroundWithBlock({(data: NSData!, error: NSError!) in
                
                if error == nil {
                    
                    cell.postImageView.image = UIImage(data: data)
                    
                }

            })
            
        } else {
            
            cell.captionLabel.text = "No caption"
            
            cell.posterUsernameLabel.text = "No username"
            
        }
        
        return cell
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 350
    }

    /*
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath) as UITableViewCell

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

}
