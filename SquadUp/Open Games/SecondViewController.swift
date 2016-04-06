//
//  SecondViewController.swift
//  SquadUp
//
//  Created by Michael Oudenhoven on 3/5/16.
//  Copyright © 2016 CS 407. All rights reserved.
//

import UIKit

class SecondViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    @IBOutlet weak var tableView: UITableView!
    
    
    //array holding all of the currently available games
    var games:[Game] = [Game]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        //load some generic games into the table view
        let game1 = Game(time: "5:30 PM", location: "SERF", gameType: "5v5", numPlayersJoined: 5, totalPlayersAllowed: 10)
        let game2 = Game(time: "7:00 PM", location: "NAT", gameType: "5v5", numPlayersJoined: 2, totalPlayersAllowed: 10)
        let game3 = Game(time: "9:00 PM", location: "James Madison", gameType: "3v3", numPlayersJoined: 3, totalPlayersAllowed: 6)
        
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
        
        //get the event that the user clicked on and send it with the segue
        //let toSend = events[indexPath.row]
        self.performSegueWithIdentifier("toGameDetailViewController", sender: nil)
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
        
        cell.timeLabel.text = games[indexPath.row].time!
        
        
        
        return cell
    }


}

