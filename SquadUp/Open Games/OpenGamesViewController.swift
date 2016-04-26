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
    
    //array of the sorted keys for the dictionary to use
    var sortedKeys = Array<String>()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        //load some generic games into the table view
//        let game1 = Game(date: NSDate(), location: "SERF", gameType: "5v5", numPlayersJoined: 5, totalPlayersAllowed: 10)
//        let game2 = Game(date: NSDate(), location: "NAT", gameType: "4v4", numPlayersJoined: 2, totalPlayersAllowed: 8)
//        let game3 = Game(date: NSDate(), location: "James Madison", gameType: "3v3", numPlayersJoined: 3, totalPlayersAllowed: 6)
//        
//        games.append(game1)
//        games.append(game2)
//        games.append(game3)
        
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
        

    }
    
    override func viewWillAppear(animated: Bool) {
        gameRef.observeEventType(.Value, withBlock: { snapshot in
            
            //array to hold all of the currently available games
            //var newGames = [Game]()
            
            //dictionary of the new games from the server
            var newGamesDict = [String : [Game]]()
            
            //loop through all of the available games and add them to the list
            for game in snapshot.children {
                
                //create the game with the outer dictionary (everythign but the date)
                let newGame = Game(snapshot: game as! FDataSnapshot)
                
                let dateString = newGame.dateToString()
                
                //check if dictionary has the current value
                if newGamesDict[dateString] == nil {
                    //if it doesn't have the value add the date value to the dictionary
                    //create an array with the new game in it
                    let newGameArr : Array<Game> = [newGame]
                    
                    //initialize the array at that key
                    newGamesDict[dateString] = Array<Game>()
                    //sub the new game array into the spot of the empty array
                    newGamesDict[dateString] = newGameArr
                    
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
            self.gameDictionary = newGamesDict
            
            
            self.sortedKeysByDate()
            
            for date in self.sortedKeys {
                self.sortGamesByTime(date)
            }
            
            //do a pulldown to refresh
            self.tableView.reloadData()
            
            
        })
    }
    
    
    
    
    
    //MARK: - Table View Delegate Methods
    
    //method called when a row in the table view is clicked on
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        //send the event with the segue
        //print(indexPath.row)
        
        //get the date of the game clicked on
        let gameSection = Array(gameDictionary.keys)[indexPath.section]
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
        //return the keys for the section headers - sorted so they are in the correct order
        return sortedKeys[section]
    }
    
    
    //the number of sections in the table view - the number of dates that currently have games
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        //return the number of key value pairs in the dictionary
        return gameDictionary.count
    }
    
    
    
    //MARK: - Table View Data Source
    
    //method for the number of rows in the table
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //get the keys as an array. acess the row number of the array to get the key
        //get an array of the values and get the count from the dictionary
        
        //get the key of the value
        let key = sortedKeys[section]
        let gamesArr = gameDictionary[key]
        
        return (gamesArr?.count)!
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("GameCell") as! GameTableViewCell
        //get an array of the section titles
        let sectionArr = Array(gameDictionary.keys)
        //get the array of games based on the section of the table it is
        let gameArr = gameDictionary[sectionArr[indexPath.section]]
        //get the current game based on the row in the section it is
        let game = gameArr![indexPath.row]
        
        //setup cell labels from game object
        let locationText = game.location! + " " + game.gameType!
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
        //header.contentView.backgroundColor = orange
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
    
    
    //MARK: - Sorting Algorithms
    
    //sort the dictionary by date so the most recent games show in section 0
    func sortedKeysByDate() {
        //sorting algorithm from : http://stackoverflow.com/questions/29552292/how-do-you-sort-dates-in-a-dictionary
        let df = NSDateFormatter()
        df.dateFormat = "mm/dd/yy"

        let sorted = gameDictionary.sort{ df.dateFromString($0.0)!.compare(df.dateFromString($1.0)!) == .OrderedAscending}
        
        //clear the array so it can be resorted
        sortedKeys = Array<String>()
        
        //convert the tuple to a dictionary
        for tuple in sorted {
            //add the keys in order in which they are sorted
            sortedKeys.append(tuple.0)
            
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
                        //game time is before current time of day
                        //delete game from firebase
                        
                        
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
                if currDay > gameDay {
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
        
        var gameHour = Int(currTimeString.componentsSeparatedByString(":")[0])
        let gameMinute = Int(currTimeString.componentsSeparatedByString(":")[1].componentsSeparatedByString(" ")[0])
        let gameAMPM = currTimeString.componentsSeparatedByString(" ")[1]
        
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
    
}



