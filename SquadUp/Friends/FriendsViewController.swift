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
        cell.starImageView.image = UIImage(named: "star_highlighted")
        
        
        return cell
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    
    //MARK: - Searching
    
    func filterContentForSearchText(searchText: String, scope: String = "All") {
        filteredUsers = allUsers.filter { friend in
            
            //return the search by email or by name
            return (friend.name!.lowercaseString.containsString(searchText.lowercaseString))
                || (friend.email.lowercaseString.containsString(searchText.lowercaseString))
        }
        
        tableView.reloadData()
    }

}


extension FriendsViewController : UISearchResultsUpdating {
    
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text!)
    }
    
    
    
    
    
    
    
    
    
    
}








/*
 //THIS IS THE SEARCH VIEW CONTROLLER THAT I USED FOR THE INSTRAGRAM APP OVER THE SUMMER. I WAS USING PARSE, BUT SOME OF THE
 //CODE COULD BE SIMILAR AND USABLE 
 
 
 class SearchViewController: UIViewController, UISearchBarDelegate, UITableViewDataSource {
 
    //create the connections
    @IBOutlet var searchBar: UISearchBar?
    @IBOutlet var tableView: UITableView?
 
    //array to hold the search results
    var searchResults = []
 
    override func viewDidLoad() {
        super.viewDidLoad()
 
        //reference the nib file to show up during search
        let nib = UINib(nibName: "PersonCell", bundle: nil)
        self.tableView?.registerNib(nib, forCellReuseIdentifier: "PersonCellIdentifier")
 
    }
 
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
 
    //when person clicks on the text field
    func searchBarTextDidBeginEditing(searchBar: UISearchBar) {
 
        //clears text each time the search bar is clikced
        searchBar.text = ""
 
        //show the cancel button whenever someone clicks on the search bar
        searchBar.setShowsCancelButton(true, animated: true)
    }
 
    //when the text field exits edit mode
    func searchBarTextDidEndEditing(searchBar: UISearchBar) {
 
        searchBar.setShowsCancelButton(false, animated: true)
    }
 
    //handles wehn cancel was clicked
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
 
        searchBar.resignFirstResponder()
    }
 
    //handles when someone makes a search
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
 
        //gets rid of cancel and keyboard so you can see results on the full screen when a search is made
        searchBar.resignFirstResponder()
 
        //variable to hold the typed text in the search bar
        let searchTerm = searchBar.text
 
        //call the find user method from NetworkManager
        NetworkManager.sharedInstance.findUsers(searchTerm, completionHandler: {
            (objects, error) -> () in
 
            //if in the search, then refresh the table and show the result
            if let constObjects = objects {
 
                self.searchResults = constObjects
                self.tableView?.reloadData()
            }
            else if let constError = error {
 
                self.showAlert("Unable to conduct Search")
            }
        })
 
    }
 
    //same as in FeedViewController
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.searchResults.count
    }
 
    //same as in FeedViewController
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("PersonCellIdentifier") as! PersonCell
        let user = self.searchResults[indexPath.row] as! PFUser
 
        cell.user = user
 
        return cell
    }
 
 }
 
*/
