//
//  ConfirmationViewController.swift
//  SquadUp
//
//  Created by Michael Oudenhoven on 3/31/16.
//  Copyright © 2016 CS 407. All rights reserved.
//

import UIKit

class ConfirmationViewController: UIViewController {

    @IBOutlet weak var okayButton: UIButton!
    
    
    //orange color for the views
    let orange = UIColor(red: 0.86, green: 0.49, blue: 0.19, alpha: 1.0)
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        //configure okay button with custom border
        okayButton.layer.borderWidth = 2.5
        okayButton.layer.borderColor = UIColor.whiteColor().CGColor
        okayButton.layer.cornerRadius = 5.0
        okayButton.backgroundColor = orange
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func okayClicked(sender: AnyObject) {
        //pop back to the log in screen
        self.navigationController?.popToRootViewControllerAnimated(true)
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
