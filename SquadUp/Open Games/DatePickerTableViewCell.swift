//
//  DatePickerTableViewCell.swift
//  SquadUp
//
//  Created by Michael Oudenhoven on 4/8/16.
//  Copyright © 2016 CS 407. All rights reserved.
//
//from tutorial: https://www.youtube.com/watch?v=VWgr_wNtGPM
//https://github.com/DylanVann/DatePickerCell

import UIKit

class DatePickerTableViewCell: UITableViewCell {
    
    var isObserving = false
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var datePicker: UIDatePicker!
    
    class var expandedHeight : CGFloat { get { return 200}}
    class var defaultHeight : CGFloat { get { return 44}}
    
    
    func checkHeight() {
        
        datePicker.hidden = (frame.size.height < DatePickerTableViewCell.expandedHeight)
    }
    
    func watchFrameChanges() {
        if !isObserving {
            addObserver(self, forKeyPath: "frame", options: .New, context: nil)
            isObserving = true
            checkHeight()
        }

    }
    
    func ignoreFrameChanges() {
        if isObserving {
            removeObserver(self, forKeyPath: "frame")
            isObserving = false
        }
        
    }
    
    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        if keyPath == "frame" {
            checkHeight()
        }
    }

}
