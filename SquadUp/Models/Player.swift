//
//  Player.swift
//  SquadUp
//
//  Copyright © 2016 CS 407. All rights reserved.


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
    //string that is the user profile image
    var profileImageString : String?
    //users profile image
    var profileImage : UIImage?
    
    let ref : Firebase?
    
    //firebase reference to users dictionary
    let usersRef = Firebase(url: "https://squadupcs407.firebaseio.com/users")
    
    
    //MARK: - Initialization
    
    //Initialize from Firebase
    init(snapshot : FDataSnapshot, uid : String) {
        
        self.uid = uid
        self.initials = snapshot.value["initials"] as? String
        self.numGamesPlayed = snapshot.value["numGamesPlayed"] as? Int
        self.name = snapshot.value["name"] as? String
        self.email = snapshot.value["email"] as! String
        self.ref = usersRef.childByAppendingPath(self.uid)
        self.profileImageString = snapshot.value["image"] as? String
        
        super.init()
        
        self.friends = [String]()
        let friendsDictionary = snapshot.value["friends"] as? NSDictionary
        //intialize friends to string array - only if the user has added friends
        if friendsDictionary != nil {
           self.convertFriendsToArray(friendsDictionary!)
        }
        
        //convert the profile image string into a picture
        getProfileImage()
        
    }
    
    //Initialize from arbitrary data
    init(uid: String, email: String, initials : String, numGamesPlayed : Int, name : String) {
        self.uid = uid
        self.email = email
        self.initials = initials
        self.numGamesPlayed = numGamesPlayed
        self.name = name
        self.friends = [String]()
        self.ref = usersRef.childByAppendingPath(self.uid)
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
    
    //method to convert the friends from a dictionary from firebase to a string
    func convertFriendsToArray(dictionary : NSDictionary) {
        //get all of the keys friend the dictionary (ie: 'friend0', 'friend1', etc.)
        let keys = dictionary.allKeys as? [String]
        
        //loop through the keys, get the uid and add it to the friends array
        for key in keys! {
            //add the uid to the friends array
            friends?.append((dictionary.valueForKey(key) as? String)!)
        }
    }
    
    
    func getProfileImage() {
        if profileImageString != nil {
            let decodedData = NSData(base64EncodedString: (profileImageString)!, options: .IgnoreUnknownCharacters)
            let decodedImage = UIImage(data: decodedData!)
            profileImage = decodedImage
        }
        
        
    }
}
