//
//  Game.swift
//  SquadUp
//
//  Created by Michael Oudenhoven on 3/30/16.
//  Copyright © 2016 CS 407. All rights reserved.
//

import UIKit




//Model object representing each game that is available to the users. Will be loaded from the server with a JSON file
class Game: NSObject {
    
    //data in String representation (ie: 04/06/2016)
    var date: String?
    //time in string representation (ie: 5:30 PM)
    var time: String?
    //location the game is at
    var location: String?
    //game type is a string holding 5v5, 4v4, 3v3
    var gameType: String?
    //the number of players currently joined into the game
    var numPlayersJoined: Int?
    //the total number of players allowed for the game (ie: 10, 8, 6)
    var totalPlayersAllowed: Int?
    //array to holding all of the users/players curently entered in the game
    var players:[Player] = [Player]()
    
    //custom game object initializer - to be used by object loading games from JSON
    init(date: String, time: String, location: String, gameType: String, numPlayersJoined: Int, totalPlayersAllowed: Int) {
        //initialize given variables with passed arguments
        self.date = date
        self.time = time
        self.location = location
        self.gameType = gameType
        self.numPlayersJoined = numPlayersJoined
        self.totalPlayersAllowed = totalPlayersAllowed
        
    }
    
}
