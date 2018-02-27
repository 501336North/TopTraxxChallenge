///
/// TopTraxxUITests.swift
/// TopTraxxUITests
///
/// Created by Yanick Lavoie on 2018-02-26.
/// Copyright © 2018 Radappz. All rights reserved.
///

import XCTest

class TopTraxxUITests: XCTestCase {
    var app: XCUIApplication!
    
    /// MARK: - XCTestCase
    
    override func setUp() {
        super.setUp()
        
        // Since UI tests are more expensive to run, it's usually a good idea
        // to exit if a failure was encountered
        continueAfterFailure = false
        
        app = XCUIApplication()
        
        // We send a command line argument to our app,
        // to enable it to reset its state
        app.launchArguments.append("--uitesting")
    }
    
    /// MARK: - Tests
    
    func testLoginButtonTouched() {
        app.launch()
        app.buttons["Login"].tap()
        
        
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(2), execute: {
            // Login ViewController should no longer be displaying, login should either bring the webView to login or pop the Spotify app to authorize
            XCTAssert(self.app.state != XCUIApplication.State.runningForeground , "UI TEST FAILED! testLoginButtonTouched")

        })
    }
    
}
