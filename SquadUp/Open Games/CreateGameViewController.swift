//
//  CreateGameViewController.swift
//  SquadUp
//
//  Created by Michael Oudenhoven on 3/15/16.
//  Copyright © 2016 CS 407. All rights reserved.
//

import UIKit

class CreateGameViewController: UIViewController {

    @IBOutlet weak var DateTimePicker: UIDatePicker!
    @IBOutlet weak var createGame_location: UITextField!
    @IBOutlet weak var createGame_type: UITextField!
    
    //var newGame:[Game] = [Game]()
    var newGame : Game!
    var totalAllowed:Int = 0


    @IBAction func createGame_button(sender: UIButton) {
        //need to add backend stuff
        
        //convert the DateTimePicker
        let formatter = NSDateFormatter()
        formatter.dateStyle = NSDateFormatterStyle.ShortStyle
        formatter.timeStyle = .ShortStyle
        let fullDate:String = formatter.stringFromDate(DateTimePicker.date)
        var fullDateArr = fullDate.componentsSeparatedByString(" ")
        let str_date:String = fullDateArr[0]
        let str_time:String = fullDateArr[1]
        
        
        //find total amount of players allowed
        if (createGame_type == "3v3" || createGame_type == "3V3") {
            totalAllowed = 6
        } else if (createGame_type == "4v4" || createGame_type == "4V4") {
            totalAllowed = 8
        } else if (createGame_type == "5v5" || createGame_type == "5V5") {
            totalAllowed = 10
        }
        
        newGame.setValue(str_date, forKey: "date")
        newGame.setValue(str_time, forKey: "time")
        newGame.setValue(createGame_location, forKey: "location")
        newGame.setValue(createGame_type, forKey: "gameType")
        newGame.setValue(1, forKey: "numPlayersJoined")
        newGame.setValue(totalAllowed, forKey: "totalPlayersAllowed")
        
        performSegueWithIdentifier("createGame", sender: self)
    }
    
    @IBAction func cancel_button(sender: UIButton) {
        performSegueWithIdentifier("cancelCreateGame", sender: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if (segue.identifier == "createGame") {
            let vc = segue.destinationViewController as! SecondViewController
            vc.games.append(newGame)
        }
        
        /*
        else if (segue.identifier == "cancelCreateGame") {
            let vc = segue.destinationViewController as! SecondViewController
        }
        */
    }
    

}
