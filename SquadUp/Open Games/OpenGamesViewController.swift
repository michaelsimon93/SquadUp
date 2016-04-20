//
//  SecondViewController.swift
//  SquadUp
//
//  Created by Michael Oudenhoven on 3/5/16.
//  Copyright © 2016 CS 407. All rights reserved.
//

import UIKit

class OpenGamesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    @IBOutlet weak var tableView: UITableView!
    
    
    //array holding all of the currently available games
    var games:[Game] = [Game]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        //load some generic games into the table view
        let game1 = Game(date: NSDate(), location: "SERF", gameType: "5v5", numPlayersJoined: 5, totalPlayersAllowed: 10)
        let game2 = Game(date: NSDate(), location: "NAT", gameType: "4v4", numPlayersJoined: 2, totalPlayersAllowed: 8)
        let game3 = Game(date: NSDate(), location: "James Madison", gameType: "3v3", numPlayersJoined: 3, totalPlayersAllowed: 6)
        
        games.append(game1)
        games.append(game2)
        games.append(game3)
        
        tableView.rowHeight = 50.0
        //tableView.backgroundView = UIImageView(image: UIImage(named: "background"))
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
        print("create game unwind")
        
        if segue.identifier == "createGameUnwind" {
            //get the source VC where the data is stored for the new game
            let sourceVC = segue.sourceViewController as! CreateGameViewController
            
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
            
            let newGame = Game(date: gameDate!, location: gameLocation!, gameType: gameType!, numPlayersJoined: 0, totalPlayersAllowed: totalAllowed)
            

            games.append(newGame)
            
            tableView.reloadData()
            
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


