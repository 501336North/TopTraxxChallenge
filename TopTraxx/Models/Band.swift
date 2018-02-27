//
//  Band.swift
//  TopTraxx
//
//  Created by Yanick Lavoie on 2018-02-24.
//  Copyright © 2018 Radappz. All rights reserved.
//

import UIKit

class Band: NSObject {
    /// band name
    var name: String?
    /// artist URL on spotify.  Should start with "spotify:artist:"
    var spotifyURL: URL?
    /// Image name in XCAssets.  Use on the login ViewController
    var imageName: String?
}
 
