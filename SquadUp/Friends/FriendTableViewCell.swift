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
    @IBOutlet weak var starImageView: UIImageView!
    
    
    
    //MARK: - Methods
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
