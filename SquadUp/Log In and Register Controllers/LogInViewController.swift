//
//  LogInViewController.swift
//  SquadUp
//
//  Copyright © 2016 CS 407. All rights reserved.
//

import UIKit
import Firebase

class LogInViewController: UIViewController, UITextFieldDelegate {

    //MARK: - Properties
    
    @IBOutlet weak var backgroundImage: UIImageView!
    @IBOutlet weak var basketballImage: UIImageView!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var logInButton: UIButton!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var scrollViewHeightConstraint : NSLayoutConstraint!
    @IBOutlet weak var invalidCredentialsLabel: UILabel!
    
    //handle to remove the auth observer
    var handle : UInt?
    
    //the default the scroll view height is. Intialized upon view did load
    var defaultScrollViewHeightConstraint: CGFloat = 0.0
    //active text field to scroll up to
    var activeField : UITextField?

    //orange color for the views
    let orange = UIColor(red: 0.86, green: 0.49, blue: 0.19, alpha: 1.0)
    
    //temproary auth data to hold users uid
    var tempAuthData : FAuthData?
    
    //backend properties
    //reference to firebase app
    let ref  = Firebase(url: "https://squadupcs407.firebaseio.com")
    let usersRef = Firebase(url: "https://squadupcs407.firebaseio.com/users")
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        
        
        super.viewDidLoad()      
        // Do any additional setup after loading the view.
        
        //configure the custom text field, button borders, and image views
        configureFields()
        configureImages()
        
        self.automaticallyAdjustsScrollViewInsets = false
        
        //make a copy of the constraint value for when the keybboard closes, can reset the auto layout
        defaultScrollViewHeightConstraint = self.scrollViewHeightConstraint.constant
        
