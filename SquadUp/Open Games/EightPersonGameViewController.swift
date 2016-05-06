//
//  EightPersonGameViewController.swift
//  SquadUp
//
//  Created by Michael Oudenhoven on 4/12/16.
//  Copyright © 2016 CS 407. All rights reserved.
//

import UIKit
import Firebase

class EightPersonGameViewController: UIViewController {

    //MARK: - Properties
    
    //outlet to customize the font to fit style of the app
    @IBOutlet weak var backButton: UIBarButtonItem!

    //array holding players uid's if they are joined, if not joined spot is empty string
    var players = ["", "", "", "", "", "", "", ""]
    
    //tag for basketball and initials label so it can be deleted when user leaves
    let deleteTag = 1000
    
    //user object to be used when the user clicks a chair and should join the game
    var user : Player?
    
    //the game the user is viewing
    var game : Game?
    
    //alert that shows if the user wants to leave the game for sure or not
    var alertLeaveGame : UIAlertController?
    //chair number clicked - so if user confirms they want to leave they have the chair number
    var chairNumClicked : Int = 0
    
    //title of game displayed on the navigation bar
    @IBOutlet weak var gameTitle: UINavigationItem!
    
    //label to change if user is already in the game
    @IBOutlet weak var notificationLabel: UILabel!
    
    @IBOutlet weak var chair0Button: UIButton!
    @IBOutlet weak var chair1Button: UIButton!
    @IBOutlet weak var chair2Button: UIButton!
    @IBOutlet weak var chair3Button: UIButton!
    @IBOutlet weak var chair4Button: UIButton!
    @IBOutlet weak var chair5Button: UIButton!
    @IBOutlet weak var chair6Button: UIButton!
    @IBOutlet weak var chair7Button: UIButton!

    //chair button array to intially set up chairs that are filled
    var chairArr : [UIButton]?
    
    //Firebase
    let usersRef = Firebase(url: "https://squadupcs407.firebaseio.com/users")
    
    
    //MARK: - Lifecycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        backButton.setTitleTextAttributes([ NSFontAttributeName: UIFont(name: "Futura", size: 15)!], forState: UIControlState.Normal)
        
        //array of chair buttons for intiial setup
        chairArr = [chair0Button, chair1Button, chair2Button, chair3Button, chair4Button, chair5Button, chair6Button, chair7Button]
        
        //give the controller the games players
        players = (game?.players)!
        
        gameTitle.title = (game?.location)! + " at " + timeFromDate((game?.date)!)
        
        //configure the alert controller
        alertLeaveGame = UIAlertController(title: "Leave Game?", message: "Are you sure you want to leave the game?", preferredStyle: .Alert)
        
        let confirm = UIAlertAction(title: "Leave", style: .Default) { (alert: UIAlertAction!) -> Void in
            //make the user leave the game
            //remove the user from the game
            self.removeUserFromGame(self.chairNumClicked)
            self.notificationLabel.text = "LET'S BALL (TAP CHAIR TO JOIN)"
            //remove graphics from chair that user left
            let subViews = (self.chairArr![self.chairNumClicked-1]).subviews
            for subView in subViews {
                if subView.tag == self.deleteTag {
                    subView.removeFromSuperview()
                }
                
            }
            
        }
        let cancel = UIAlertAction(title: "Cancel", style: .Default) { (alert: UIAlertAction!) -> Void in
            //do nothign the user cancelled leaving
        }
        //add the actions to the alert
        alertLeaveGame?.addAction(cancel)
        alertLeaveGame?.addAction(confirm)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        //show leave game button if and only if the user is already in the game
        if userInGame() {
            notificationLabel.text = "TAP CHAIR TO LEAVE GAME"
        }
        else {
            notificationLabel.text = "LET'S BALL (TAP CHAIR TO JOIN)"
        }
        
        //loop through the players uids, for those that aren't empty strings request their
        //intiials from firebase then add basketball and initials on chair
        
