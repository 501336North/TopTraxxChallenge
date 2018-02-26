//
//  TopTraxxChallengeTests.swift
//  TopTraxxChallengeTests
//
//  Created by Yanick Lavoie on 2018-02-19.
//  Copyright © 2018 Radappz. All rights reserved.
//

import XCTest

@testable import GreenCopperChallenge

class TopTraxxChallengeTests: XCTestCase {
    
    var loginUnderTest: LoginViewController?
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        loginUnderTest = LoginViewController()
        
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
        loginUnderTest = nil
    }

    //We use Spotify for Auth, to get Top Tracks list & to stream each of the tracks.  Make sure we have what we need to reach End Points if network is avail.
    func testIsSpotifyReachableThruWebAuth() {  // We do not actually check if we can reach the server as this is network dependant.
        let auth = loginUnderTest?.auth
        let web = auth?.spotifyWebAuthenticationURL
        
        XCTAssertNotNil(web, "No spotifyWebAuthenticationURL.  Won't reach Spotify for our mandatory Auth.")
    }

    func testIsSpotifyReachableThruAppAuth() {  // We do not actually check if we can reach the server as this is network dependant.
        let auth = loginUnderTest?.auth
        let app = auth?.spotifyAppAuthenticationURL

        XCTAssertNotNil(app, "No spotifyAppAuthenticationURL.  Won't reach Spotify for our mandatory Auth.")
    }

    func testIsSpotifyClientIDValid() {
        XCTAssertNotNil(kClientId, "Spotify API client ID is mandatory")
        XCTAssert(kClientId.count == 32, "Properly formatted Spotify API client ID is mandatory")
    }

    func testIsSpotifyCallbackURLValid() {
        XCTAssertNotNil(kCallbackURL, "Spotify Callback URL is mandatory")
        XCTAssert(kCallbackURL.contains("://") == true, "Properly formatted Spotify Callback URL is mandatory")
    }
    
    // XCTAssert to test model
    func testDoesBandHasSpotifyURL() {
        loginUnderTest?.fillBandsMockData()
        XCTAssert(loginUnderTest?.selectedBand.spotifyURL?.absoluteString.starts(with: "spotify:artist:") == true, "Wrong URL for band.  We won't reach the artist we need to on spotify with that.")
    }
    
}
