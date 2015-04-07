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
    
    let model = TipModel.instance
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tipSegment.selectedSegmentIndex = model.defaultTipPercentIndex
    }
    
    @IBAction func onEditingChanged(sender: AnyObject) {
        model.defaultTipPercentIndex = tipSegment.selectedSegmentIndex

        // We only set the current selected tip percent if we actually
        // did make some config changes. Doesn't make sense to propagate
        // default value back to current selected just for looking at
        // settings page.
        model.tipPercentIndex = tipSegment.selectedSegmentIndex
        
        model.save()
    }
    
    @IBAction func onDone(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion:nil)
    }
}