///
/// TopTraxxUITests.swift
/// TopTraxxUITests
///
/// Created by Yanick Lavoie on 2018-02-26.
/// Copyright © 2018 Radappz. All rights reserved.
///

import XCTest
@testable import TopTraxx

let kUseMockAuthForUnitTesting = "com.radappz.TopTraxx.UseMockAuth"

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
    
    func testLogoutButtonTouched() {
        app.launchArguments = [ kUseMockAuthForUnitTesting, "YES" ]
        app.launch()
        app.buttons["Login"].tap()
        app.buttons["Logout"].tap()
        
        let requireLabel = self.app.staticTexts["We require Spotify Premium."]
        let exists = NSPredicate(format: "exists == true")
        let promise = self.expectation(for: exists, evaluatedWith: requireLabel, handler: nil)
        
        wait(for: [promise], timeout: 2)
    }
    
    
    func testLogin() {
        let logoutBtn = self.app.buttons["Logout"]
        let exists = NSPredicate(format: "exists == true")
        let promise = self.expectation(for: exists, evaluatedWith: logoutBtn, handler: nil)

        app.launchArguments = [ kUseMockAuthForUnitTesting, "YES" ]
        app.launch()
        app.buttons["Login"].tap()
        
        wait(for: [promise], timeout: 2)
        
    }
}
