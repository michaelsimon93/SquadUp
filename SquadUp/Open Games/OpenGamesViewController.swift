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
    var games:[Game] = [Game]()
    
    //dictionary : keys is the date, value is an array of games on that specific date
    //date is formatted as "4/22/16" for the key search
    var gameDictionary = [String : [Game]]()
    
    let ref = Firebase(url: "https://squadupcs407.firebaseio.com")
    let gameRef = Firebase(url: "https://squadupcs407.firebaseio.com/games")
    
    
    
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
            var newGames = [Game]()
            
            //loop through all of the available games and add them to the list
            for game in snapshot.children {
                
                //create the game with the outer dictionary (everythign but the date)
                let newGame = Game(snapshot: game as! FDataSnapshot)
                
                newGames.append(newGame)
            }
            
            //set the new games from firebase to the current set
            self.games = newGames
            
            //do a pulldown to refresh
            self.tableView.reloadData()
            
            
        })
    }
    
    
    
    
    
    //MARK: - Table View Delegate Methods
    
    //method called when a row in the table view is clicked on
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        //send the event with the segue
        //print(indexPath.row)
        
        //game is a 5v5
        if games[indexPath.row].totalPlayersAllowed == 10 {
            //segue to the joining game view controller, pass the game to be given to the destination VC
            self.performSegueWithIdentifier("toTenPersonViewController", sender: games[indexPath.row])
        }
        //game is a 4v4
        else if games[indexPath.row].totalPlayersAllowed == 8 {
            //segue to the joining game view controller, pass the game to be given to the destination VC
            self.performSegueWithIdentifier("toEightPersonViewController", sender: games[indexPath.row])
        }
        //game is a 3v3
        else if games[indexPath.row].totalPlayersAllowed == 6 {
            //segue to the joining game view controller, pass the game to be given to the destination VC
            self.performSegueWithIdentifier("toSixPersonViewController", sender: games[indexPath.row])
        }

        //delselect the row so that when the game detail is popped off there isn't a cell stil highlighted
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    
    
    
    
    //MARK: - Table View Data Source
    //method for the number of rows in the table
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return games.count
    }
    
    //add method for sections in table view and make the sections by date
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("GameCell") as! GameTableViewCell
        
        
        //setup cell labels from game object
        let locationText = games[indexPath.row].location! + " " + games[indexPath.row].gameType!
        cell.locationLabel.text = locationText
        
        let numSpotsFilled = String(games[indexPath.row].numPlayersJoined!) + "/" + String(games[indexPath.row].totalPlayersAllowed!)
        cell.filledSpotsLabel.text = numSpotsFilled
        
        cell.timeLabel.text = timeFromDate(games[indexPath.row].date!)
        
        
        
        return cell
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
                
                
                self.games.append(newGame)
                
                self.tableView.reloadData()
                
                
                
                
            })
            

            
            //need to add backend stuff

            
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
    
    
    
    
}



