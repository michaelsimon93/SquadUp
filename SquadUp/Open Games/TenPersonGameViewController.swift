//
//  GameDetailViewController.swift
//  SquadUp
//
//  Created by Michael Oudenhoven on 3/15/16.
//  Copyright © 2016 CS 407. All rights reserved.
//

import UIKit

class TenPersonGameViewController: UIViewController {
    
    //outlet to customize the font to fit style of the app
    @IBOutlet weak var backButton: UIBarButtonItem!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        backButton.setTitleTextAttributes([ NSFontAttributeName: UIFont(name: "Futura", size: 15)!], forState: UIControlState.Normal)
        
        
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
    
    
    //MARK: - IBActions
    
    @IBAction func chairClicked(chair: UIButton) {
    
        let basketballImage = UIImageView(frame: CGRectMake(0, 0, chair.frame.width-15, chair.frame.width-15))
        basketballImage.image = UIImage(named: "basketball")
        basketballImage.center = CGPoint(x: chair.frame.width/2, y: chair.frame.height/2-25)
        
        let initialsLabel = UILabel(frame: basketballImage.frame)
        initialsLabel.text = "MO"
        initialsLabel.font = UIFont(name: "Futura", size: 18.0)
        initialsLabel.textColor = UIColor.whiteColor()
        initialsLabel.textAlignment = .Center
        initialsLabel.center = basketballImage.center
        
        
        //add the basketball to the chair
        chair.addSubview(basketballImage)
        //add the initials to the basketball
        chair.addSubview(initialsLabel)
        
    }
    
    

}
