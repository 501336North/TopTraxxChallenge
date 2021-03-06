//
//  AuthService.swift
//  TopTraxx
//
//  Created by Yanick Lavoie on 2018-02-25.
//  Copyright © 2018 Radappz. All rights reserved.
//

import Foundation
import Spotify

/// Spotify SDK client ID
let kClientId = "80acd1fa352c42b2b7258bf607144dad"
/// URLScheme for callback
let kCallbackURL = "toptraxx://returnafterlogin"

/// Notification name for Spotify session update
let kSessionWasUpdated = "kSessionWasUpdatedNotification"
/// User Default session key
let kSessionObjectDefaultsKey = "kSessionObjectDefaultsKey"

/// Service protocol definition
protocol SpotifyAuthProtocol {
    /// Function to be called to perform any application-specific logic on application launch
    ///
    /// - Parameter closure: Callback called when service logic has completed
    func configure(_ closure: (() -> Void)?)
    func authenticate(closure: ((Bool) -> Void)?)
    
}

final class AuthService : SpotifyAuthProtocol {
    
    func configure(_ closure: (() -> Void)?) {
        // Set up shared authentication information
        let auth:SPTAuth = SPTAuth.defaultInstance()
        auth.clientID = kClientId
        auth.requestedScopes = [SPTAuthStreamingScope]
        auth.redirectURL = URL(string: kCallbackURL)
        auth.sessionUserDefaultsKey = kSessionObjectDefaultsKey

        closure?()
    }
    
    func authenticate(closure: ((Bool) -> Void)?) {
        guard let application: TestAppDelegateProtocol = UIApplication.shared.delegate as? TestAppDelegateProtocol else { return }
       
        if application.useMockForUnitTesting == true {
            closure?(true)
        } else {
            if let session = SPTAuth.defaultInstance().session {
                closure?(session.isValid())
            } else {
                closure?(false)
            }
        }
    }
}


