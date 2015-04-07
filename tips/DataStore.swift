//
//  SettingsStore.swift
//  tips
//
//  Created by Benjamin Tsai on 4/6/15.
//  Copyright (c) 2015 Benjamin Tsai. All rights reserved.
//
import UIKit

class DataStore {
    
    private enum SettingsStoreKey: String {
        case DEFAULT_TIP = "default_tip"
    }
    
    class func getDefaultTip() -> Int {
        return getIntegerValue(.DEFAULT_TIP)
    }
    
    class func setDefaultTip(value: Int) {
        setIntegerValue(value, forKey: .DEFAULT_TIP)
    }
    
    private class func getIntegerValue(forKey: SettingsStoreKey) -> Int {
        var defaults = NSUserDefaults.standardUserDefaults()
        return defaults.integerForKey(forKey.rawValue)
    }
    
    private class func setIntegerValue(value: Int, forKey: SettingsStoreKey) {
        var defaults = NSUserDefaults.standardUserDefaults()
        defaults.setInteger(value, forKey: forKey.rawValue)
        defaults.synchronize()
    }
}