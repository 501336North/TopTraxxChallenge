//
//  main.swift
//  TopTraxx
//
//  Created by Yanick Lavoie on 2018-02-27.
//  Copyright © 2018 Radappz. All rights reserved.
//

import UIKit

let kUseMockAuthForUnitTesting = "com.radappz.TopTraxx.UseMockAuth"

if CommandLine.arguments.count > 1 {
    if (CommandLine.arguments[1] == kUseMockAuthForUnitTesting) {
        UIApplicationMain(CommandLine.argc,
                          UnsafeMutableRawPointer(CommandLine.unsafeArgv)
                            .bindMemory(
                                to: UnsafeMutablePointer<Int8>.self,
                                capacity: Int(CommandLine.argc)),
                          nil,
                          NSStringFromClass(TestAppDelegate.self) )
        
    } else {
        UIApplicationMain(CommandLine.argc,
                          UnsafeMutableRawPointer(CommandLine.unsafeArgv)
                            .bindMemory(
                                to: UnsafeMutablePointer<Int8>.self,
                                capacity: Int(CommandLine.argc)),
                          nil,
                          NSStringFromClass(AppDelegate.self) )
    }
} else {
    UIApplicationMain(CommandLine.argc,
                      UnsafeMutableRawPointer(CommandLine.unsafeArgv)
                        .bindMemory(
                            to: UnsafeMutablePointer<Int8>.self,
                            capacity: Int(CommandLine.argc)),
                      nil,
                      NSStringFromClass(AppDelegate.self) )
}

