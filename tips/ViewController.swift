//
//  ViewController.swift
//  tips
//
//  Created by Benjamin Tsai on 4/6/15.
//  Copyright (c) 2015 Benjamin Tsai. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var tipControl: UISegmentedControl!
    @IBOutlet weak var billField: UITextField!
    @IBOutlet weak var tipLabel: UILabel!
    @IBOutlet weak var totalLabel: UILabel!
    
    // Panel containing all fields and elements that should disappear when bill field is empty
    @IBOutlet weak var dataPanel: UIView!
    
    let model = TipModel.instance
    
    // Boolean to determine if billField was / am empty, used to track transition from empty to non-empty state
    var wasEmpty = true

    // Cleanup
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // viewDidLoad isn't called when we just return from background, so need to register observer to trigger
        // resync of view from model when we resume. Needed to support clearing out of fields upon resuming after
        // timeout (should be 5 minutes but we set it to 5 seconds for easier testing)
        NSNotificationCenter.defaultCenter().addObserver(self, selector:"syncFromModel", name: UIApplicationWillEnterForegroundNotification, object: nil)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)

        // Hide the data panel at the beginning if bill field was empty
        if model.billText == "" {
            dataPanel.alpha = 0
        }
        
        // Set focus on bill field, brings up numeric keypad also
        billField.becomeFirstResponder()
        syncFromModel()
    }

    @IBAction func onEditingChanged(sender: AnyObject) {
        model.tipPercentIndex = tipControl.selectedSegmentIndex
        model.billText = billField.text

        model.save()
        syncFromModel()
    }

    @IBAction func onTap(sender: AnyObject) {
        // Hides keyboard
        view.endEditing(true)
    }
    
    func syncFromModel() {
        let formatter = NSNumberFormatter()
        formatter.numberStyle = NSNumberFormatterStyle.CurrencyStyle
        
        billField.text = model.billText
        tipLabel.text = formatter.stringFromNumber(model.tip)
        totalLabel.text = formatter.stringFromNumber(model.total)
        tipControl.selectedSegmentIndex = model.tipPercentIndex
        
        if model.billText == "" {
            wasEmpty = true
            UIView.animateWithDuration(1, animations: {
                self.dataPanel.alpha = 0
            })
        } else if wasEmpty {
            wasEmpty = false
            UIView.animateWithDuration(0.5, animations: {
                self.dataPanel.alpha = 1
            })
        }
    }
}

