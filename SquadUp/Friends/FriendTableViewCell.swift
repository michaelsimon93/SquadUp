//
//  FriendTableViewCell.swift
//  SquadUp
//
//  Created by Michael Oudenhoven on 5/2/16.
//  Copyright © 2016 CS 407. All rights reserved.
//

import UIKit

class FriendTableViewCell: UITableViewCell {

    //MARK: - Properties
    
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var friendNameLabel: UILabel!
    @IBOutlet weak var friendButton: UIButton!
    
    //boolean representing if the user is a friend or not
    var isFriend = false
    
    
    //MARK: - Methods
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        profileImage.layer.cornerRadius = profileImage.frame.width/2
        //self.backgroundColor = UIColor.grayColor()

    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    

}
