//
//  NetworkService.swift
//  TopTraxx
//
//  Created by Yanick Lavoie on 2018-02-26.
//  Copyright © 2018 Radappz. All rights reserved.
//

import Foundation
import Spotify

/// Notification name for Spotify session update
let kSpotifyTopTracksReceived = "kSpotifyTopTracksReceivedNotification"

/// Service protocol definition
protocol SpotifyNetworkingProtocol {
    /// Function to be called to perform any application-specific logic on application launch
    ///
    /// - Parameter closure: Callback called when service logic has completed
    func retrieveTopTracks(for band: Band, closure: (() -> Void)?)
}

final class NetworkService : SpotifyNetworkingProtocol {
    var useMockDataForUnitTesting: Bool = false
    
    /// Connect to the Spotify API and get Top Tracks data for what ever Band is passed for parameter
    func retrieveTopTracks(for band: Band, closure: (() -> Void)?) {
        if useMockDataForUnitTesting {
            let auth:SPTAuth = SPTAuth.defaultInstance()
            let artistURL = band.spotifyURL
            
            let topTracksRequest:URLRequest
            do {
                let accessToken = auth.session.accessToken
                topTracksRequest = try SPTArtist.createRequestForTopTracks(forArtist: artistURL, withAccessToken: accessToken, market:
                    "CA")
                SPTRequest.sharedHandler().perform(topTracksRequest, callback: { (error, response, data) in
                    //parse top tracks.
                    guard error == nil else {
                        return
                    }
                    // make sure we got data in the response
                    guard let responseData = data else {
                        print("Error: did not receive data")
                        return
                    }
                    
                    do {
                        if let tracksJSON = try JSONSerialization.jsonObject(with: responseData, options: []) as? [String:Any] {
                            if let topTracks: Array<Any> = tracksJSON["tracks"] as? Array<Any> {
                                NotificationCenter.default.post(name: NSNotification.Name(rawValue: kSpotifyTopTracksReceived), object: topTracks)
                            }
                        } else {
                            print("error!!!")
                            return
                        }
                    } catch {
                        return
                    }
                    
                })
                
            } catch _ {
            }
        } else {
            
            // get .json file from bundle
            let mockedTopTracks: Array<Any> = []
            
             NotificationCenter.default.post(name: NSNotification.Name(rawValue: kSpotifyTopTracksReceived), object: mockedTopTracks)
        }
        closure?()
    }
}