        //add observers to call methods when the keyboard appears or dissappears - to adjust scroll view
        NSNotificationCenter.defaultCenter().addObserver(self,
                                                         selector: #selector(LogInViewController.keyboardWillShow(_:)),
                                                         name: UIKeyboardWillShowNotification,
                                                         object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self,
                                                         selector: #selector(LogInViewController.keyboardWillHide(_:)),
                                                         name: UIKeyboardWillHideNotification,
                                                         object: nil)
        
    }
    
    
    override func viewWillAppear(animated: Bool) {
        //check if the user can bypass the log in screen
        handle = ref.observeAuthEventWithBlock { (authData) -> Void in
            
            if authData != nil {
                //save the temp auth data
                self.tempAuthData = authData
                
                //check if there is authentication data - bypass log in screen
                //check if the password was a temp password
                let isTempPass = authData.providerData["isTemporaryPassword"] as? Bool
                //print("isTempPass \(isTempPass)")
                
                //make sure it is a temp password and the user has entered an email
                if isTempPass! == true && self.emailTextField.text != "email" {
                    //segue to a reset password screen - pass email with it
                    self.performSegueWithIdentifier("toChangePasswordViewController", sender: self.emailTextField.text)
                }
                    
                    //not a temp password
                else {
                    //segue to the home screen
                    //send player object with segue
                    self.performSegueWithIdentifier("toHomeViewController", sender: authData.uid)
                    
                }
            }

            
            
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
 
        

        
        
    }
    
    override func viewDidDisappear(animated: Bool) {
       
        //remove observers when view is destroyed
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
        
        //remove the auth observer
        ref.removeObserverWithHandle(handle!)
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
        //initially hide the invalid user/password combo label
        invalidCredentialsLabel.hidden = true
        
        //configure the custom text field and button borders
        emailTextField.layer.borderWidth = 2.5
        emailTextField.layer.borderColor = orange.CGColor
        emailTextField.layer.cornerRadius = 7.0
        
        passwordTextField.layer.borderWidth = 2.5
        passwordTextField.layer.borderColor = orange.CGColor
        passwordTextField.layer.cornerRadius = 5.0
        
        
        logInButton.layer.borderWidth = 2.5
        logInButton.layer.borderColor = UIColor.whiteColor().CGColor
        logInButton.layer.cornerRadius = 5.0
        logInButton.backgroundColor = orange
        

    }
    
    func configureImages() {
        //backgroundImage.backgroundColor = UIColor.grayColor()
        //basketballImage.backgroundColor = UIColor.blackColor()
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        
        
        //going to the main screen
        if segue.identifier == "toHomeViewController" {
            
            let tabController = segue.destinationViewController as! TabBarController
            let openGamesController = tabController.viewControllers?[0] as! OpenGamesViewController
            let profileController = tabController.viewControllers?[3] as! ProfileViewController
            //auth data passed as sender
            openGamesController.userUID = (sender as! String)
            profileController.userUID = (sender as! String)
            tabController.userUID = (sender as! String)
            
        }
        
        if segue.identifier == "toChangePasswordViewController" {
            //print(sender as! String)
            let destVC = segue.destinationViewController as! ChangePasswordViewController
            //pass the email with the password to be reset
            destVC.email = sender as? String
            destVC.userUID = tempAuthData?.uid
            
        }
        
        //clear the password field - so it isn't filled in upon log out
        self.passwordTextField.text = "password"
        //self.emailTextField.text = "email"
        
    }

    
    //MARK: - Animations
    
    func shakeTextField() {
        let animation = CABasicAnimation()
        animation.duration = 0.05
        animation.repeatCount = 2
        animation.autoreverses = true
        animation.fromValue = NSValue(CGPoint: CGPointMake(passwordTextField.center.x-10, passwordTextField.center.y))
        animation.toValue = NSValue(CGPoint: CGPointMake(passwordTextField.center.x+10, passwordTextField.center.y))

        passwordTextField.layer.addAnimation(animation, forKey: "position")
        passwordTextField.text = ""
    }
    
    
    //MARK: - IBActions
    
    @IBAction func logInClicked(sender: AnyObject) {
        //print("log in clicked")
        

        if emailTextField.text != nil && passwordTextField.text != nil {
            
            ref.authUser(emailTextField.text, password: passwordTextField.text,
                         withCompletionBlock: { (error, authData) in
                            
                            if error != nil {
                                //there was an error authorizing
                                //print(error.description)
                                //print(error.code)
                                self.invalidCredentialsLabel.text = "invalid email or password"
                                self.invalidCredentialsLabel.hidden = false
                                self.shakeTextField()
                            }
            })

        }
        
        else {
            invalidCredentialsLabel.text = "please enter an email and password"
            invalidCredentialsLabel.hidden = false
        }
        
    }
    
    
    //MARK: - Observer Methods
    
    //method to make scroll view function when the keyboard appears
    func keyboardWillShow(notification: NSNotification) {
        //print("keyboard will show")
        
        //get the size of the keyboard and add it to the scroll view height so that the user can access all fields and buttons
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.CGRectValue() {
            //print("updating constraints")
            //add only half the keyboard height, otherwise scroll view can scroll farther than necessary
            scrollViewHeightConstraint.constant += keyboardSize.height/2
        }
 
        
    }
    
    func keyboardWillHide(notification : NSNotification) {
        //print("keyboard will hide")
        
        //keyboard hiding set scroll view back to regular height
        self.scrollViewHeightConstraint.constant = self.defaultScrollViewHeightConstraint
        
    }
    
    
    //MARK: - Text Field Delegate Methods
    
    func textFieldDidBeginEditing(textField: UITextField) {
        //clear the email field only the first time it is edited
        if textField.text == "email" {
            textField.text = ""
        }
        
        //check if the field being edited is the password
        if textField.restorationIdentifier == "passwordField" {
            textField.secureTextEntry = true
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
            
            //add activity indicator
            //call the server to check for log in credentials
            
            
        }
        
        
        //done clicked from email box, close the keyboard
        self.view.endEditing(true)
        return false

    }
    

    
    
   

}
