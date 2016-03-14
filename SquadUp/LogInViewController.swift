//
//  LogInViewController.swift
//  SquadUp
//
//  Created by Michael Oudenhoven on 3/5/16.
//  Copyright © 2016 CS 407. All rights reserved.
//

import UIKit

class LogInViewController: UIViewController {

    //MARK: - Properties
    
    @IBOutlet weak var backgroundImage: UIImageView!
    @IBOutlet weak var basketballImage: UIImageView!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var logInButton: UIButton!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var invalidCredentialsLabel: UILabel!
    
    
    var defaultScrollViewHeight: CGFloat = 0.0

    //orange color for the views
    let orange = UIColor(red: 0.86, green: 0.49, blue: 0.19, alpha: 1.0)
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        //configure the custom text field, button borders, and image views
        configureFields()
        configureImages()
        
    }
    
    
    override func viewWillAppear(animated: Bool) {
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
        backgroundImage.backgroundColor = UIColor.grayColor()
        basketballImage.backgroundColor = UIColor.blackColor()
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        //going to the main screen
        if segue.identifier == "toHomeViewController" {
            //pass player object/information to main view controller so that it can display the correct info
            
        }
        
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
    }
    
    
    //MARK: - IBActions
    
    @IBAction func logInClicked(sender: AnyObject) {
        //print("log in clicked")
        
        //shake test - for incorrect user information
        //shakeTextField()
        
        //add an activity indicator view while it fetches verification
        //let indicator = UIActivityIndicatorView(activityIndicatorStyle: .WhiteLarge)
        //indicator.startAnimating()
        
        
        
        //verify user account information
        //if correct, proceed segue to home view controller
        //if incorrect, shake text field, and display invalid credentials label
        
        
        //send player object with segue
        self.performSegueWithIdentifier("toHomeViewController", sender: nil)
        
    }

}
