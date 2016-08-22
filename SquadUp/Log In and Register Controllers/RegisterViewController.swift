//
//  RegisterViewController.swift
//  SquadUp
//
//  Copyright © 2016 CS 407. All rights reserved.


import UIKit
import Firebase

class RegisterViewController: UIViewController, UITextFieldDelegate {

    //MARK: - Properties
    
    @IBOutlet weak var backgroundImage: UIImageView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var basketballImage: UIImageView!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var signUpButton: UIButton!
    //label to display if passwords do not match
    @IBOutlet weak var invalidEmailLabel: UILabel!
    

    
    //orange color for the views
    let orange = UIColor(red: 0.86, green: 0.49, blue: 0.19, alpha: 1.0)
    
    //scroll view setup to move when fields are being typed in
    @IBOutlet weak var scrollViewHeightConstraint : NSLayoutConstraint!
    //the default the scroll view height is. Intialized upon view did load
    var defaultScrollViewHeightConstraint: CGFloat = 0.0
    
    //backend properties
    //reference to firebase app
    let ref  = Firebase(url: "https://squadupcs407.firebaseio.com")
    let usersRef = Firebase(url: "https://squadupcs407.firebaseio.com/users")
    let numUsersRef = Firebase(url: "https://squadupcs407.firebaseio.com/numUsers")
    
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        //configure the background view (based on device and the basketball (if necessary)
        configureImages()
        
        //configure the custom text field and button borders
        configureFields()
        
        self.automaticallyAdjustsScrollViewInsets = false
        
