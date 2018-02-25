//
//  Extensions.swift
//  TopTraxxChallenge
//
//  Created by Yanick Lavoie on 2018-02-19.
//  Copyright © 2018 Radappz. All rights reserved.
//

import UIKit

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

extension UIColor {
    static let topTraxxAccent = UIColor.cyan
    static let topTraxxAccentDark = UIColor.cyan.darker(by: 40)
    static let topTraxxBlack = UIColor(white: 14.0 / 255.0, alpha: 1.0)
    static let topTraxxBlack45 = UIColor(white: 14.0 / 255.0, alpha: 0.45)
    static let topTraxxBlack85 = UIColor(white: 14.0 / 255.0, alpha: 0.85)
    static let topTraxxDarkGray = UIColor(white: 32.0 / 255.0, alpha: 1.0)
    static let topTraxxWhite = UIColor(white: 255.0 / 255.0, alpha: 1.0)
    
    
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
    
    func lighter(by percentage:CGFloat=30.0) -> UIColor? {
        return adjust(by: abs(percentage) )
    }
    
    func darker(by percentage:CGFloat=30.0) -> UIColor? {
        return adjust(by: -1 * abs(percentage) )
    }
    
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

