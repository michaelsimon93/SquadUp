//
//  ProfileDetailViewController.swift
//  SquadUp
//
//  Created by Michael Oudenhoven on 5/3/16.
//  Copyright © 2016 CS 407. All rights reserved.
//

import UIKit

//shows friends profile detail when clicked on in the friends menu

class ProfileDetailViewController: UIViewController {

    //MARK: - Properties
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var initialsLabel: UILabel!
    @IBOutlet weak var numGamesPlayedLabel: UILabel!
    
    //the players profile to be displayed
    var user : Player?
    
    //MARK: - Lifecycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        //make the profile image a circle with border
        profileImage.layer.cornerRadius = profileImage.frame.size.width/2
        profileImage.layer.borderWidth = 2
        profileImage.layer.borderColor = UIColor.whiteColor().CGColor
        if user?.profileImage != nil {
            profileImage.image = user?.profileImage
        }
        else {
            profileImage.image = UIImage(named: "empty_profile")
        }
    }

    override func viewWillAppear(animated: Bool) {
                
        nameLabel.text = user?.name!
        initialsLabel.text = "Initials: " + (user?.initials!)!
        let gamesPlayedString = String(user!.numGamesPlayed!)
        numGamesPlayedLabel.text = "Number of Games Played: " + gamesPlayedString
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //make status bar font white so it appears on the dark background
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
    }
    

    @IBAction func backClicked(sender: AnyObject) {
        self.navigationController?.popViewControllerAnimated(true)
        
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
