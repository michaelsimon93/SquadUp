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
    
    //Initialize from Firebase -   METHOD UNUSED
//    init(authData : FAuthData) {
//        uid = authData.uid
//        email = authData.providerData["email"] as! String
//        
//        //acesss the rest of the Player variables with a firebase search
//        
//        
//        //general placeholder variables to make it compile for now
//        initials = "MO"
//        numGamesPlayed = 0
//        name = "Michael"
//        friends = ["uid1234"]
//        
//    }
    
    init(snapshot : FDataSnapshot, uid : String) {
        self.uid = uid
        self.initials = snapshot.value["initials"] as? String
        self.numGamesPlayed = snapshot.value["numGamesPlayed"] as? Int
        self.name = snapshot.value["name"] as? String
        self.email = snapshot.value["email"] as! String
        
        
    }
    
    //Initialize from arbitrary data
    init(uid: String, email: String, initials : String, numGamesPlayed : Int, name : String) {
        self.uid = uid
        self.email = email
        self.initials = initials
        self.numGamesPlayed = numGamesPlayed
        self.name = name
        
    }
    
    //converts to 'AnyObject' Dictonary so that it can be sent to firebase
    func toDictionary() -> AnyObject {
        
        let toReturn : [String: AnyObject] = ["initials" : initials!,
                                              "uid": uid,
                                              "numGamesPlayed" : numGamesPlayed!,
                                              "name" : name!,
                                              "email" : email,
                                              "friends" : friendsToDictionary()]
        
        
        return toReturn
    }
    
    //converts the friends array to a dictionary that holds the friends uid's
    func friendsToDictionary() -> AnyObject {
        //dictionary to return with friends
        var toReturn : [String : AnyObject] = [String:AnyObject]()
        
        if friends != nil {
            //loop through friends and put them in a dictionary
            for i in 0..<friends!.count {
                let friendNo = "friend" + String(i)
                toReturn[friendNo] = friends![i]
            }
        }

        
        return toReturn
        
    }
    
    
}
