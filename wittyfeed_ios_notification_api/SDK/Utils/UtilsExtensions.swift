//
//  UtilsExtensions.swift
//  wittyfeed_ios_notification_api
//
//  Created by Aishwary Dhare on 02/02/18.
//  Copyright © 2018 wittyfeed. All rights reserved.
//

import Foundation
import UIKit
import SystemConfiguration

extension UIColor {
    class func wfhexColor(hex: String, alpha: CGFloat)-> UIColor {
        var cString = hex.trimmingCharacters(in: NSCharacterSet.whitespacesAndNewlines).uppercased()
        
        if (cString.hasPrefix("#")) {
            cString = cString.substring(from: cString.index(cString.startIndex, offsetBy: 1))
        }
        
        if (cString.characters.count != 6) {
            return UIColor.gray
        }
        
        var rgbValue:UInt32 = 0
        
        Scanner(string: cString).scanHexInt32(&rgbValue)
        
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(alpha)
        )
    }
}
