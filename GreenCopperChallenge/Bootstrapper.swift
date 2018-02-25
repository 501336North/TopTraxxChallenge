//
//  Bootstrapper.swift
//  TopTraxxChallenge
//
//  Created by Yanick Lavoie on 2018-02-24.
//  Copyright © 2018 Radappz. All rights reserved.
//

import Foundation
import Swinject

struct Bootstrapper {
    static let sharedInstance = Bootstrapper()
    private(set) var container: Container
    
    init() {
        
        container = Container()
        container.register(AppStartupServiceProtocol.self) { r in
            AppStartupService()
            } .inObjectScope(.container)
        container.register(SpotifyAuthProtocol.self) { r in
            AuthService()
            } .inObjectScope(.container)
        
    }
    
    static func getContainer() -> Container {
        return Bootstrapper.sharedInstance.container
    }
}

