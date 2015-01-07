//
//  UIColor+ColorFromCode.swift
//  Search Mechanism
//
//  Created by E. Mozharovsky on 11/8/14.
//  Copyright (c) 2014 GameApp. All rights reserved.
//

import UIKit

extension UIColor {
    class func colorFromCode(code: Int) -> UIColor {
        let red = CGFloat((code & 0xFF0000) >> 16) / 255.0 as CGFloat
        let green = CGFloat((code & 0xFF00) >> 8) / 255.0 as CGFloat
        let blue = CGFloat(code & 0xFF) / 255.0 as CGFloat
        
        return UIColor(red: red, green: green, blue: blue, alpha: 1.0)
    }
}