//
//  TabBarController.swift
//  SquadUp
//
//  Created by Michael Oudenhoven on 3/14/16.
//  Copyright © 2016 CS 407. All rights reserved.
//

import UIKit
import Firebase

class TabBarController: UITabBarController {

    //MARK: - Properties
    var userUID : String?
    
    var allUsers = [Player]()
    let usersRef = Firebase(url: "https://squadupcs407.firebaseio.com/users")
    
    var user : Player?
    var userFriends = [Player]()
    
    
    //orange color for the views
    let orange = UIColor(red: 0.86, green: 0.49, blue: 0.19, alpha: 1.0)
    
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        UITabBar.appearance().tintColor = orange
        UITabBar.appearance().barTintColor = UIColor.blackColor()

        
        //self.tabBar.layer.backgroundColor = UIColor.blackColor().CGColor

        // Do any additional setup after loading the view.
        

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        usersRef.observeEventType(.ChildAdded, withBlock: { snapshot in
            //create the player and add it to the allusers array
            let uid = snapshot.value["uid"] as? String
            let player = Player(snapshot: snapshot, uid: uid!)
            self.allUsers.append(player)
            
            
        })
        
        let playerRef = usersRef.childByAppendingPath(userUID!)
        
        //get player information and make player object
        playerRef.observeSingleEventOfType(.Value, withBlock: { (snapshot) in
            //get the player reference
            self.user = Player(snapshot: snapshot, uid: self.userUID!)
            
            
        })
        

    }
    
    override func viewDidAppear(animated: Bool) {
        //loop through all the friends UID's and add the player object that matches from the all users array
        for friendUID in (self.user?.friends)! {
            
            //loop through the array of all of the users to find the user that they are friends with
            for player in allUsers {
                if friendUID == player.uid {
                    //user found, add their player object to the array and break from interior loop
                    userFriends.append(player)
                    break
                }
            }
            
        }
        
        let friendController = self.viewControllers![2] as? FriendsViewController
        friendController?.friends = self.userFriends
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
