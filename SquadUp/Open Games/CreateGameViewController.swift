//
//  CreateGameViewController.swift
//  SquadUp
//
//  Created by Michael Oudenhoven on 3/15/16.
//  Copyright © 2016 CS 407. All rights reserved.
//

import UIKit

class CreateGameViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    let datePickCellID = "datePickerCell"
    let pickerCellID = "pickerCell"
    var selectedIndexPath : NSIndexPath?
    
    let pickerLocation = ["SERF", "NAT", "SHELL", "James Madison", "Gordon Outdoor"]
    let pickerGameType = ["5v5", "4v4", "3v3"]
    
    @IBOutlet weak var DateTimePicker: UIDatePicker!
    @IBOutlet weak var createGame_location: UITextField!
    @IBOutlet weak var createGame_type: UITextField!
    @IBOutlet weak var tableView: UITableView!
    
    //link to buttons so they can be customized through code
    @IBOutlet weak var createGameButton: UIButton!
    @IBOutlet weak var cancelGameButton: UIButton!
    
    
    //var newGame:[Game] = [Game]()
    var newGame : Game!
    var totalAllowed:Int = 0

    
    //orange color for the views
    let orange = UIColor(red: 0.86, green: 0.49, blue: 0.19, alpha: 1.0)

    //MARK: - Lifecycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        //configure the buttons to have custom borders
        configureFields()

        //set table view background to clear so background image shows through
        tableView.backgroundColor = UIColor.clearColor()
        
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        
        
        //remove the observers before removing the view
        for cell in tableView.visibleCells {
            //check if the cell is a date picker view cell
            if cell is DatePickerTableViewCell {
                //remove it as an observer
                (cell as! DatePickerTableViewCell).ignoreFrameChanges()
            }
            //regular picker cell
            else {
                //remove as observer
                (cell as! PickerTableViewCell).ignoreFrameChanges()
            }
            
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    //Mark: - Setup
    
    func configureFields() {
        //customize buttons to have border
        createGameButton.layer.borderWidth = 2.5
        createGameButton.layer.borderColor = UIColor.whiteColor().CGColor
        createGameButton.layer.cornerRadius = 5.0
        createGameButton.backgroundColor = orange
        
        cancelGameButton.layer.borderWidth = 2.5
        cancelGameButton.layer.borderColor = UIColor.whiteColor().CGColor
        cancelGameButton.layer.cornerRadius = 5.0
        cancelGameButton.backgroundColor = orange
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
    
    
    //MARK: - Table View Data Source
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    //MARK: - Table View Delegate
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        //first section of the table is the date picker section
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCellWithIdentifier(datePickCellID, forIndexPath: indexPath) as! DatePickerTableViewCell
            
            
            
            //configure first section labels here
            //cell.dateLabel.text = "Date"
            //cell.datePicker.date = NSDate()
            
            
            return cell
        }
        //other sections are the picker section
        else if indexPath.section ==  1 {
            let cell = tableView.dequeueReusableCellWithIdentifier(pickerCellID, forIndexPath: indexPath) as! PickerTableViewCell
            
            //configure second section labels here
            cell.leftLabel.text = "Location"
            cell.rightLabel.text = "SERF"
            cell.pickerItems = pickerLocation
            
            //configure picker view options here
            
            
            return cell
        }
        //third section is another picker view, but with only game type options
        else {
            let cell = tableView.dequeueReusableCellWithIdentifier(pickerCellID, forIndexPath: indexPath) as! PickerTableViewCell
            
            //configure labels
            cell.leftLabel.text = "Game Type"
            cell.rightLabel.text = "5v5"
            cell.pickerItems = pickerGameType
            
            //configure picker options
            
            
            return cell
        }

    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let previousIndexPath = selectedIndexPath
        if indexPath == selectedIndexPath {
            selectedIndexPath = nil
        } else {
            selectedIndexPath = indexPath
        }
        
        var indexPaths: Array<NSIndexPath> = []
        if let previous = previousIndexPath {
            indexPaths = [previous]
        }
        if let current = selectedIndexPath {
            indexPaths = indexPaths + [current]
        }
        
        if indexPaths.count > 0 {
            tableView.reloadRowsAtIndexPaths(indexPaths, withRowAnimation: UITableViewRowAnimation.Automatic)
        }
        
    }
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        //check the table section so the right method is called
        if indexPath.section == 0 {
            (cell as! DatePickerTableViewCell).watchFrameChanges()
        }
        else {
            (cell as! PickerTableViewCell).watchFrameChanges()
        }

    }
    
    func tableView(tableView: UITableView, didEndDisplayingCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        //check what seciton it is to see what method to call
        if indexPath.section == 0 {
            (cell as! DatePickerTableViewCell).ignoreFrameChanges()
        }
        else {
            (cell as! PickerTableViewCell).ignoreFrameChanges()
        }
   
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath == selectedIndexPath {
            return DatePickerTableViewCell.expandedHeight
        }
        else {
            return DatePickerTableViewCell.defaultHeight
        }
    }
    
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 20
    }
    
    
    //Mark: - IBAction Methods
    /*
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
     */
    

}
