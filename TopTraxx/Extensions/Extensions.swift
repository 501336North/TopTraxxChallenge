//
//  Extensions.swift
//  TopTraxx
//
//  Created by Yanick Lavoie on 2018-02-19.
//  Copyright © 2018 Radappz. All rights reserved.
//

import UIKit

/// App Specific Fonts
extension UIFont {
    static let topTraxxFontSemiBold22 = UIFont.systemFont(ofSize: 22.0, weight: UIFont.Weight.semibold)
    static let topTraxxFontSemiBold17 = UIFont.systemFont(ofSize: 17.0, weight: UIFont.Weight.semibold)
    static let topTraxxFontMedium17 = UIFont.systemFont(ofSize: 17.0, weight: UIFont.Weight.medium)
    static let topTraxxFontRegular22 = UIFont.systemFont(ofSize: 22.0, weight: UIFont.Weight.regular)
    static let topTraxxFontRegular17 = UIFont.systemFont(ofSize: 17.0, weight: UIFont.Weight.regular)
    static let topTraxxFontBold15 = UIFont.systemFont(ofSize: 15.0, weight: UIFont.Weight.bold)
    static let topTraxxFontBold16 = UIFont.systemFont(ofSize: 16.0, weight: UIFont.Weight.bold)
    static let topTraxxFontRegular15 = UIFont.systemFont(ofSize: 15.0, weight: UIFont.Weight.regular)
    static let topTraxxFontRegular13 = UIFont.systemFont(ofSize: 13.0, weight: UIFont.Weight.regular)
    static let topTraxxFontRegular11 = UIFont.systemFont(ofSize: 11.0, weight: UIFont.Weight.regular)
}

/// App Specific Colors
extension UIColor {
    static let topTraxxAccent = UIColor.cyan
    static let topTraxxAccentDark = UIColor.cyan.darker(by: 40)
    static let topTraxxBlack = UIColor(white: 14.0 / 255.0, alpha: 1.0)
    static let topTraxxBlack45 = UIColor(white: 14.0 / 255.0, alpha: 0.45)
    static let topTraxxBlack85 = UIColor(white: 14.0 / 255.0, alpha: 0.85)
    static let topTraxxDarkGray = UIColor(white: 32.0 / 255.0, alpha: 1.0)
    static let topTraxxWhite = UIColor(white: 255.0 / 255.0, alpha: 1.0)
    
    /// function to make a simple UIImage computed and generated from the parameter received.
    /// - Parameter color UIColor, the color of the resulting UIImage we want to get
    class func imageWithColor(color:UIColor) -> UIImage? {
        
        let rect:CGRect = CGRect(x:0, y:0, width:1, height:1)
        UIGraphicsBeginImageContext(rect.size)
        guard let context:CGContext = UIGraphicsGetCurrentContext() else { return nil }
        
        context.setFillColor(color.cgColor)
        context.fill(rect)
        
        guard let image:UIImage = UIGraphicsGetImageFromCurrentImageContext() else { return nil }
        UIGraphicsEndImageContext()
        
        return image
    }
    
    /// function to make color lighter than the original color we are applying the function to
    /// - Parameter percentage of how lighter we want our resulting color to be.
    func lighter(by percentage:CGFloat=30.0) -> UIColor? {
        return adjust(by: abs(percentage) )
    }

    /// function to make color darker than the original color we are applying the function to
    /// - Parameter percentage of how darker we want our resulting color to be.
    func darker(by percentage:CGFloat=30.0) -> UIColor? {
        return adjust(by: -1 * abs(percentage) )
    }
    
    /// function used to alter color
    /// - Parameter percentage change on the initial color
    func adjust(by percentage:CGFloat=30.0) -> UIColor? {
        var r:CGFloat=0, g:CGFloat=0, b:CGFloat=0, a:CGFloat=0;
        if(getRed(&r, green: &g, blue: &b, alpha: &a)){
            return UIColor(red: min(r + percentage/100, 1.0),
                           green: min(g + percentage/100, 1.0),
                           blue: min(b + percentage/100, 1.0),
                           alpha: a)
        }else{
            return nil
        }
    }
}

