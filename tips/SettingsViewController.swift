//
//  SettingsViewController.swift
//  tips
//
//  Created by Benjamin Tsai on 4/6/15.
//  Copyright (c) 2015 Benjamin Tsai. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {
    
    @IBOutlet weak var tipSegment: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tipSegment.selectedSegmentIndex = DataStore.getDefaultTip()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func onEditingChanged(sender: AnyObject) {
        DataStore.setDefaultTip(tipSegment.selectedSegmentIndex)
    }
    
    @IBAction func onDone(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion:nil)
    }
}