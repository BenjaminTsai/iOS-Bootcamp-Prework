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
    @IBOutlet weak var dataPanel: UIView!
    
    let model = TipModel.instance
    var wasEmpty = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NSNotificationCenter.defaultCenter().addObserver(self, selector:"syncFromModel", name: UIApplicationWillEnterForegroundNotification, object: nil)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)

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

