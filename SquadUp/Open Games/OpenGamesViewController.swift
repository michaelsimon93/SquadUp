//
//  SecondViewController.swift
//  SquadUp
//
//  Created by Michael Oudenhoven on 3/5/16.
//  Copyright © 2016 CS 407. All rights reserved.
//

import UIKit
import Firebase

class OpenGamesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    @IBOutlet weak var tableView: UITableView!
    
    //ARRAY IS TEMPORARY UNTIL THE DICTIONARY TO SEPARATE BY SECTION IS COMPLETE
    //array holding all of the currently available games
    //var games:[Game] = [Game]()
    
    //orange color for the views
    let orange = UIColor(red: 0.86, green: 0.49, blue: 0.19, alpha: 1.0)
    
    //dictionary : keys is the date, value is an array of games on that specific date
    //date is formatted as "4/22/16" for the key search
    var gameDictionary = [String : [Game]]()
    
    let ref = Firebase(url: "https://squadupcs407.firebaseio.com")
    let gameRef = Firebase(url: "https://squadupcs407.firebaseio.com/games")
    let usersRef = Firebase(url: "https://squadupcs407.firebaseio.com/users")
    
    //auth data from user logging in - used to create Player object
    var userUID : String?
    
    //array of the sorted keys for the dictionary to use
    var sortedKeys = Array<String>()
    
    //Player using the app
    //var user : Player?
    
    //checks if the tab bar is first loaded
    var firstLoad = true
    
    
    
    //MARK: - Lifecycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        tableView.rowHeight = 50.0
        //tableView.backgroundView = UIImageView(image: UIImage(named: "background"))

        //self.tableView.tableHeaderView = UIView(frame: CGRectMake(0, 0, 0, CGFloat.min))
        self.automaticallyAdjustsScrollViewInsets = false
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(animated: Bool) {
//        //if it is the first time the tab bar is loaded load the friends of the user
//        if firstLoad {
//            let user = (self.tabBarController as? TabBarController)!.user
//            let allUsers = (self.tabBarController as? TabBarController)!.allUsers
//            var userFriends = [Player]()
//            //loop through all the friends UID's and add the player object that matches from the all users array
//            for friendUID in (user?.friends)! {
//                
//                //loop through the array of all of the users to find the user that they are friends with
//                for player in allUsers {
//                    if friendUID == player.uid {
//                        //user found, add their player object to the array and break from interior loop
//                        userFriends.append(player)
//                        break
//                    }
//                }
//                
//            }
//            (self.tabBarController as? TabBarController)?.userFriends = userFriends
//            let friendController = self.tabBarController!.viewControllers![2] as? FriendsViewController
//            friendController?.friends = (self.tabBarController as? TabBarController)!.userFriends
//            firstLoad = false
//        }

    }
    
    override func viewWillAppear(animated: Bool) {

        
        
        gameRef.observeEventType(.Value, withBlock: { snapshot in
            
            //array to hold all of the currently available games
            //var newGames = [Game]()
            
            //dictionary of the new games from the server
            var newGamesDict = [String : [Game]]()
            
            //print(snapshot.children)
            
            //loop through all of the available games and add them to the list
            for game in snapshot.children {
                
                //create the game with the outer dictionary (everythign but the date)
                let newGame = Game(snapshot: game as! FDataSnapshot)
                
                let dateString = newGame.dateToString()
                
                //check if dictionary has the current value
                if newGamesDict[dateString] == nil {
                    //if it doesn't have the value add the date value to the dictionary
                    //create an array with the new game in it
                    //let newGameArr : Array<Game> = [newGame]
                    
                    //initialize the array at that key
                    newGamesDict[dateString] = Array<Game>()
                    //sub the new game array into the spot of the empty array
                    newGamesDict[dateString]?.append(newGame)
                    
                }
                //the dictionary has the value add the game to the end of the array
                else {
                    //add the game to the end of the currently used
                    newGamesDict[dateString]!.append(newGame)
                    
                }
                
                
                
                //newGames.append(newGame)
            }
            
            //set the new games from firebase to the current set
            //self.games = newGames
            //print("newGamesDict \(newGamesDict)")
            self.gameDictionary = newGamesDict
            
            
            self.sortedKeysByDate()
            
            for date in self.sortedKeys {
                self.sortGamesByTime(date)
            }
            
            self.deleteOldGames()
            
            //do a pulldown to refresh
            self.tableView.reloadData()
            
            
        })
        
        //self.deleteOldGames()
        
        self.viewDidAppear(animated)
    }
    
    
    
    
    
    //MARK: - Table View Delegate / Datasource Methods
    
    //method called when a row in the table view is clicked on
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        //send the event with the segue
        //print(indexPath.row)
        
        //get the date of the game clicked on
        //let gameSection = Array(gameDictionary.keys)[indexPath.section]
        let gameSection = sortedKeys[indexPath.section]
        //get the game selected
        let game = gameDictionary[gameSection]![indexPath.row]

        
        //game is a 5v5
        if game.totalPlayersAllowed == 10 {
            //segue to the joining game view controller, pass the game to be given to the destination VC
            self.performSegueWithIdentifier("toTenPersonViewController", sender: game)
        }
        //game is a 4v4
        else if game.totalPlayersAllowed == 8 {
            //segue to the joining game view controller, pass the game to be given to the destination VC
            self.performSegueWithIdentifier("toEightPersonViewController", sender: game)
        }
        //game is a 3v3
        else if game.totalPlayersAllowed == 6 {
            //segue to the joining game view controller, pass the game to be given to the destination VC
            self.performSegueWithIdentifier("toSixPersonViewController", sender: game)
        }

        //delselect the row so that when the game detail is popped off there isn't a cell stil highlighted
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    
    //headers for the sections - date of the games
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        //special case when there is only 1 game and it is added
        if sortedKeys.count == 0 {
            let date = Array(gameDictionary.keys)[0]
            let game = gameDictionary[date]?[0]
            
            return game?.dateToString()
        }
        
        //return the keys for the section headers - sorted so they are in the correct order
        return sortedKeys[section]
    }
    
    
    //the number of sections in the table view - the number of dates that currently have games
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        //return the number of key value pairs in the dictionary
        return gameDictionary.count
    }
    
    //method for the number of rows in the table
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //get the keys as an array. acess the row number of the array to get the key
        //get an array of the values and get the count from the dictionary
        
        //check if there is no sorted keys
        if sortedKeys.count != 0 {
            //get the key of the value
            let key = sortedKeys[section]
            let gamesArr = gameDictionary[key]
            
            return (gamesArr?.count)!
        }
        
        //there is one section in the table - since there is no sorted keys
        return 1

    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("GameCell") as! GameTableViewCell
        
        let gameArr : [Game]?
        
        if sortedKeys.count != 0 {
            //get the array of games based on the section of the table it is
            gameArr = gameDictionary[sortedKeys[indexPath.section]]
        }
        else {
            //only 1 key in the dictionary
            let key = Array(gameDictionary.keys)[0]
            gameArr = gameDictionary[key]
        }


        //get the current game based on the row in the section it is
        let game = gameArr![indexPath.row]
        
        //if its iPhone 5 make the font a little smaller - iphone is 568 pt tall
        //prevents labels from overlapping on iPhone 5 due to smaller screen
        if self.view.frame.size.height < 600 {
            cell.locationLabel.font = UIFont(name: (cell.locationLabel?.font.fontName)!, size: 13.0)
            cell.timeLabel.font = UIFont(name: (cell.locationLabel?.font.fontName)!, size: 13.0)
            cell.filledSpotsLabel.font = UIFont(name: (cell.locationLabel?.font.fontName)!, size: 13.0)
        }
        
        
        //setup cell labels from game object
        let locationText = game.location! + " " + game.gameType!
        //let locationText = game.location!
        cell.locationLabel.text = locationText
        
        let numSpotsFilled = String(game.numPlayersJoined!) + "/" + String(game.totalPlayersAllowed!)
        cell.filledSpotsLabel.text = numSpotsFilled
        
        cell.timeLabel.text = timeFromDate(game.date!)
        
        return cell
    }

    //conifgure the custom fonts and font color of the date headers on the table view
    func tableView(tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        let header = view as! UITableViewHeaderFooterView
        header.textLabel!.textColor = UIColor.blackColor()
        header.textLabel!.font = UIFont(name: "Futura", size: 14)!
        let darkerGray = UIColor(colorLiteralRed: 0.9176, green: 0.9176, blue: 0.9176, alpha: 1.0)
        header.contentView.backgroundColor = darkerGray
    }
    
    
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        //if going to a game detail view, pass the users player object
        if segue.identifier == "toTenPersonViewController" {
            let destVC = segue.destinationViewController as! TenPersonGameViewController
            let game = sender as! Game
            //give the game the user and the game so if they joined they can be added in firebase
            destVC.game = game
            destVC.user = (self.tabBarController as? TabBarController)?.user
        }
        else if segue.identifier == "toEightPersonViewController" {
            let destVC = segue.destinationViewController as! EightPersonGameViewController
            let game = sender as! Game
            //give the game the user and the game so if they joined they can be added in firebase
            destVC.game = game
            destVC.user = (self.tabBarController as? TabBarController)?.user
        }
        else if segue.identifier == "toSixPersonViewController" {
            let destVC = segue.destinationViewController as! SixPersonGameViewController
            let game = sender as! Game
            //give the game the user and the game so if they joined they can be added in firebase
            destVC.game = game
            destVC.user = (self.tabBarController as? TabBarController)?.user
        }
        
    }
    
    
    //MARK: - Unwind Segues
    @IBAction func createGameUnwind(segue : UIStoryboardSegue){
        //print("create game unwind")
        
        if segue.identifier == "createGameUnwind" {
            //get the source VC where the data is stored for the new game
            let sourceVC = segue.sourceViewController as! CreateGameViewController
            
            
            //update the selections for the location, time, and place in case one of the cells isn't closed
            //get the cell in the first section - time cell
            let indexPath1 = NSIndexPath(forRow: 0, inSection: 0)
            let cell1 = sourceVC.tableView.cellForRowAtIndexPath(indexPath1) as! DatePickerTableViewCell
            let date = cell1.datePicker.date
            //set the games NSDate
            sourceVC.gameDate = date
            //format the date to be displayed in the cell
            let formattedDate = sourceVC.formatDate(date)
            //set the labels text
            cell1.dateLabel.text = formattedDate
            
            
            //get the cell in the second section - location cell
            let indexPath2 = NSIndexPath(forRow: 0, inSection: 1)
            let cell2 = sourceVC.tableView.cellForRowAtIndexPath(indexPath2) as! PickerTableViewCell
            sourceVC.gameLocation = sourceVC.pickerLocation[cell2.selectedRow]
            sourceVC.selectedLocation! = cell2.selectedRow
            
            //get the cell in the third section - game type cell
            let indexPath3 = NSIndexPath(forRow: 0, inSection: 2)
            let cell3 = sourceVC.tableView.cellForRowAtIndexPath(indexPath3) as! GamePickerTableViewCell
            sourceVC.gameType = sourceVC.pickerGameType[cell3.selectedRow]
            sourceVC.selectedGameType! = cell3.selectedRow
            
            
            let gameType = sourceVC.gameType
            let gameDate = sourceVC.gameDate
            let gameLocation = sourceVC.gameLocation            
        
            var totalAllowed = 0
            
            //find total amount of players allowed
            if (gameType == "3v3") {
                totalAllowed = 6
            } else if (gameType == "4v4") {
                totalAllowed = 8
            } else if (gameType == "5v5") {
                totalAllowed = 10
            }
            
            var gameNumber = 0
            
            ref.childByAppendingPath("gameNumber").observeSingleEventOfType(.Value, withBlock: { (snapshot) in
                gameNumber = (snapshot.value as? Int)!
                
                let gameURL = "https://squadupcs407.firebaseio.com/games/game" + String(gameNumber)
                
                let key = "game" + String(gameNumber)
                
                let newGame = Game(date: gameDate!, location: gameLocation!, gameType: gameType!, numPlayersJoined: 0, totalPlayersAllowed: totalAllowed, key: key)
                
                
                let newGameRef = Firebase(url: gameURL)
                
                newGameRef.setValue(newGame.toDictionary()) { (error, firebase) in
                    if error != nil {
                        print(error.description)
                    }
                    else{
                        //increment game number
                        gameNumber+=1
                        //save the new game number to firebase
                        self.ref.childByAppendingPath("gameNumber").setValue(gameNumber)
                    }
                }
                
                //check if the date is already in the dictionary
                if self.gameDictionary[newGame.dateToString()] != nil {
                    //get the current array of games
                    var gameArr = self.gameDictionary[newGame.dateToString()]
                    //add the new gmae to the end of the current array
                    gameArr?.append(newGame)
                    //replace the new array with the added game in the dictionary
                    self.gameDictionary[newGame.dateToString()] = gameArr
                }
                //no date in the dictionary, intialize the array and add game
                else {
                    self.gameDictionary[newGame.dateToString()] = Array<Game>()
                    self.gameDictionary[newGame.dateToString()] = [newGame]
                }
                
                self.sortedKeysByDate()
                
                //delete any old games
                //self.deleteOldGames()
                
                //reload table data
                self.tableView.reloadData()
    
            })
            
        }
        
        
    }

    //need method so the create game VC unwinds to the open games view when cancel is clicked
    @IBAction func cancelCreateGameUnwind(segue : UIStoryboardSegue) {
        //print("cancel unwind")
        
        if segue.identifier == "cancelUnwind" {
            //do nothing for now - user cancelled the game creation
        }
    }
    
    //method to unwind from game detail to the open games
    @IBAction func backGameDetailUnwind(segue : UIStoryboardSegue) {
        
        
    }
    
    
    //MARK: - Date Formatting
    
    func timeFromDate(date: NSDate) -> String {
        
        //convert the DateTimePicker
        let formatter = NSDateFormatter()
        formatter.dateStyle = NSDateFormatterStyle.ShortStyle
        formatter.timeStyle = .ShortStyle
        let fullDate:String = formatter.stringFromDate(date)
        var fullDateArr = fullDate.componentsSeparatedByString(" ")
        let time = fullDateArr[1] + " " + fullDateArr[2]
        
        return time
    }
    
    func dateFromDate(date: NSDate) -> String {
        
        //convert the DateTimePicker
        let formatter = NSDateFormatter()
        formatter.dateStyle = NSDateFormatterStyle.ShortStyle
        formatter.timeStyle = .ShortStyle
        let fullDate:String = formatter.stringFromDate(date)
        var fullDateArr = fullDate.componentsSeparatedByString(", ")
        
        //zero position is the short style date
        return fullDateArr[0]
    }
    
    
    //MARK: - Sorting Algorithms
    
    //sort the dictionary by date so the most recent games show in section 0
    func sortedKeysByDate() {
        //sorting algorithm from : http://stackoverflow.com/questions/29552292/how-do-you-sort-dates-in-a-dictionary
        
        var dates = Array<NSDate>()
        
        //loop through each key and add the nsdate into the dates array
        for date in gameDictionary {
            let game = date.1[0]
            dates.append(game.date!)
        }
        //sort NSDates in ascending order
        let sorted = dates.sort{($0).compare($1) == .OrderedAscending}
        //clear the array so it can be resorted
        sortedKeys = Array<String>()
        
        for item in sorted {
            sortedKeys.append(dateFromDate(item))
        }
        
        
        
    }
    
    //sort the games at the given date by time
    func sortGamesByTime(date : String) {
        //function from http://stackoverflow.com/questions/29902781/sort-an-array-by-nsdates-using-the-sort-function
        let sortedGamesArr = gameDictionary[date]!.sort({ $0.date!.timeIntervalSince1970 < $1.date!.timeIntervalSince1970 })
        
        //print(sortedGamesArr)
        gameDictionary[date] = sortedGamesArr
        
    }
    
    
    //MARK: - Deleting Algorithms
    
    func deleteOldGames() {
        //get the current date and time
        //get the current nsdate
        let currDate = NSDate()
        
        //get a formatter to get strings to compare
        let formatter = NSDateFormatter()
        formatter.dateStyle = .ShortStyle
        formatter.timeStyle = .ShortStyle
        let fullDate:String = formatter.stringFromDate(currDate)
        var fullDateArr = fullDate.componentsSeparatedByString(", ")
        
        //current date represented as "mm/dd/yy"
        let currDateString = fullDateArr[0]
        //curent time represented as "HH:MM AM/PM"
        let currTimeString = fullDateArr[1]
        
        
        //loop through the sorted keys ("4/22/16")
        for gameDate in sortedKeys {
        
            //check if the date of the game is before the current date
            if dateBeforeCurrentDate(gameDate, currDateString: currDateString) {
                //delete the array of games from firebase since the games are past the current date
                let gamesArr = gameDictionary[gameDate]
                
                //loop through and delete all of the games
                for game in gamesArr! {
                    //remove the game from firebase
                    game.ref?.removeValue()
                    addGamePlayedToPlayers(game)
                }
                
            }
            
            //check if the date of the games are the same as the current date
            if gameDate == currDateString {
                //get the array of the games for the current date
                let gamesArr = gameDictionary[gameDate]
                
                //loop through the games for today and check if they are past the current time
                for game in gamesArr! {
                    let gameTime = nsDateToTime(game.date!)
                    
                    //check if the game time is before the current time of day
                    if timeBeforeCurrentTime(gameTime, currTimeString: currTimeString) {
                        //add a game played to all players in the game
                        addGamePlayedToPlayers(game)
                        //game time is before current time of day
                        //delete game from firebase
                        game.ref?.removeValue()
                        
                    }
                    //game is not before the current time of day
                    else {
                        //break out of the loop so time isn't wasted checking games
                        //that shouldn't be deleted
                        break
                    }
                }
     
            }
            
        }
        
        
    }
    
    //checks if the date passed as an argument is before today's date
    func dateBeforeCurrentDate(date: String, currDateString : String) -> Bool {
        
        let dateArr = currDateString.componentsSeparatedByString("/")
        let currMonth = Int(dateArr[0])
        let currDay = Int(dateArr[1])
        let currYear = Int(dateArr[2])
        
        let gameDateArr = date.componentsSeparatedByString("/")
        let gameMonth = Int(gameDateArr[0])
        let gameDay = Int(gameDateArr[1])
        let gameYear = Int(gameDateArr[2])
        
        //current game is in the previous year
        if currYear > gameYear {
            //date is before the current date
            return true
            
        }
        //game is in the same year as the date
        else {
            //check if the current month is larger than the game's month
            if currMonth > gameMonth {
                //date is before the current date - return true
                return true
            }
            //game is in the current month or in months ahead of the current month
            else {
                //check if the game day is before the current day in the month
                if currDay > gameDay && currMonth == gameMonth {
                    //game date is before current date - return true
                    return true
                }
            }
        }
        
        //game is on the current day or is ahead of the current date - return false
        return false
        
    }
    
    //checks if the time passed as an argument is before the current time
    func timeBeforeCurrentTime(time : String, currTimeString : String) -> Bool {
        
        var currHour = Int(currTimeString.componentsSeparatedByString(":")[0])
        let currMinute = Int(currTimeString.componentsSeparatedByString(":")[1].componentsSeparatedByString(" ")[0])
        let currAMPM = currTimeString.componentsSeparatedByString(" ")[1]
        
        var gameHour = Int(time.componentsSeparatedByString(":")[0])
        let gameMinute = Int(time.componentsSeparatedByString(":")[1].componentsSeparatedByString(" ")[0])
        let gameAMPM = time.componentsSeparatedByString(" ")[1]
        
        //if it is PM add 12 hours of seconds to the hour
        if gameAMPM == "PM" {
            gameHour! += 12
        }
        if currAMPM == "PM" {
            currHour! += 12
        }
        
        //total seconds from midnight the game is scheduled for on the current day
        let gameSeconds = 3600*gameHour! + 60*gameMinute!
        //the total seconds that pass passed in the current day
        let currSeconds = 3600*currHour! + 60*currMinute!
        
        //more seconds has passed in the day than the seconds passed to reach the game
        if currSeconds > gameSeconds {
            return true
        }
        
        return false
    }
    
    //converts a NSDate to the time representation "5:30 PM"
    func nsDateToTime(date : NSDate) -> String {
        //get a formatter to get strings to compare
        let formatter = NSDateFormatter()
        formatter.dateStyle = .ShortStyle
        formatter.timeStyle = .ShortStyle
        let fullDate:String = formatter.stringFromDate(date)
        let fullDateArr = fullDate.componentsSeparatedByString(", ")
        
        return fullDateArr[1]
    }
    
    func addGamePlayedToPlayers(game : Game) {
        
        let players = game.players
        let user = (self.tabBarController as? TabBarController)?.user
        
        //loop thorugh all the players
        for player in players {
            //check if there is a player uid in the spot, if not a player isn't joined in that spot
            
            if player != "" {
                usersRef.childByAppendingPath(player).observeSingleEventOfType(.Value, withBlock: { (snapshot) in
                    var currGamesPlayed = snapshot.value["numGamesPlayed"] as? Int
                    currGamesPlayed = currGamesPlayed! + 1
                    self.usersRef.childByAppendingPath(player).updateChildValues(["numGamesPlayed" : currGamesPlayed!])
                })

            }
            
            //add one to the player using the devices games played if it is them
            if player == user?.uid {
                //add one to the current using player - since otherwise their new number won't update
                user?.numGamesPlayed = (user?.numGamesPlayed)!+1
            }
            
        }
        
    }

}



