//
//  TipModel.swift
//  tips
//
//  Created by Benjamin Tsai on 4/6/15.
//  Copyright (c) 2015 Benjamin Tsai. All rights reserved.
//

import Foundation

// Singleton model containing both the short term state of the app (bill, current tip percentage)
// as well as the long term (default tip percentage).
class TipModel {
    private let TipPercentages = [0.18, 0.2, 0.22]
    
    // Keys for NSUserDefaults
    private let DefaultTipPercentIndexKey = "default_tip_index"
    private let TipPercentIndexKey = "tip_index"
    private let BillKey = "bill"
    private let LastUpdateKey = "last_update"
    
    // Singleton
    private struct Static {
        static let instance = TipModel()
    }
    
    class var instance: TipModel {
        return Static.instance
    }

    // Data store
    let defaults = NSUserDefaults.standardUserDefaults()
    
    // Settable variables
    var tipPercentIndex = 0
    var defaultTipPercentIndex = 0
    var billText = ""

    // Read only calculated properties
    var bill: Double {
        get {
            return (billText as NSString).doubleValue
        }
    }
    
    var tip: Double {
        get {
            return TipPercentages[tipPercentIndex] * bill
        }
    }
    
    var total: Double {
        get {
            return tip + bill
        }
    }
    
    // Initializer always calls load()
    init() {
        load()
    }
    
    // Tries to load current settings from NSUserDefaults, will provide default value
    // if data isn't set yet
    func load() {
        defaultTipPercentIndex = defaults.integerForKey(DefaultTipPercentIndexKey)
        tipPercentIndex = defaults.integerForKey(TipPercentIndexKey)
        billText = defaults.stringForKey(BillKey) ?? ""
    }
    
    // Persists current model into NSUserDefaults, updates last touched timestamp as well
    func save() {
        defaults.setInteger(defaultTipPercentIndex, forKey: DefaultTipPercentIndexKey)
        defaults.setInteger(tipPercentIndex, forKey: TipPercentIndexKey)
        defaults.setObject(billText, forKey: BillKey)
        defaults.setDouble(NSDate().timeIntervalSince1970, forKey: LastUpdateKey)
        defaults.synchronize()
    }
    
    // Checks if short term data should be cleared out. This should happen if last touched
    // timestamp is more than 5 seconds from now in the past.
    func checkTimeout() {
        let lastUpdate = defaults.doubleForKey(LastUpdateKey)

        // Time out after 5 seconds
        if NSDate().timeIntervalSince1970 - lastUpdate > 5 {
            // Timed out, clear out state
            tipPercentIndex = defaultTipPercentIndex
            billText = ""
            save()
        } else {
            // Just update timestamp
            defaults.setDouble(NSDate().timeIntervalSince1970, forKey: LastUpdateKey)
            defaults.synchronize()
        }
    }
}