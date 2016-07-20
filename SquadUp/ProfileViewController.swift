//
//  FirstViewController.swift
//  SquadUp
//
//  Copyright © 2016 CS 407. All rights reserved.
//

import UIKit
import Firebase

class ProfileViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    //MARK: - Properties
    
    @IBOutlet weak var profileImage: UIImageView!
    
    let profileOptionCellID = "profileOption"
    
    let ref = Firebase(url: "https://squadupcs407.firebaseio.com")
    let usersRef = Firebase(url: "https://squadupcs407.firebaseio.com/users")
    
    @IBOutlet weak var editNameButton: UIButton!
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var initialsLabel: UILabel!
    @IBOutlet weak var editInitialsButton: UIButton!
    
    @IBOutlet weak var numGamesPlayedLabel: UILabel!
    
    @IBOutlet weak var logOutButton: UIButton!
    
    var editNameAlert : UIAlertController?
    var editInitialsAlert : UIAlertController?
    
    //image to save to firebase as a string
    var base64String : String!
    
    //var user : Player?
    //auth data from user logging in - used to create Player object
    var userUID : String?
    
    
    //MARK: - Lifecycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
//        let playerRef = usersRef.childByAppendingPath(userUID)
//        
//        //get player information and make player object
//        playerRef.observeSingleEventOfType(.Value, withBlock: { (snapshot) in
//            //get the player reference
//            self.user = Player(snapshot: snapshot, uid: self.userUID!)
//            
//            let profileController = self.tabBarController?.viewControllers![3] as! ProfileViewController
//            //profileController.viewDidLoad()
//            profileController.user = self.user
//        })
//        
        
        //make the profile image a circle
        profileImage.layer.cornerRadius = profileImage.frame.size.width/2
        profileImage.layer.borderWidth = 2
        profileImage.layer.borderColor = UIColor.whiteColor().CGColor
        
        //add tap gesture recognizer for uimageview
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(ProfileViewController.imageTapped))
        tapGesture.numberOfTapsRequired = 1
        profileImage.addGestureRecognizer(tapGesture)
        
        //custom button setup
        editNameButton.layer.cornerRadius = 3
        editNameButton.layer.borderWidth = 1
        editNameButton.layer.borderColor = UIColor.whiteColor().CGColor
        
        editInitialsButton.layer.cornerRadius = 3
        editInitialsButton.layer.borderWidth = 1
        editInitialsButton.layer.borderColor = UIColor.whiteColor().CGColor
        
        logOutButton.layer.cornerRadius = 5
        logOutButton.layer.borderColor = UIColor.whiteColor().CGColor
        logOutButton.layer.borderWidth = 2
        
        //initialize alert controllers here
        initializeNameAlert()
        initializeInitialsAlert()
        
        if (self.tabBarController as? TabBarController)?.user?.profileImage != nil {
            profileImage.image = (self.tabBarController as? TabBarController)?.user?.profileImage
        }

        
        //getProfileImage()

        
    }
    
    override func viewWillAppear(animated: Bool) {
        let user = (self.tabBarController as? TabBarController)?.user
        //change the name initials and number of games played to the correct number
        //for the player
        nameLabel.text = user?.name!
        initialsLabel.text = "Initials: " + (user?.initials!)!
        let gamesPlayedString = String(user!.numGamesPlayed!)
        numGamesPlayedLabel.text = "Number of Games Played: " + gamesPlayedString
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //make status bar font white so it appears on the dark background
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
    }
    

    
    //MARK: - IBActions
    
    @IBAction func logOutClicked(sender: AnyObject) {
        //log user out
        ref.unauth()
        //go back to log in screen
        self.navigationController?.popToRootViewControllerAnimated(true)
    }
    
    
    @IBAction func editNameClicked(button: UIButton) {
        self.presentViewController(editNameAlert!, animated: true, completion: nil)
    }
    
    
    @IBAction func editInitialsClicked(button : UIButton) {
        self.presentViewController(editInitialsAlert!, animated: true, completion: nil)
    }
    
    
    
    //MARK: - Alert Controller Initialization
    
    func initializeNameAlert() {
        editNameAlert = UIAlertController(title: "Edit Name", message: "Enter the name you'd like friends to find you as.", preferredStyle: .Alert)
        editNameAlert?.addTextFieldWithConfigurationHandler({ (textField) in
            //textField.text = self.nameLabel!.text
            textField.placeholder = "name"
            textField.clearButtonMode = .WhileEditing
        })
        
        let okAction = UIAlertAction(title: "OK", style: .Default) { (alertAction) in
            
            //make sure the field isn't blank
            let textField = self.editNameAlert?.textFields?.first
            
            if textField?.text?.characters.count > 3 {
                //(self.tabBarController as? TabBarController)?.user?.
                //change name Label and update firebase
                self.nameLabel.text = textField?.text
                (self.tabBarController as? TabBarController)?.user?.ref?.updateChildValues(["name" : self.nameLabel.text!])
                (self.tabBarController as? TabBarController)?.user?.name = self.nameLabel.text
                
                //update constraints
                self.view.updateConstraints()
                
                //remove alert controller from profile controller
                self.editNameAlert?.removeFromParentViewController()
                
                
            }
            else {
                self.editNameAlert?.message = "Name must be longer than 3 characters."
                self.presentViewController(self.editNameAlert!, animated: true, completion: nil)
            }
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel) { (alertAction) in
            //cancel action - do nothing
        }
        
        //add the actions to the alert
        editNameAlert?.addAction(okAction)
        editNameAlert?.addAction(cancelAction)
        
    }
    
    func initializeInitialsAlert() {
        editInitialsAlert = UIAlertController(title: "Edit Initials", message: "Enter the two initials you'd like to be shown on your ball.", preferredStyle: .Alert)
        editInitialsAlert?.addTextFieldWithConfigurationHandler({ (textField) in
            textField.placeholder = "initials"
            textField.clearButtonMode = .WhileEditing
        })
        
        let okAction = UIAlertAction(title: "OK", style: .Default) { (alertAction) in
            //get the text field from the alert view
            let textField = self.editInitialsAlert?.textFields?.first
            
            //check they have entered initials and it is only 2 letters long
            if textField?.text?.characters.count == 2 {
                //get the initials and make them uppercase
                let initials = textField?.text?.uppercaseString
                
                //add 'Initials: ' before the entered initials - so the label stays the same
                self.initialsLabel.text = "Initials: " + initials!
                //update firebase and player object
                (self.tabBarController as? TabBarController)?.user?.ref?.updateChildValues(["initials" : initials!])
                (self.tabBarController as? TabBarController)?.user?.initials = initials!
                
                //update the constraints for the sreen
                self.view.updateConstraints()
                
                //remove alert controller from profile controller
                self.editNameAlert?.removeFromParentViewController()
                
                
            }
            else {
                self.editInitialsAlert?.message = "Initials must be two letters."
                self.presentViewController(self.editInitialsAlert!, animated: true, completion: nil)
            }
            
            
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel) { (alertAction) in
            //cancel action - do nothing
        }
        
        //add the actions to the alert
        editInitialsAlert?.addAction(okAction)
        editInitialsAlert?.addAction(cancelAction)
    }
    
    
    //MARK: - Image Picker
    //code from: https://www.hackingwithswift.com/example-code/media/how-to-choose-a-photo-from-the-camera-roll-using-uiimagepickercontroller
    
    func selectPicture() {
        let picker = UIImagePickerController()
        picker.allowsEditing = true
        picker.delegate = self
        presentViewController(picker, animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        //dismiss the image picker controller when the user clicks cancel
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        var newImage : UIImage
        
        if let possibleImage = info["UIImagePickerControllerEditedImage"] as? UIImage {
            newImage = possibleImage
        }
        else if let possibleImage = info["UIImagePickerControllerOriginalImage"] as? UIImage {
            newImage = possibleImage
        }
        else {
            return
        }
        
        //save image to firebase and update the uiimageview
        //print(newImage)
        
        profileImage.image = newImage
        
        let imageData : NSData = UIImagePNGRepresentation(newImage)!
        self.base64String = imageData.base64EncodedStringWithOptions(.Encoding64CharacterLineLength)
        
        (self.tabBarController as? TabBarController)?.user?.ref?.updateChildValues(["image" : base64String])
        (self.tabBarController as? TabBarController)?.user?.profileImageString = self.base64String
        (self.tabBarController as? TabBarController)?.user?.getProfileImage()
        
        dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    //user tapped on the image show image picker
    func imageTapped() {
        //print("image tapped")
        selectPicture()
        
    }
    
//    func getProfileImage() {
//        let user = (self.tabBarController as? TabBarController)?.user
//        
//        if user?.profileImageString != nil {
//            let decodedData = NSData(base64EncodedString: (user?.profileImageString)!, options: .IgnoreUnknownCharacters)
//            let decodedImage = UIImage(data: decodedData!)
//            self.profileImage.image = decodedImage
//        }
//        
//
//    }


}