        for (i,player) in players.enumerate() {
            //check to see if player is actually a player or empty seat
            if player != "" {
                //actually a player - get initials
                //get player endpoint by adding their uid to the end of the users ref
                let playerEndpoint = usersRef.childByAppendingPath(player)
                
                playerEndpoint.observeSingleEventOfType(.Value, withBlock: { (snapshot) in
                    let userInitial = snapshot.value["initials"] as? String
                    //add the ball to the chair of the user in the game currently
                    self.addBallToChair(self.chairArr![i], initials: userInitial!)
                    
                })
                
            }
        }
        
    }
    

    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "toPlayerDetail" {
            //give the profile detail the user to be displayed
            let destVC = segue.destinationViewController as! ProfileDetailViewController
            destVC.user = sender as? Player
        }
        
    }

    
    //MARK: - IBActions
    
    @IBAction func chairClicked(chair: UIButton) {
        //set the chair that was clicked
        chairNumClicked = chair.tag
        
        //check if the user is currently in the game
        if userInGame() {
            //user in the game check if the chair they clicked on is theirs
            if userCanLeaveChair(chair.tag) {
                //present the alert game to confirm the user actually wants to leave
                self.presentViewController(self.alertLeaveGame!, animated: true, completion: nil)
                
            }
            
            //user clicked not their chair, don't leave game, take to others profile here if possible
                //user taped a chair that is occupied and they aren't currently in the game
                //prompt other users profile to show if time
            else {
                //get the players uid
                let playerUID = players[chair.tag-1]
                usersRef.childByAppendingPath(playerUID).observeSingleEventOfType(.Value, withBlock: { (snapshot) in
                    let player = Player(snapshot: snapshot, uid: playerUID)
                    
                    self.performSegueWithIdentifier("toPlayerDetail", sender: player)
                })
                
            }
        }
            //user is currently not in the game
        else {
            //check if the chair the user clicked is not already occupied
            if userCanJoinChair(chair.tag) {
                //add the user to the game since the chair isn't occupied
                addUserToGame(chair.tag)
                
                addBallToChair(chair, initials: (user?.initials)!)
                notificationLabel.text = "TAP CHAIR TO LEAVE GAME"
                
            }
            //user taped a chair that is occupied and they aren't currently in the game
            //prompt other users profile to show if time
            else {
                //get the players uid
                let playerUID = players[chair.tag-1]
                usersRef.childByAppendingPath(playerUID).observeSingleEventOfType(.Value, withBlock: { (snapshot) in
                    let player = Player(snapshot: snapshot, uid: playerUID)
                    
                    self.performSegueWithIdentifier("toPlayerDetail", sender: player)
                })
                
            }
        }
        
        
        
        
    }
    
    //adds user to the game physically in firebase
    func addUserToGame(chairNum : Int) {
        //set the user to the players array based on the chair they clicked on and send the update to firebase
        //chair num -1 because tags must start at 1
        players[chairNum-1] = (user?.uid)!
        game?.players = self.players
        game?.ref?.updateChildValues(["players" : (game?.playersToDictionary())!])
        //add one to the number of players inthe game
        game?.ref?.updateChildValues(["numPlayersJoined" : ((game?.numPlayersJoined)!+1)])
        //add one to the game object in case use immediately
        game?.numPlayersJoined! += 1
    }
    
    //removes the user from the game in firebase and on the screen
    func removeUserFromGame(chairNum: Int) {
        //search for the game.players for their uid
        //remove the basketball subview from the chair
        //remove the user from firebase data - from players and subtract one from numPlayersJoined
        
        //set the player string to empty string uid
        players[chairNum-1] = ""
        //give the updated player array to the game object
        game?.players = self.players
        //update the player array on firebase
        game?.ref?.updateChildValues(["players" : (game?.playersToDictionary())!])
        //subtract one to the number of players inthe game on firebase
        game?.ref?.updateChildValues(["numPlayersJoined" : ((game?.numPlayersJoined)!-1)])
            game?.numPlayersJoined = (game?.numPlayersJoined)!-1
        
    }
    
    //checks if the user is allowed to join the game based on the chair they clicked on
    func userCanJoinChair(chairNum : Int) -> Bool {
        //check if the chair clicked on is not occupied
        //already checked that the user was not already joined in the game
        
        //check if the user clicked on an empty chair
        if players[chairNum-1] == "" {
            //empty chair clicked on return true
            return true
        }
        //user clicked on an occupied chair, they cannot join this chair
        return false
    }
    
    //checks to see if the user can leave the game based on the chair they clicked on
    func userCanLeaveChair(chairNum : Int) -> Bool {
        
        if players[chairNum-1] == user?.uid {
            return true
        }
        //user uid did not match the chair they clicked on - they cannot leave the chair
        return false
        
    }
    
    //checks if the game is currently in the game or not. Will tell if the user is trying to join or leave
    //the game
    func userInGame() -> Bool {
        //loop through all of the players in the game
        for i in 0..<players.count {
            //check if the players uid is the same as the one in the array
            if players[i] == user?.uid {
                //user is in the game already
                return true
            }
        }
        //user uid not found, user not in game
        return false
    }
    
    
    //adds the basektball and initials of the palyer to the basketball on the chair
    func addBallToChair(chairButton : UIButton, initials : String) {
        //add graphics to screen for user to join
        let basketballImage = UIImageView(frame: CGRectMake(0, 0, chairButton.frame.width-15, chairButton.frame.width-15))
        basketballImage.image = UIImage(named: "basketball")
        basketballImage.center = CGPoint(x: chairButton.frame.width/2, y: chairButton.frame.height/2-25)
        
        let initialsLabel = UILabel(frame: basketballImage.frame)
        initialsLabel.text = initials
        initialsLabel.font = UIFont(name: "Futura", size: 18.0)
        initialsLabel.textColor = UIColor.whiteColor()
        initialsLabel.textAlignment = .Center
        initialsLabel.center = basketballImage.center
        
        //set the tag so the subviews can be found if they want to be deleted (player leaves)
        initialsLabel.tag = deleteTag
        basketballImage.tag = deleteTag
        
        //add the basketball to the chair
        chairButton.addSubview(basketballImage)
        //add the initials to the basketball
        chairButton.addSubview(initialsLabel)
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
