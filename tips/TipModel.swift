//
//  TipModel.swift
//  tips
//
//  Created by Benjamin Tsai on 4/6/15.
//  Copyright (c) 2015 Benjamin Tsai. All rights reserved.
//

import Foundation

class TipModel {
    private let TipPercentages = [0.18, 0.2, 0.22]
    
    private let DefaultTipPercentIndexKey = "default_tip_index"
    private let TipPercentIndexKey = "tip_index"
    private let BillKey = "bill"
    private let LastUpdateKey = "last_update"
    
    private struct Static {
        static let instance = TipModel()
    }
    
    class var instance: TipModel {
        return Static.instance
    }
    
    let defaults = NSUserDefaults.standardUserDefaults()
    var tipPercentIndex = 0
    var defaultTipPercentIndex = 0
    var billText = ""

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
    
    init() {
        load()
    }
    
    func load() {
        defaultTipPercentIndex = defaults.integerForKey(DefaultTipPercentIndexKey)
        tipPercentIndex = defaults.integerForKey(TipPercentIndexKey)
        billText = defaults.stringForKey(BillKey) ?? ""
    }
    
    func save() {
        defaults.setInteger(defaultTipPercentIndex, forKey: DefaultTipPercentIndexKey)
        defaults.setInteger(tipPercentIndex, forKey: TipPercentIndexKey)
        defaults.setObject(billText, forKey: BillKey)
        defaults.setDouble(NSDate().timeIntervalSince1970, forKey: LastUpdateKey)
        defaults.synchronize()
    }
    
    func checkTimeout() {
        let lastUpdate = defaults.doubleForKey(LastUpdateKey)

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