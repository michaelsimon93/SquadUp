//
//  FourthViewController.swift
//  SquadUp
//
//  Created by Michael Oudenhoven on 3/5/16.
//  Copyright © 2016 CS 407. All rights reserved.
//

import UIKit

class FriendsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate  {

    let friendCellID = "friendCell"
    //friends are an array of players to be loaded
    var friends = [Player]()
    @IBOutlet weak var tableView: UITableView!
    
    
    var allUsers = [Player]()
    var filteredUsers = [Player]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        //add users to all users array here
        //add users to friends array here
        
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
//        if tableView == self.searchDisplayController?.searchResultsTableView {
//            //number of cells is the number of filtered users
//            return self.filteredUsers.count
//        }
//        //not searching - just regular table view
//        else {
//            //placeholder
//            return 2
//            //the number of your friends
//            //return friends.count
//        }
        
        
        //return users number of friends
        return 2
        
        
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(friendCellID, forIndexPath: indexPath)
        //player the cell represents
//        var player : Player
//        
//        //if the player is using the search - make the cell the filtered users
//        if tableView == self.searchDisplayController?.searchResultsTableView {
//            player = filteredUsers[indexPath.row]
//        }
//        //not searching make the cells the players friends
//        else {
//            player = friends[indexPath.row]
//        }
        
        
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

}
