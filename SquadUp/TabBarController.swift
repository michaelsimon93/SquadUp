//
//  TabBarController.swift
//  SquadUp
//
//  Created by Michael Oudenhoven on 3/14/16.
//  Copyright © 2016 CS 407. All rights reserved.
//

import UIKit

class TabBarController: UITabBarController {

    //MARK: - Properties
    
    
    
    //orange color for the views
    let orange = UIColor(red: 0.86, green: 0.49, blue: 0.19, alpha: 1.0)
    
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        UITabBar.appearance().tintColor = orange
        UITabBar.appearance().barTintColor = UIColor.blackColor()

        
        //self.tabBar.layer.backgroundColor = UIColor.blackColor().CGColor

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
