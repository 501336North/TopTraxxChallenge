//
//  ServiceFactory.swift
//  TopTraxxChallenge
//
//  Created by Yanick Lavoie on 2018-02-24.
//  Copyright © 2018 Radappz. All rights reserved.
//

import Foundation

enum ServiceFactory {
    static func resolve<Service>(serviceType: Service.Type) -> Service? {
        return Bootstrapper.getContainer().resolve(serviceType)
    }
}
