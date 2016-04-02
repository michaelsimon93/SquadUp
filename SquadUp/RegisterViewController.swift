//
//  RegisterViewController.swift
//  SquadUp
//
//  Created by Michael Oudenhoven on 3/5/16.
//  Copyright © 2016 CS 407. All rights reserved.
//

import UIKit

class RegisterViewController: UIViewController {

    //MARK: - Properties
    
    @IBOutlet weak var backgroundImage: UIImageView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var basketballImage: UIImageView!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmPassTextField: UITextField!
    @IBOutlet weak var signUpButton: UIButton!
    //label to display if passwords do not match
    @IBOutlet weak var passwordMatchLabel: UILabel!
    
    //orange color for the views
    let orange = UIColor(red: 0.86, green: 0.49, blue: 0.19, alpha: 1.0)
    
    //scroll view setup to move when fields are being typed in
    @IBOutlet weak var scrollViewHeightConstraint : NSLayoutConstraint!
    //the default the scroll view height is. Intialized upon view did load
    var defaultScrollViewHeightConstraint: CGFloat = 0.0
    
    
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
    
    
    
    //MARK: - Initialization
    
    func configureFields() {
        //initially hide the passwords do not match label
        passwordMatchLabel.hidden = true
        
        //configure the custom text field and button borders
        emailTextField.layer.borderWidth = 2.0
        emailTextField.layer.borderColor = orange.CGColor
        emailTextField.layer.cornerRadius = 5.0
        
        passwordTextField.layer.borderWidth = 2.0
        passwordTextField.layer.borderColor = orange.CGColor
        passwordTextField.layer.cornerRadius = 5.0
        
        confirmPassTextField.layer.borderWidth = 2.0
        confirmPassTextField.layer.borderColor = orange.CGColor
        confirmPassTextField.layer.cornerRadius = 5.0
        
        signUpButton.layer.borderWidth = 2.0
        signUpButton.layer.borderColor = UIColor.whiteColor().CGColor
        signUpButton.layer.cornerRadius = 5.0
        signUpButton.backgroundColor = orange
    }
    
    func configureImages() {
        backgroundImage.backgroundColor = UIColor.grayColor()
        basketballImage.backgroundColor = UIColor.blackColor()
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
        //testing animation, but if the fields are not equal shake fields
        shakePasswordFields()
        self.performSegueWithIdentifier("toConfirmationViewController", sender: nil)
        
        /*
        if passwordTextField.text != confirmPassTextField.text {
            shakePasswordFields()
            passwordMatchLabel.hidden = false
        }
            
        //validate user account and send information to server
        else {

            
            
        }
        */
    }
    
    
    
    //MARK: - Animations
    
    //method called when the user doesn't type in matching passwords. Shakes the password fields
    func shakePasswordFields() {
        let animation = CABasicAnimation()
        animation.duration = 0.05
        animation.repeatCount = 2
        animation.autoreverses = true
        animation.fromValue = NSValue(CGPoint: CGPointMake(passwordTextField.center.x-10, passwordTextField.center.y))
        animation.toValue = NSValue(CGPoint: CGPointMake(passwordTextField.center.x+10, passwordTextField.center.y))
 
        let animation2 = animation.copy() as! CABasicAnimation
        animation2.fromValue = NSValue(CGPoint: CGPointMake(passwordTextField.center.x-10, confirmPassTextField.center.y))
        animation2.toValue = NSValue(CGPoint: CGPointMake(passwordTextField.center.x+10, confirmPassTextField.center.y))
        
        //add animation to fields. will be the same animation b/c only x-values are changed
        passwordTextField.layer.addAnimation(animation, forKey: "position")
        confirmPassTextField.layer.addAnimation(animation2, forKey: "position")
 
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

}
