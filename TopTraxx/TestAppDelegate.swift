//
//  TestAppDelegate.swift
//  TopTraxx
//
//  Created by Yanick Lavoie on 2018-02-27.
//  Copyright © 2018 Radappz. All rights reserved.
//


import UIKit
import Spotify

protocol TestAppDelegateProtocol {
    var useMockForUnitTesting: Bool { get set }
}

class TestAppDelegate: UIResponder, UIApplicationDelegate, TestAppDelegateProtocol {
    
    var window: UIWindow?
    var isUserInAuthFlow: Bool = false
    var useMockForUnitTesting: Bool = true
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        window = UIWindow(frame: UIScreen.main.bounds)
        
        if let appStartService = ServiceFactory.resolve(serviceType: AppStartupServiceProtocol.self) {
            appStartService.start {
                let loginViewController = LoginViewController()
                if let window = self.window {
                    window.rootViewController = loginViewController
                    window.makeKeyAndVisible()
                }
                self.configAppearance()
            }
        }
        
        return true
    }
    
    
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any)
        -> Bool {
            
            if SPTAuth.defaultInstance().canHandle(url) {
                isUserInAuthFlow = true
                SPTAuth.defaultInstance().handleAuthCallback(withTriggeredAuthURL: url, callback: { (error, session) in
                    
                    if error != nil {
                        print("Authorization Error: \(String(describing: error?.localizedDescription))")
                        return
                    }
                    
                    self.isUserInAuthFlow = false
                    SPTAuth.defaultInstance().session = session
                    // Store our session away for future usage
                    let sessionData = NSKeyedArchiver.archivedData(withRootObject: SPTAuth.defaultInstance().session)
                    UserDefaults.standard.set(sessionData, forKey: kSessionObjectDefaultsKey)
                    // Notifiy our main interface
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: kSessionWasUpdated), object: session)
                    
                })
                return true
            }
            return false
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    /// Setup default UINavigation Appearance.
    func configAppearance() {
        UINavigationBar.appearance().tintColor = UIColor.topTraxxAccentDark
        UINavigationBar.appearance().barTintColor = UIColor.topTraxxDarkGray
        UINavigationBar.appearance().clipsToBounds = false
        UINavigationBar.appearance().isTranslucent = true
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedStringKey.font: UIFont.topTraxxFontRegular17, NSAttributedStringKey.foregroundColor: UIColor.topTraxxAccentDark as Any]
        
    }
    
}


