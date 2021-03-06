//
//  Game.swift
//  SquadUp
//
//  Copyright © 2016 CS 407. All rights reserved.


import UIKit
import Firebase

//Model object representing each game that is available to the users. Will be loaded from the server with a JSON file
class Game: NSObject {
    
    //MARK: - Properties
    //date of the game
    var date: NSDate?
    //location the game is at
    var location: String?
    //game type is a string holding 5v5, 4v4, 3v3
    var gameType: String?
    //the number of players currently joined into the game
    var numPlayersJoined: Int?
    //the total number of players allowed for the game (ie: 10, 8, 6)
    var totalPlayersAllowed: Int?
    //array to holding the uid's of al the users/players curently entered in the game
    var players:[String] = [String]()
    
    
    //FIREBASE PROPERTIES
    //the key of the location where the game is located on the database
    let key : String!
    //firebase reference for where the data came from
    let ref : Firebase?
    
    
    //MARK: - Initialization
    
    //custom game object initializer - used when creating a new game to be loaded to firebase
    init(date: NSDate, location: String, gameType: String, numPlayersJoined: Int, totalPlayersAllowed: Int, key: String!) {
        //initialize given variables with passed arguments
        self.date = date
        self.location = location
        self.gameType = gameType
        self.numPlayersJoined = numPlayersJoined
        self.totalPlayersAllowed = totalPlayersAllowed
        self.key = key
        self.ref = nil
        
        //initialize the player array to all empty players with the length of the amount
        //of players that can join the game
        for _ in 0..<totalPlayersAllowed {
            players.append("")
        }
        
        
    }
    
    //ACTUAL INTIALIZATION
    //initialization method to create a game from retreived data on firebase
    init(snapshot: FDataSnapshot) {
        key = snapshot.key
        ref = snapshot.ref
        super.init()
        
        self.gameType = snapshot.value["gameType"] as? String
        self.numPlayersJoined = snapshot.value["numPlayersJoined"] as? Int
        self.totalPlayersAllowed = snapshot.value["totalPlayersAllowed"] as? Int
        self.location = snapshot.value["location"] as? String
        
        let dateDictonary = snapshot.value["date"] as! NSDictionary
        //print(dateDictonary)
        //let day2 = date?.valueForKey("day")
        
        let day = dateDictonary.valueForKey("day")?.integerValue
        let month = dateDictonary.valueForKey("month")?.integerValue
        let tempYear = dateDictonary.valueForKey("year")?.integerValue
        let time = dateDictonary.valueForKey("time") as! String
        let ampm = dateDictonary.valueForKey("AMPM") as! String
        
        //print(time)
        //print(ampm)
        
        let timeArr = time.componentsSeparatedByString(":")
        var hour = Int(timeArr[0])!
        let minute = Int(timeArr[1])!
        
        if ampm == "PM" {
            //add 12 hours to the hour to signify PM
            hour += 12
        }
        //add the '20' to the beginning of the date
        let fullYear = "20" + String(tempYear!)
        
        let dateComponents = NSDateComponents()
        dateComponents.month = month!
        dateComponents.year = Int(fullYear)!
        dateComponents.day = day!
        dateComponents.hour = hour
        dateComponents.minute = minute
        
        let date = NSCalendar(calendarIdentifier: "gregorian")?.dateFromComponents(dateComponents)
        
        self.date = date
        
        //load the current players
        let playersDictionary = snapshot.value["players"] as! NSDictionary
        let playersKeys = playersDictionary.allKeys as NSArray
        
        //initialize the players array to the correct length
        for _ in 0..<playersKeys.count {
            players.append("")
        }
        
        //loop through all the keys and add all player uid's to the array
        for i in 0..<playersKeys.count {
            let playerKeyString = playersKeys[i] as! String
            
            //get just the number on the end of the player string so it is placed in the right spot in the array
            let index = playerKeyString.startIndex.advancedBy(6)
            let num = Int(playerKeyString.substringFromIndex(index))
            

            players[num!] = playersDictionary.valueForKey(playerKeyString) as! String
        }
        

    }
    
    
    
    //MARK: - Conversion Methods

    //method to convert to any object so it can be uploaded to firebase as a JSON
    func toDictionary() -> AnyObject {
        
        let toReturn : [String: AnyObject] = ["location" : location!,
                                              "gameType": gameType!,
                                              "numPlayersJoined" : numPlayersJoined!,
                                              "totalPlayersAllowed" : totalPlayersAllowed!,
                                              "date" : dateToDictionary(),
                                              "players" : playersToDictionary()]
        
        
        return toReturn
        
    }
    
    
    //converts NSDate into a dictionary so it can be saved into a JSON on firebase
    func dateToDictionary() -> AnyObject {
        
        //convert the DateTimePicker
        let formatter = NSDateFormatter()
        formatter.dateStyle = .ShortStyle
        formatter.timeStyle = .ShortStyle
        let fullDate:String = formatter.stringFromDate(date!)
        var fullDateArr = fullDate.componentsSeparatedByString(" ")
        let dateString = fullDateArr[0].componentsSeparatedByString("/")
        
        let tempYear = dateString[2]
        
        let day = dateString[1]
        let month = dateString[0]
        //extra comma on the end of the year - this line below drops it off
        let year = String(tempYear.characters.dropLast())
        let time = fullDateArr[1]
        let ampm = fullDateArr[2]
        
        let toReturn : [String : AnyObject] = ["month": month,
                                               "day" : day,
                                               "year" : year,
                                               "time" : time,
                                               "AMPM" : ampm]
        
        return toReturn
    }
    
    //returns the date of the game represented as "4/22/16" to be used for the dictionary
    func dateToString() -> String {
        
        let formatter = NSDateFormatter()
        formatter.dateStyle = .ShortStyle
        formatter.timeStyle = .ShortStyle
        let fullDate:String = formatter.stringFromDate(date!)
        var fullDateArr = fullDate.componentsSeparatedByString(", ")
        
        //return the date represented as "4/22/16"
        return fullDateArr[0]
    }
    
    //converts the array of players joined in the game to dictionary so it can be saved into JSON on firebase
    func playersToDictionary() -> AnyObject {
        var toReturn = [String : AnyObject]()
        
        //loop through the players and make them to a dictionary
        for i in 0..<players.count {
            let playerString = "player" + String(i)
            toReturn[playerString] = players[i]
        }
        
        return toReturn
        
    }
}
