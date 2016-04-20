//
//  ChangePasswordViewController.swift
//  SquadUp
//
//  Created by Michael Oudenhoven on 4/19/16.
//  Copyright © 2016 CS 407. All rights reserved.
//

import UIKit

class ChangePasswordViewController: UIViewController, UITextFieldDelegate {

    //MARK: - Properties
    
    @IBOutlet weak var oldPasswordField: UITextField!
    @IBOutlet weak var newPasswordField: UITextField!
    @IBOutlet weak var confirmPasswordField: UITextField!
    @IBOutlet weak var changePasswordButton: UIButton!
    @IBOutlet weak var passwordMatchLabel: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var scrollViewHeightConstraint: NSLayoutConstraint!
    //the default the scroll view height is. Intialized upon view did load
    var defaultScrollViewHeightConstraint: CGFloat = 0.0
    
    //orange color for the views
    let orange = UIColor(red: 0.86, green: 0.49, blue: 0.19, alpha: 1.0)
    
    
    //MARK: - Lifecycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        //customize the fields and buttons
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
    
    override func viewDidDisappear(animated: Bool) {
        
        //remove observers when view is destroyed
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - Setupd
    func configureFields() {
        //initially hide the not matching passwords label
        passwordMatchLabel.hidden = false
        
        //configure the custom text field and button borders
        newPasswordField.layer.borderWidth = 2.0
        newPasswordField.layer.borderColor = orange.CGColor
        newPasswordField.layer.cornerRadius = 5.0
        
        oldPasswordField.layer.borderWidth = 2.0
        oldPasswordField.layer.borderColor = orange.CGColor
        oldPasswordField.layer.cornerRadius = 5.0
        
        confirmPasswordField.layer.borderWidth = 2.0
        confirmPasswordField.layer.borderColor = orange.CGColor
        confirmPasswordField.layer.cornerRadius = 5.0
        
        changePasswordButton.layer.borderWidth = 2.0
        changePasswordButton.layer.borderColor = UIColor.whiteColor().CGColor
        changePasswordButton.layer.cornerRadius = 5.0
        changePasswordButton.backgroundColor = orange
    }
    
    
    //MARK: - IBActions
    
    @IBAction func changePasswordClicked(sender: AnyObject) {
        
        //verify that passwords match
        if newPasswordField.text == confirmPasswordField.text {
            //try to change the password in firebase, if get error check if they entered the temp password wrong
            
            //if temp password is wrong, change label
            //passwordMatchLabel.text = "old password incorrect"
            //passwordMatchLabel.hidden = false
            
            //if goes through all good, perform segue to home view 
            //self.performSegueWithIdentifier("toHomeViewController", sender: nil)
            
        }
        //nonmatching passwords given
        else {
            //show label
            passwordMatchLabel.text = "new passwords does not match"
            passwordMatchLabel.hidden = false
            //shake text fields and clear them
            shakeFields()
        }
        
        
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
    
    
    //MARK: - Text Field Delegate Methods
    
    func textFieldDidBeginEditing(textField: UITextField) {
        
        //check if the field being edited is the password
        if textField.restorationIdentifier == "oldPassword" {
            textField.secureTextEntry = true
        }
        else if textField.restorationIdentifier == "newPassword" {
            textField.secureTextEntry = true
        }
        else if textField.restorationIdentifier == "confirmPassword" {
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
    
    
    //MARK: - Animations
    
    //method called when the user doesn't type in matching passwords. Shakes the password fields
    func shakeFields() {
        let animation = CABasicAnimation()
        animation.duration = 0.05
        animation.repeatCount = 2
        animation.autoreverses = true
        animation.fromValue = NSValue(CGPoint: CGPointMake(newPasswordField.center.x-10, newPasswordField.center.y))
        animation.toValue = NSValue(CGPoint: CGPointMake(newPasswordField.center.x+10, newPasswordField.center.y))
        
        let animation2 = CABasicAnimation()
        animation2.duration = 0.05
        animation2.repeatCount = 2
        animation2.autoreverses = true
        animation2.fromValue = NSValue(CGPoint: CGPointMake(confirmPasswordField.center.x-10, confirmPasswordField.center.y))
        animation2.toValue = NSValue(CGPoint: CGPointMake(confirmPasswordField.center.x+10, confirmPasswordField.center.y))
        
        //add animation to fields. will be the same animation b/c only x-values are changed
        newPasswordField.layer.addAnimation(animation, forKey: "position")
        confirmPasswordField.layer.addAnimation(animation2, forKey: "position")
        
        //clear the fields for the user to enter in again
        newPasswordField.text = ""
        confirmPasswordField.text = ""
        
    }
    
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}