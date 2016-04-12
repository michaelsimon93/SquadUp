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
    let gamePickerCellID = "gamePickerCell"
    var selectedIndexPath : NSIndexPath?
    
    //set the default strings for the right hand labels of the cells
    var gameLocation = "SERF"
    var gameType = "5v5"
    var gameDate : NSDate?
    
    let pickerLocation = ["SERF", "NAT", "SHELL", "James Madison", "Gordon Outdoor"]
    let pickerGameType = ["5v5", "4v4", "3v3"]
    
    //INSTEAD OF REF TO DATE PICKER HERE NEED TO GET DATE PICKER REF FROM TABLE VIEW CELL
    //@IBOutlet weak var DateTimePicker: UIDatePicker!
    //@IBOutlet weak var createGame_location: UITextField!
    //@IBOutlet weak var createGame_type: UITextField!
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
        
        //configure the current game date to be to the nearest 15 min ahead of current time.
        gameDate = NSDate()
        let cal = NSCalendar(identifier: NSCalendarIdentifierGregorian)!
        let components = cal.components([.Day , .Month, .Year, .Hour ], fromDate: gameDate!)
        //get the current minute
        let currMinute = NSCalendar.currentCalendar().component(.Minute, fromDate: gameDate!)
        let roundedMinute = currMinute - (currMinute%15) + 15
        components.minute = roundedMinute
        
        //set the new rounded date as the time selected
        gameDate = cal.dateFromComponents(components)
        
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
            else if cell is PickerTableViewCell {
                //remove as observer
                (cell as! PickerTableViewCell).ignoreFrameChanges()
            }
            else if cell is GamePickerTableViewCell {
                //remove observer
                (cell as! GamePickerTableViewCell).ignoreFrameChanges()
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
    
    
    //MARK: - Table View Data Source
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    //MARK: - Table View Delegate
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        //debugging prints
        //print("cell for row at index")
        //print("section\(indexPath.section)")
        //print("row\(indexPath.row)")
        
        //first section of the table is the date picker section
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCellWithIdentifier(datePickCellID, forIndexPath: indexPath) as! DatePickerTableViewCell
            
            
            
            //configure first section labels here
            //cell.dateLabel.text = "Date"
            //cell.datePicker.date = NSDate()
            
            //set the label to the current date and time
            cell.dateLabel.text = formatDate(gameDate!)
            
            return cell
        }
        //other sections are the picker section
        else if indexPath.section ==  1 {
            //let cell = PickerTableViewCell(style: .Default, reuseIdentifier: pickerCellID)
            let cell = tableView.dequeueReusableCellWithIdentifier(pickerCellID, forIndexPath: indexPath) as! PickerTableViewCell
            
            cell.selectedRow = 0
            cell.pickerItems = []
            
            //configure second section labels here
            cell.leftLabel.text = "Location"
            cell.rightLabel.text = gameLocation
            cell.pickerItems = pickerLocation
            
            //configure picker view options here
            
            
            return cell
        }
        //third section is another picker view, but with only game type options
        else if indexPath.section == 2 {
            //let cell = PickerTableViewCell(style: .Default, reuseIdentifier: pickerCellID)
            let cell = tableView.dequeueReusableCellWithIdentifier(gamePickerCellID, forIndexPath: indexPath) as! GamePickerTableViewCell
            
            cell.selectedRow = 0
            cell.pickerItems = []
            
            //configure labels
            cell.leftLabel.text = "Game Type"
            cell.rightLabel.text = gameType
            cell.pickerItems = pickerGameType
            
            //configure picker options
            
            
            return cell
        }
        
        return tableView.dequeueReusableCellWithIdentifier(datePickCellID)!

    }
    

    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        //print(indexPath.section)
        //print(indexPath.row)
        //code here to manage the display of the collapsed cell
        
        //get the cell in the first section - time cell
        let indexPath1 = NSIndexPath(forRow: 0, inSection: 0)
        let cell1 = tableView.cellForRowAtIndexPath(indexPath1) as! DatePickerTableViewCell
        let date = cell1.datePicker.date
        //set the games NSDate
        gameDate = date
        //format the date to be displayed in the cell
        let formattedDate = formatDate(date)
        //set the labels text
        cell1.dateLabel.text = formattedDate
        
        
        //get the cell in the second section - location cell
        let indexPath2 = NSIndexPath(forRow: 0, inSection: 1)
        let cell2 = tableView.cellForRowAtIndexPath(indexPath2) as! PickerTableViewCell
        var row  = cell2.selectedRow
        gameLocation = pickerLocation[row]
            
        //get the cell in the third section - game type cell
        let indexPath3 = NSIndexPath(forRow: 0, inSection: 2)
        let cell3 = tableView.cellForRowAtIndexPath(indexPath3) as! GamePickerTableViewCell
        row = cell3.selectedRow
        gameType = pickerGameType[row]
        
        
        //collapsable cell code
        let previousIndexPath = selectedIndexPath
        if indexPath == selectedIndexPath {
            selectedIndexPath = nil
        } else {
            selectedIndexPath = indexPath
        }
        
        var indexPaths : Array<NSIndexPath> = []
        if let previous = previousIndexPath {
            indexPaths += [previous]
        }
        if let current = selectedIndexPath {
            indexPaths += [current]
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
        else if indexPath.section == 1 {
            (cell as! PickerTableViewCell).watchFrameChanges()
        }
        else {
            (cell as! GamePickerTableViewCell).watchFrameChanges()
        }

    }
    
    func tableView(tableView: UITableView, didEndDisplayingCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        //check what seciton it is to see what method to call
        if indexPath.section == 0 {
            (cell as! DatePickerTableViewCell).ignoreFrameChanges()
        }
        else if indexPath.section == 1 {
            (cell as! PickerTableViewCell).ignoreFrameChanges()
        }
        else {
            (cell as! GamePickerTableViewCell).ignoreFrameChanges()
        }
   
    }
    
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        //just use the date picker heights, all of them are the same for all cells
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
    
    
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if (segue.identifier == "createGame") {
            let vc = segue.destinationViewController as! OpenGamesViewController
            vc.games.append(newGame)
        }
        
        /*
         else if (segue.identifier == "cancelCreateGame") {
         let vc = segue.destinationViewController as! SecondViewController
         }
         */
    }

    
    //MARK: - Utilities
    
    //method that formats the date to the correct way it should be displayed in the date cell when closed
    func formatDate(date: NSDate) -> String {
        
        //convert the DateTimePicker
        let formatter = NSDateFormatter()
        formatter.dateStyle = .ShortStyle
        formatter.timeStyle = .ShortStyle
        //get the full date in terms of a string and return it
        let fullDate = formatter.stringFromDate(date)
        
        //gets separate components of the string if necessary
        //var fullDateArr = fullDate.componentsSeparatedByString(" ")
        //let str_date:String = fullDateArr[0]
        //let str_time:String = fullDateArr[1]
        

        return fullDate
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
