//
//  TabBarController.swift
//  SquadUp
//
//  Copyright © 2016 CS 407. All rights reserved.
//

import UIKit
import Firebase

class TabBarController: UITabBarController {

    //MARK: - Properties
    var userUID : String?
    
    var allUsers = [Player]()
    var numUsers : Int?
    let usersRef = Firebase(url: "https://squadupcs407.firebaseio.com/users")
    
    var user : Player?
    var userFriends = [Player]()
    
    var firstLoad = true
    
    let numUsersRef = Firebase(url: "https://squadupcs407.firebaseio.com/numUsers")
    
    //orange color for the views
    let orange = UIColor(red: 0.86, green: 0.49, blue: 0.19, alpha: 1.0)
    
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        UITabBar.appearance().tintColor = orange
        UITabBar.appearance().barTintColor = UIColor.blackColor()

        
        //self.tabBar.layer.backgroundColor = UIColor.blackColor().CGColor

        // Do any additional setup after loading the view.
        

        //get the number of users so it can add friends at the correct time

        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        
        if firstLoad {
            numUsersRef.observeSingleEventOfType(.Value, withBlock: { (snapshot) in
                self.numUsers = snapshot.value as? Int
                
                
                let playerRef = self.usersRef.childByAppendingPath(self.userUID!)
                
                //get player information and make player object
                playerRef.observeSingleEventOfType(.Value, withBlock: { (snapshot) in
                    //get the player reference
                    self.user = Player(snapshot: snapshot, uid: self.userUID!)
                    
                    
                })
                
                
                
                self.usersRef.observeEventType(.ChildAdded, withBlock: { snapshot in
                    
                    //create the player and add it to the allusers array
                    let uid = snapshot.value["uid"] as? String
                    
                    let player = Player(snapshot: snapshot, uid: uid!)
                    
                    //add it to the users only if it isn't the person using the app - that way won't find themselves
                    //when searching for friends
                    if uid != self.user?.uid {
                        self.allUsers.append(player)
                    }
                    
                    //print(self.numUsers)
                    
                    //if it is the first time the tab bar is loaded load the friends of the user
                    //subtract one so yourself is counted as a user
                    if self.firstLoad && self.allUsers.count == (self.numUsers!-1){
                        //loop through all the friends UID's and add the player object that matches from the all users array
                        for friendUID in (self.user?.friends)! {
                            
                            //loop through the array of all of the users to find the user that they are friends with
                            for player in self.allUsers {
                                if friendUID == player.uid {
                                    //user found, add their player object to the array and break from interior loop
                                    self.userFriends.append(player)
                                    break
                                }
                            }
                            
                        }
                        let friendController = self.viewControllers![2] as? FriendsViewController
                        friendController?.friends = self.userFriends
                        friendController?.allUsers = self.allUsers
                        friendController?.user = self.user
                        self.firstLoad = false
                        if friendController?.tableView != nil {
                            friendController?.tableView.reloadData()
                        }
                        
                    }
                    
                })
                
            })
        }

        


    }
    
    
    override func viewDidAppear(animated: Bool) {
//        //if it is the first time the tab bar is loaded load the friends of the user
//        if firstLoad {
//            //loop through all the friends UID's and add the player object that matches from the all users array
//            for friendUID in (user?.friends)! {
//                
//                //loop through the array of all of the users to find the user that they are friends with
//                for player in allUsers {
//                    if friendUID == player.uid {
//                        //user found, add their player object to the array and break from interior loop
//                        userFriends.append(player)
//                        break
//                    }
//                }
//                
//            }
//            let friendController = self.tabBarController!.viewControllers![2] as? FriendsViewController
//            friendController?.friends = (self.tabBarController as? TabBarController)!.userFriends
//            firstLoad = false
//        }


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
