//
//  EightPersonGameViewController.swift
//  SquadUp
//
//  Created by Michael Oudenhoven on 4/12/16.
//  Copyright © 2016 CS 407. All rights reserved.
//

import UIKit

class EightPersonGameViewController: UIViewController {

    //outlet to customize the font to fit style of the app
    @IBOutlet weak var backButton: UIBarButtonItem!
    
    @IBOutlet weak var chair1Button: UIButton!
    @IBOutlet weak var chair2Button: UIButton!
    @IBOutlet weak var chair3Button: UIButton!
    @IBOutlet weak var chair4Button: UIButton!
    @IBOutlet weak var chair5Button: UIButton!
    @IBOutlet weak var chair6Button: UIButton!
    @IBOutlet weak var chair7Button: UIButton!
    @IBOutlet weak var chair8Button: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        backButton.setTitleTextAttributes([ NSFontAttributeName: UIFont(name: "Futura", size: 15)!], forState: UIControlState.Normal)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        
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
