//
//  FirstViewController.swift
//  SquadUp
//
//  Created by Michael Oudenhoven on 3/5/16.
//  Copyright © 2016 CS 407. All rights reserved.
//

import UIKit
import Firebase

class ProfileViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    //MARK: - Properties
    
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    
    let profileOptionCellID = "profileOption"
    
    let ref = Firebase(url: "https://squadupcs407.firebaseio.com")
    
    
    //MARK: - Lifecycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        //make the profile image a circle
        profileImage.layer.cornerRadius = profileImage.frame.size.width/2
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //MARK: - Table View Delegate
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        //selected row, go to friends profile
        
    }
    
    //MARK: - Table View Data Source
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //return users number of friends
        return 2
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(profileOptionCellID, forIndexPath: indexPath)
        
        return cell
    }
    
    //MARK: - IBActions
    
    @IBAction func logOutClicked(sender: AnyObject) {
        //log user out
        ref.unauth()
        //go back to log in screen
        self.navigationController?.popToRootViewControllerAnimated(true)
    }
    


}

