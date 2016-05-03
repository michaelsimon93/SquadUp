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
    
    
    
    //MARK: - Lifecycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //get all the users loaded in the tab bar
        allUsers = (self.tabBarController as! TabBarController).allUsers


        // Do any additional setup after loading the view.
        
        //add users to all users array here - done in tab bar controller
        //add users to friends array here - done in tab bar controller
        
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        definesPresentationContext = true
        tableView.tableHeaderView = searchController.searchBar
        searchController.searchBar.placeholder = "Search by email or name..."
        
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
        
        
        
        //player the cell represents
        cell.friendNameLabel.text = friend.name
        
        //change to star highlighted if the user is already a friend (check UID)
        cell.friendButton.setImage(UIImage(named: "star_highlighted"), forState: .Normal)
        
        
        
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
            
            //return the search by email or by name
            return (friend.name!.lowercaseString.containsString(searchText.lowercaseString))
                || (friend.email.lowercaseString.containsString(searchText.lowercaseString))
        }
        
        tableView.reloadData()
    }
    
    
    //MARK: - Unwind Segues
    
    @IBAction func profileDetailUnwind(segue : UIStoryboardSegue) {
        //unwind to here when user clicks back on the profile detail
        
    }


    
    
}




extension FriendsViewController : UISearchResultsUpdating {
    
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text!)
    }

    
}


