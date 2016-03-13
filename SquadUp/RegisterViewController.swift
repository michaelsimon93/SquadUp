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
    
    //orange color for the views
    let orange = UIColor(red: 0.86, green: 0.49, blue: 0.19, alpha: 1.0)
    
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        //configure the background view (based on device and the basketball (if necessary)
        configureImages()
        
        //configure the custom text field and button borders
        configureFields()
        
        
    }
    
    override func viewWillAppear(animated: Bool) {
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    //MARK: - Initialization
    
    func configureFields() {
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

}
