//
//  Util.swift
//  Rotten Tomatoes
//
//  Created by Do Ngoc Tan on 8/29/15.
//  Copyright (c) 2015 Do Ngoc Tan. All rights reserved.
//

import UIKit
import Foundation

class Util: NSObject {
    
   class func UIColorFromHex(rgbValue:UInt32, alpha:Double=1.0)->UIColor {
        let red = CGFloat((rgbValue & 0xFF0000) >> 16)/256.0
        let green = CGFloat((rgbValue & 0xFF00) >> 8)/256.0
        let blue = CGFloat(rgbValue & 0xFF)/256.0
        
        return UIColor(red:red, green:green, blue:blue, alpha:CGFloat(alpha))
    }
    
    class func getHDThumbNail(_strThumbnail: String) -> NSURL? {
        var strThumbnail = _strThumbnail
        var range = strThumbnail.rangeOfString(".*cloudfront.net/", options: .RegularExpressionSearch)
        if let range = range {
            strThumbnail = strThumbnail.stringByReplacingCharactersInRange(range, withString: "https://content6.flixster.com/")
        }
                
        var thumbnailUrl = NSURL(string: strThumbnail)!
        return thumbnailUrl
        
    }
    
    // rbgValue - define hex color value
    // alpha - define transparency value
    // returns - CGColor
}
