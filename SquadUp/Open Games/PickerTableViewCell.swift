//
//  PickerTableViewCell.swift
//  SquadUp
//
//  Created by Michael Oudenhoven on 4/8/16.
//  Copyright © 2016 CS 407. All rights reserved.
//

import UIKit

class PickerTableViewCell: UITableViewCell, UIPickerViewDelegate, UIPickerViewDataSource {

    var isObserving = false
    
    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var leftLabel: UILabel!
    @IBOutlet weak var rightLabel: UILabel!
    
    //the row selected by the UIPickerView
    var selectedRow = 0
    //array of the items to pick from
    var pickerItems = []
    
    class var expandedHeight : CGFloat { get { return 200}}
    class var defaultHeight : CGFloat { get { return 44}}
    
    
    func checkHeight() {
        
        pickerView.hidden = (frame.size.height < PickerTableViewCell.expandedHeight)
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
    
    
    //MARK: - Picker View Data Source
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerItems.count
    }
    
    
    //MARK: - Picker View Delegate
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerItems[row] as? String
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedRow = row
        rightLabel.text = pickerItems[row] as? String
    }
    

}
