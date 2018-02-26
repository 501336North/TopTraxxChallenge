//
//  Band.swift
//  TopTraxxChallenge
//
//  Created by Yanick Lavoie on 2018-02-24.
//  Copyright © 2018 Radappz. All rights reserved.
//

import UIKit

class Band: NSObject {
    var name: String?       // band name
    var spotifyURL: URL?    // artist URL on spotify.  Should start with "spotify:artist:"
    var imageName: String?  // Image name in XCAssets.  Use on the login ViewController
}