        //add observers to call methods when the keyboard appears or dissappears - to adjust scroll view
        NSNotificationCenter.defaultCenter().addObserver(self,
                                                         selector: #selector(RegisterViewController.keyboardWillShow(_:)),
                                                         name: UIKeyboardWillShowNotification,
                                                         object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self,
                                                         selector: #selector(RegisterViewController.keyboardWillHide(_:)),
                                                         name: UIKeyboardWillHideNotification,
                                                         object: nil)

        
        
    }
    
    override func viewWillAppear(animated: Bool) {
        
    }
    
    override func viewDidDisappear(animated: Bool) {
        
        //remove observers when view is destroyed
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //make status bar font white so it appears on the dark background
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
    }
    
    
    //MARK: - Initialization
    
    func configureFields() {
        //initially hide the incorrect email label
        invalidEmailLabel.hidden = true
        
        //configure the custom text field and button borders
        emailTextField.layer.borderWidth = 2.0
        emailTextField.layer.borderColor = orange.CGColor
        emailTextField.layer.cornerRadius = 5.0

        
        signUpButton.layer.borderWidth = 2.0
        signUpButton.layer.borderColor = UIColor.whiteColor().CGColor
        signUpButton.layer.cornerRadius = 5.0
        signUpButton.backgroundColor = orange
    }
    
    func configureImages() {
        //backgroundImage.backgroundColor = UIColor.grayColor()
        //basketballImage.backgroundColor = UIColor.blackColor()
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    
    //MARK: - IBActions
    
    @IBAction func backClicked(sender: AnyObject) {
        //pop back to the sign in view
        self.navigationController?.popToRootViewControllerAnimated(true)
    }
    
    
    @IBAction func signUpClicked(sender: AnyObject) {
        
        //check to make sure user is a wisc account
        if emailTextField.text?.rangeOfString("wisc.edu") != nil {
            //generate a random password and then send user a reset password email - this is a way around
            //firebase not having a verification email process
            let tempPassword = generateRandomPassword()
            
            // create user using firebase
            self.ref.createUser(emailTextField.text, password: tempPassword) { (error: NSError!) in
                //check if there was an error creating the account
                if error == nil {
                    
                    //no error creating account, segue to confirmation view controller
                    self.performSegueWithIdentifier("toConfirmationViewController", sender: nil)
                    
                    //authorize the user so that
                    self.ref.authUser(self.emailTextField.text, password: tempPassword, withCompletionBlock: { (error, authData) in
                        //create the user in the list of users on firebase with auth data
                        self.createUserOnFirebase(authData)
                        
                        //unauthorize, done using UID
                        self.ref.unauth()
                        
                        //reset user account password so they have to verify their account
                        self.ref.resetPasswordForUser(self.emailTextField.text, withCompletionBlock: { error in
                            if error != nil {
                                // There was an error processing the request
                            } else {
                                // Password reset sent successfully
                            }
                        })
                    })
                    
                }
                
                //else there was an error creating the account 
                else {
                    //error code -9 - account is already in existence
                    if error.code == -9 {
                        self.invalidEmailLabel.text = "account already exists"
                        self.invalidEmailLabel.hidden = false
                    }
                    //all other errors tell user an error occured
                    else {
                        self.invalidEmailLabel.text = "an error occurred, please try again."
                        self.invalidEmailLabel.hidden = false
                    }
                }
            }
            
            


        }
            
        //user typed an email address without a wisc.edu ending - display message
        else {
            //check to make sure they are registering with a wisc account
            //show label
            invalidEmailLabel.text = "please use a 'wisc.edu' email"
            invalidEmailLabel.hidden = false
            
            //shake the email field
            shakeEmailField()
            //clear the text field
            emailTextField.text = ""

        
        }
    }
    
    
    
    //MARK: - Animations
    
    //method called when the user doesn't type in matching passwords. Shakes the password fields
    func shakeEmailField() {
        let animation = CABasicAnimation()
        animation.duration = 0.05
        animation.repeatCount = 2
        animation.autoreverses = true
        animation.fromValue = NSValue(CGPoint: CGPointMake(emailTextField.center.x-10, emailTextField.center.y))
        animation.toValue = NSValue(CGPoint: CGPointMake(emailTextField.center.x+10, emailTextField.center.y))

        
        //add animation to fields. will be the same animation b/c only x-values are changed
        emailTextField.layer.addAnimation(animation, forKey: "position")
 
    }
    
    
    //MARK: - Observer Methods
    
    //method to make scroll view function when the keyboard appears
    func keyboardWillShow(notification: NSNotification) {
        //print("keyboard will show")
        
        //get the size of the keyboard and add it to the scroll view height so that the user can access all fields and buttons
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.CGRectValue() {
            scrollViewHeightConstraint.constant += keyboardSize.height
        }
        
    }
    
    func keyboardWillHide(notification : NSNotification) {
        //print("keyboard will hide")
        
        //keyboard hiding set scroll view back to regular height
        self.scrollViewHeightConstraint.constant = self.defaultScrollViewHeightConstraint
        
    }
    
    //MARK: - Miscellaneous
    
    func generateRandomPassword() -> String {
        let characters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789!?_-"
        var possibleChars = [Character](characters.characters)
        var password = ""
        for _ in 1 ..< 16 {
            password += String(possibleChars[Int.random(min: 0, max: possibleChars.count-1)])
        }
        
        return password
    }
    
    //MARK: - Text Field Delegate Methods
    
    func textFieldDidBeginEditing(textField: UITextField) {
        //clear the email field only the first time it is edited
        if textField.text == "email" {
            textField.text = ""
        }
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        
    }
    
    //method to hide the keyboard when the 'Done' button is clicked on the keyboard
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        
        //clicked go on the password section to log in
        if textField.returnKeyType == UIReturnKeyType.Go {
            
            //close the keyboard
            self.view.endEditing(true)
            return false
            
        }
        
        
        //done clicked from email box, close the keyboard
        self.view.endEditing(true)
        return false
        
    }
    
    
    //MARK: - Firebase
    func createUserOnFirebase(authData : FAuthData) {
        //get users unique uid for storing their account information
        let uid = authData.uid
        
        //endpoint in which the users information is saved on firebase
        let userEndpoint = usersRef.childByAppendingPath(uid)
        
        //make the initials the first two letters of their email
        
        let index = emailTextField.text?.startIndex.advancedBy(2)
        
        
        let initials = emailTextField.text?.substringToIndex(index!).uppercaseString
        let name = "Anonymous Baller"
        
        let newPlayer = Player(uid: uid, email: emailTextField.text!, initials: initials!, numGamesPlayed: 0, name: name)
        
        userEndpoint.updateChildValues(newPlayer.toDictionary() as! [NSObject : AnyObject])
        
        //add one to the number of app users
        numUsersRef.observeSingleEventOfType(.Value, withBlock: { (snapshot) in
            
            var numUsers = snapshot.value as? Int
            numUsers! = numUsers! + 1
            
            self.ref.updateChildValues(["numUsers" : numUsers!])
            
            
        })
    }

}
