//
//  Player.swift
//  SquadUp
//
//  Created by Michael Oudenhoven on 3/30/16.
//  Copyright © 2016 CS 407. All rights reserved.
//

import UIKit
import Firebase


//model object representing the players the user is seeing on their screen, will contain the avatar, username, and other useful information
class Player: NSObject {

    //MARK: - Properties
    
    //intials of the player
    var initials : String?
    //user id of the player from Firebase - used to tell who has joined game
    let uid : String
    //number of games the user has played
    var numGamesPlayed: Int?
    //users name / nickname they display on their profile
    var name : String?
    //users email to let others search for them
    let email : String
    //uid's of the users friends
    var friends : [String]?
    
    //firebase reference to users dictionary
    let usersRef = Firebase(url: "https://squadupcs407.firebaseio.com/users")
    
    
    //MARK: - Initialization
    
    //Initialize from Firebase
    init(authData : FAuthData) {
        uid = authData.uid
        email = authData.providerData["email"] as! String
        
        //acesss the rest of the Player variables with a firebase search
        
    }
    
    //Initialize from arbitrary data
    init(uid: String, email: String) {
        self.uid = uid
        self.email = email
        
    }
    
    
}
