//
//  AppStartupService.swift
//  TopTraxx
//
//  Created by Yanick Lavoie on 2018-02-24.
//  Copyright © 2018 Radappz. All rights reserved.
//

import UIKit
import Foundation
import Fabric
import Crashlytics

/// User Default First Launch key
let kFirstLaunchKeyKey = "kFirstLaunchKeyKey"

/// Service protocol definition
protocol AppStartupServiceProtocol {
    /// Function to be called to perform any application-specific logic on application launch
    ///
    /// - Parameter closure: Callback called when service logic has completed
    func start(_ closure: (() -> Void)?)
    
    /// Read-only property describing if a the application is launching for the first time
    var isFirstLaunch: Bool { get }
}

final class AppStartupService : AppStartupServiceProtocol {
    var isFirstLaunch: Bool {
        return UserDefaults.standard.object(forKey: kFirstLaunchKeyKey) == nil
    }
    
    func start(_ closure: (() -> Void)?) {
        if ProcessInfo.processInfo.environment["DISABLE_ANIMATIONS"] == "1" {
            UIView.setAnimationsEnabled(false)
        }
        
        UserDefaults.standard.set(kFirstLaunchKeyKey, forKey: kFirstLaunchKeyKey)
        Fabric.with([Crashlytics.self])
        
        if let authService = ServiceFactory.resolve(serviceType: SpotifyAuthProtocol.self) {
            authService.configure( {
                print("Spotify Auth Service Configured.")
            })
        }

        
        closure?()
    }
}

