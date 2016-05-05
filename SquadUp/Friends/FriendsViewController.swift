//
//  FourthViewController.swift
//  SquadUp
//
//  Created by Michael Oudenhoven on 3/5/16.
//  Copyright © 2016 CS 407. All rights reserved.
//

import UIKit
import Firebase

class FriendsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate  {

    //MARK: - Properties
    
    let friendCellID = "friendCell"
    //friends are an array of players to be loaded
    var friends = [Player]()
    @IBOutlet weak var tableView: UITableView!
    
    
    var allUsers = [Player]()
    var filteredUsers = [Player]()
    
    let searchController = UISearchController(searchResultsController: nil)
    
    let usersRef = Firebase(url: "https://squadupcs407.firebaseio.com/users")
    var user : Player?
    
    var unfriendAlert : UIAlertController?
    
    //cell star button that is clicked
    var cellClicked : FriendTableViewCell?
    
    //MARK: - Lifecycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //get all the users loaded in the tab bar
        allUsers = (self.tabBarController as! TabBarController).allUsers

        //get the user object from the tab bar controller
        user = (self.tabBarController as? TabBarController)?.user
        
        //add users to all users array here - done in tab bar controller
        //add users to friends array here - done in tab bar controller
        
        //setup the table searching
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        definesPresentationContext = true
        tableView.tableHeaderView = searchController.searchBar
        searchController.searchBar.placeholder = "Search by email or name..."
        
        
        //initialize the unfriend alert
        initializeUnfriendAlert()
        

        
    }
    
    override func viewWillAppear(animated: Bool) {

        //all users loaded in initialization of tab bar controller
        
    }
    
    override func viewDidAppear(animated: Bool) {
        //print(allUsers)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    
    //MARK: - Table View Delegate
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        //selected row, go to friends profile
        let friend: Player
        if searchController.active && searchController.searchBar.text != "" {
            friend = filteredUsers[indexPath.row]
        } else {
            friend = friends[indexPath.row]
        }
        
        self.performSegueWithIdentifier("toProfileDetailViewController", sender: friend)
        
        //delselect the row so that when the game detail is popped off there isn't a cell stil highlighted
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
    }
    
    //MARK: - Table View Data Source
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //check if the user is currently using the search

        
        
        //return users number of friends or filtered users
        
        if searchController.active && searchController.searchBar.text != "" {
            return filteredUsers.count
        }
        return friends.count
        
        
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(friendCellID, forIndexPath: indexPath) as! FriendTableViewCell
        
        let friend: Player
        if searchController.active && searchController.searchBar.text != "" {
            friend = filteredUsers[indexPath.row]
        } else {
            friend = friends[indexPath.row]
        }

        cell.friendButton.addTarget(self, action: #selector(FriendsViewController.friendButtonClicked(_:)), forControlEvents: .TouchUpInside)
        //set the player object so they can be added removed from list
        cell.player = friend
        
        //player the cell represents
        cell.friendNameLabel.text = friend.name
        
        //check if the current user is a friend
        cell.isFriend = isUserAFriend(friend)
        
        //person is the users friend
        if cell.isFriend {
            //change to star highlighted if the user is already a friend (check UID)
            cell.friendButton.setImage(UIImage(named: "star_highlighted"), forState: .Normal)
            
        }
        //not a friend - blank star
        else {
            //change to star highlighted if the user is already a friend (check UID)
            cell.friendButton.setImage(UIImage(named: "star_unhighlighted"), forState: .Normal)
        }

        
        
        
        return cell
    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "toProfileDetailViewController" {
            //give the profile detail the user to be displayed
            let destVC = segue.destinationViewController as! ProfileDetailViewController
            destVC.user = sender as? Player
        }
        
    }
    
    
    
    //MARK: - Searching
    
    func filterContentForSearchText(searchText: String, scope: String = "All") {
        filteredUsers = allUsers.filter { friend in
            
            //return the search by email or by name - make sure it also isn't the person using the app as well
            return (friend.name!.lowercaseString.containsString(searchText.lowercaseString))
                || (friend.email.lowercaseString.containsString(searchText.lowercaseString))
        }
        
        tableView.reloadData()
    }
    
    
    //MARK: - Unwind Segues
    
    @IBAction func profileDetailUnwind(segue : UIStoryboardSegue) {
        //unwind to here when user clicks back on the profile detail
        
    }

    //MARK: - Cell Button Click
    
    func friendButtonClicked(button : UIButton) {
        //convert the point the button is at to table view coordinates
        let buttonPoint = button.superview?.convertPoint(button.center, toView: self.tableView)
        //get the index path of the cell at that point
        let indexPath = self.tableView.indexPathForRowAtPoint(buttonPoint!)
        
        //print(indexPath!.row)
        //print(indexPath!.section)
        
        //get the cell the user clicked on
        cellClicked = tableView.cellForRowAtIndexPath(indexPath!) as? FriendTableViewCell
        
        //if the friend is currently a friend
        if cellClicked!.isFriend {
            let title = "Unfriend " + (cellClicked?.player?.name)! + "?"
            let message = "Are you sure you want to remove " + (cellClicked?.player?.name)! + " as a friend?"
            
            unfriendAlert?.message = message
            unfriendAlert?.title = title
            
            //alert user if they want to 'unfriend' the user
            presentViewController(unfriendAlert!, animated: true, completion: {
                
            })
            
            
        }
            
        //user not currently friends - add them to the friends
        else {
            //add the player to the users friends
            user?.friends?.append((cellClicked?.player?.uid)!)
            //update firebase to have new friends
            user?.ref?.updateChildValues(["friends" : (user?.friendsToDictionary())!])
            
            //change the image and update
            self.cellClicked!.friendButton.setImage(UIImage(named:"star_highlighted"), forState: .Normal)
            self.cellClicked!.isFriend = true
            
            //add player to tab bar friends
            //(self.tabBarController as? TabBarController)?.userFriends.append((cellClicked?.player)!)
            
            //add to friends array
            friends.append((self.cellClicked?.player)!)
            
            
            
        }
        
        
    }
    
    //MARK: - Alert Initialization
    func initializeUnfriendAlert() {
        let message = "Are you sure you want to remove fullname as a friend?"
        
        unfriendAlert = UIAlertController(title: "Unfriend firstname?", message: message , preferredStyle: .Alert)
        
        let unfriendAction = UIAlertAction(title: "Unfriend", style: .Default) { (alertAction) in
            
            //change the image and update
            self.cellClicked!.friendButton.setImage(UIImage(named:"star_unhighlighted"), forState: .Normal)
            self.cellClicked!.isFriend = false

            //find the index of the player
            var index = self.friends.indexOf((self.cellClicked?.player)!)
            self.friends.removeAtIndex(index!)

            //find the index of the uid in the users friends array and remove it
            index = self.user?.friends?.indexOf((self.cellClicked?.player?.uid)!)
            
            self.user?.friends?.removeAtIndex(index!)
            self.user?.ref?.updateChildValues(["friends" : (self.user?.friendsToDictionary())!])
            
            
            self.tableView.reloadData()
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel) { (alertAction) in
            
        }
        
        //add the actions to the alert
        unfriendAlert?.addAction(unfriendAction)
        unfriendAlert?.addAction(cancelAction)
        
        
    }
    
    //method takes a user in and checks if they are in the current users friends list
    func isUserAFriend(playerToCheck : Player) -> Bool {
        //loop through all the users current friends
        for friendUID in user!.friends! {
            //return true if a friend uid matches user UID passed
            if friendUID == playerToCheck.uid {
                return true
            }
        }
        
        //player not found in friends list return false
        return false
    }

    
    
}




extension FriendsViewController : UISearchResultsUpdating {
    
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text!)
    }

    
}


