//
//  ForgotPasswordViewController.swift
//  SquadUp
//
//  Created by Michael Oudenhoven on 4/19/16.
//  Copyright © 2016 CS 407. All rights reserved.
//

import UIKit
import Firebase

class ForgotPasswordViewController: UIViewController, UITextFieldDelegate {

    //MARK: - Properties
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var resetPasswordButton: UIButton!
    @IBOutlet weak var invalidEmailLabel: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var scrollViewHeightConstraint: NSLayoutConstraint!
    //the default the scroll view height is. Intialized upon view did load
    var defaultScrollViewHeightConstraint: CGFloat = 0.0
    
    //orange color for the views
    let orange = UIColor(red: 0.86, green: 0.49, blue: 0.19, alpha: 1.0)
    
    //Firebase
    //reference to firebase app
    let ref  = Firebase(url: "https://squadupcs407.firebaseio.com")
    
    
    
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
    
    //MARK: - Setup
    func configureFields() {
        //initially hide the invalid email label
        invalidEmailLabel.hidden = true
        
        //configure the custom text field and button borders
        emailTextField.layer.borderWidth = 2.0
        emailTextField.layer.borderColor = orange.CGColor
        emailTextField.layer.cornerRadius = 5.0
        
        resetPasswordButton.layer.borderWidth = 2.0
        resetPasswordButton.layer.borderColor = UIColor.whiteColor().CGColor
        resetPasswordButton.layer.cornerRadius = 5.0
        resetPasswordButton.backgroundColor = orange
    }



    //go back to home screen when back is clicked
    @IBAction func backClicked(sender: AnyObject) {
        self.navigationController?.popToRootViewControllerAnimated(true)
    }
    

    @IBAction func resetPasswordClicked(sender: AnyObject) {
        //check if the email is a 'wisc.edu' email
        if emailTextField.text?.rangeOfString("wisc.edu") != nil {
            
            //reset user account password so they have to verify their account
            self.ref.resetPasswordForUser(self.emailTextField.text, withCompletionBlock: { error in
                if error != nil {
                    // There was an error processing the request
                    //notify user there was an error
                    self.invalidEmailLabel.text = "An error occurred. Please try again."
                    self.invalidEmailLabel.hidden = false
                    
                    
                } else {
                    // Password reset sent successfully
                    //pop back to home
                    self.navigationController?.popToRootViewControllerAnimated(true)
                }
                
                
            })
            
        }
        //wisc email not entered
        else {
            invalidEmailLabel.text = "Please use a 'wisc.edu' email"
            invalidEmailLabel.hidden = false
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
            
            //add activity indicator
            //call the server to check for log in credentials
            
            
        }
        
        
        //done clicked from email box, close the keyboard
        self.view.endEditing(true)
        return false
        
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
