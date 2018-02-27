//
//  LoginViewController.swift
//  TopTraxx
//
//  Created by Yanick Lavoie on 2018-02-19.
//  Copyright © 2018 Radappz. All rights reserved.
//

import Foundation
import SystemConfiguration
import UIKit
import Spotify
import SnapKit

class LoginViewController: UIViewController {
    var auth: SPTAuth = SPTAuth.defaultInstance()
    var isWebAuth: Bool = false
    var bands: Array<Band> = []
    
    lazy var bandLogoImageView: UIImageView = {
        let imageView = UIImageView()
        if let bandLogo = selectedBand.imageName {
            imageView.image = UIImage(named: bandLogo)
        }
        return imageView
    }()
    
    lazy var selectedBand: Band = {
        let band = Band()
        return band
    }()
    
    private lazy var webView: WebAuthViewController = {
        let viewController = WebAuthViewController(with: auth.spotifyWebAuthenticationURL())
        return viewController
    }()
    
    private lazy var authViewController: UIViewController = {
        let viewController: UIViewController
        viewController = UINavigationController(rootViewController: webView)
        viewController.modalPresentationStyle = UIModalPresentationStyle.formSheet
        
        return viewController
    }()
    
    private lazy var requirementsLabel: UILabel = {
        let label = UILabel()
        
        label.font = UIFont.topTraxxFontRegular17
        label.numberOfLines = 0
        label.textAlignment = .center
        label.textColor = UIColor.topTraxxWhite
        label.text = "We require Spotify Premium."
        return label
    }()

    /// Hint button is used to show an alertView to users that don't have a Spotify account.
    private lazy var hintButton: UIButton = {
        let button = UIButton(type: UIButtonType.custom)
        button.addTarget(self, action: #selector(hintButtonTouched), for: .touchUpInside)
        button.setTitle("I don't have it", for: .normal)
        button.titleLabel?.font =  UIFont.topTraxxFontRegular13
        button.setTitleColor(UIColor.topTraxxAccentDark, for: .normal)
        button.backgroundColor = UIColor.clear
        
        return button
    }()
    
    private lazy var loginButton: UIButton = {
        let button = UIButton(type: UIButtonType.custom)
        button.layer.cornerRadius = 30
        button.clipsToBounds = true
        button.addTarget(self, action: #selector(loginButtonTouched), for: .touchUpInside)
        button.setTitle("Login", for: .normal)
        button.setTitleColor(UIColor.topTraxxBlack, for: .normal)
        button.backgroundColor = UIColor.topTraxxAccent
        
        return button
    }()
    
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        
        bandLogoImageView.snp.remakeConstraints { (make) in
            if UIApplication.shared.statusBarOrientation == UIInterfaceOrientation.portrait || UIApplication.shared.statusBarOrientation == UIInterfaceOrientation.portraitUpsideDown {
                make.width.equalTo(1600/8)
                make.height.equalTo(2133/8)
                
                make.centerY.equalToSuperview()
                make.left.equalToSuperview().offset(40)

            } else {
                make.width.equalTo(1600/8)
                make.height.equalTo(2133/8)
                
                make.centerX.equalToSuperview()
                make.top.equalTo(60)

            }
        }
        
        if (SPTAuth.spotifyApplicationIsInstalled() == false) {
            hintButton.snp.remakeConstraints { (make) in
                if UIApplication.shared.statusBarOrientation == UIInterfaceOrientation.portrait || UIApplication.shared.statusBarOrientation == UIInterfaceOrientation.portraitUpsideDown {
                    make.centerX.equalToSuperview().offset(140)
                    make.height.equalTo(60)
                    make.width.equalTo(240)
                    make.centerY.equalToSuperview().offset(-20)
                } else {
                    make.centerX.equalToSuperview()
                    make.height.equalTo(60)
                    make.width.equalTo(240)
                    make.centerY.equalToSuperview().offset(80)
                }
            }
        }
        
        requirementsLabel.snp.remakeConstraints { (make) in
            if UIApplication.shared.statusBarOrientation == UIInterfaceOrientation.portrait || UIApplication.shared.statusBarOrientation == UIInterfaceOrientation.portraitUpsideDown {
                make.width.equalTo(240)
                make.height.equalTo(24)
                make.centerX.equalToSuperview().offset(140)
                make.top.equalToSuperview().offset(80)

            } else {
                make.centerX.width.equalToSuperview()
                make.height.equalTo(24)
                make.centerY.equalToSuperview().offset(40)

            }
        }
        
        loginButton.snp.remakeConstraints { (make) in
            if UIApplication.shared.statusBarOrientation == UIInterfaceOrientation.portrait || UIApplication.shared.statusBarOrientation == UIInterfaceOrientation.portraitUpsideDown {
                make.height.equalTo(60)
                make.width.equalTo(240)
                make.centerX.equalToSuperview().offset(140)
                make.bottom.equalToSuperview().offset(-60)

            } else {
                make.height.equalTo(60)
                make.width.equalTo(240)
                make.centerX.equalToSuperview()
                make.bottom.equalToSuperview().offset(-60)

            }
        }

        
        
        
    }
    
    /// Configure UI Elements and layout programmatically
    private func configureSubviews() {
        view.backgroundColor = .black
        view.addSubview(requirementsLabel)
        view.addSubview(loginButton)
        view.addSubview(bandLogoImageView)
        
        requirementsLabel.snp.makeConstraints { (make) in
            if UIApplication.shared.statusBarOrientation == UIInterfaceOrientation.portrait || UIApplication.shared.statusBarOrientation == UIInterfaceOrientation.portraitUpsideDown {
                make.centerX.width.equalToSuperview()
                make.height.equalTo(24)
                make.centerY.equalToSuperview().offset(40)
            } else {
                make.width.equalTo(240)
                make.height.equalTo(24)
                make.centerX.equalToSuperview().offset(140)
                make.top.equalToSuperview().offset(80)
            }
        }
        
        loginButton.snp.makeConstraints { (make) in
            if UIApplication.shared.statusBarOrientation == UIInterfaceOrientation.portrait || UIApplication.shared.statusBarOrientation == UIInterfaceOrientation.portraitUpsideDown {
                make.height.equalTo(60)
                make.width.equalTo(240)
                make.centerX.equalToSuperview()
                make.bottom.equalToSuperview().offset(-60)
            } else {
                make.height.equalTo(60)
                make.width.equalTo(240)
                make.centerX.equalToSuperview().offset(140)
                make.bottom.equalToSuperview().offset(-60)
            }
        }
        
        bandLogoImageView.snp.makeConstraints { (make) in
            if UIApplication.shared.statusBarOrientation == UIInterfaceOrientation.portrait || UIApplication.shared.statusBarOrientation == UIInterfaceOrientation.portraitUpsideDown {
                make.width.equalTo(1600/8)
                make.height.equalTo(2133/8)
                
                make.centerX.equalToSuperview()
                make.top.equalTo(60)
            } else {
                make.width.equalTo(1600/8)
                make.height.equalTo(2133/8)
                
                make.centerY.equalToSuperview()
                make.left.equalToSuperview().offset(40)
            }
        }
        
        if (SPTAuth.spotifyApplicationIsInstalled() == false) {
            view.addSubview(hintButton)
            
            hintButton.snp.makeConstraints { (make) in
                if UIApplication.shared.statusBarOrientation == UIInterfaceOrientation.portrait || UIApplication.shared.statusBarOrientation == UIInterfaceOrientation.portraitUpsideDown {
                    make.centerX.equalToSuperview()
                    make.height.equalTo(60)
                    make.width.equalTo(240)
                    make.centerY.equalToSuperview().offset(80)
                } else {
                    make.centerX.equalToSuperview().offset(140)
                    make.height.equalTo(60)
                    make.width.equalTo(240)
                    make.centerY.equalToSuperview().offset(-20)
                }

            }
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // We are using hardcoded Artists, fill that out.
        fillBandsMockData()
        // Listen to notifications, used to show Tracks Collection View once we have a valid session from Spotify
        NotificationCenter.default.addObserver(self, selector: #selector(sessionUpdatedNotification), name: NSNotification.Name(rawValue: kSessionWasUpdated), object: nil)
    }
    
    deinit {
        // Remove Notification listener
        NotificationCenter.default.removeObserver(self)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        UIApplication.shared.statusBarStyle = .lightContent
        configureSubviews()
    }
    
    /// We are using hardcoded Artists, fill that out.
    func fillBandsMockData() {
        let band1: Band = Band()
        band1.name = "Radiohead".uppercased()
        band1.spotifyURL = URL(string: "spotify:artist:4Z8W4fKeB5YxbusRsdQVPb")
        band1.imageName = "radioHeadLogo"
        bands.append(band1)
        
        let band2: Band = Band()
        band2.name = "The Flaming Lips".uppercased()
        band2.spotifyURL = URL(string: "spotify:artist:16eRpMNXSQ15wuJoeqguaB")
        band2.imageName = "theFlamingLipsLogo"
        bands.append(band2)
        
        let band3: Band = Band()
        band3.name = "Muse".uppercased()
        band3.spotifyURL = URL(string: "spotify:artist:12Chz98pHFMPJEknJQMWvI")
        band3.imageName = "museLogo"
        bands.append(band3)
        
        selectedBand = bands[0]

    }
    
    /// MARK: auth related methods
    @objc func sessionUpdatedNotification(notification: NSNotification) {
        guard let session = auth.session else { return }
        
        if session.isValid() {
            if isWebAuth {
                webView.dismiss(animated: true, completion: { self.showTrackList() })
            } else {
                showTrackList()
            }
        }
    }
    
    /// Show alertview letting user know, no internet connection was available
    @objc func showNoInternetAlert() {
        let alertController = UIAlertController(title: "No Internet Connection", message: "This application needs internet access.\nCheck your connection and try again.", preferredStyle: .alert)
        
        let action1 = UIAlertAction(title: "OK", style: .default) { (action:UIAlertAction) in
        }
        alertController.addAction(action1)
        alertController.view.tintColor = UIColor.topTraxxAccentDark
        
        present(alertController, animated: true, completion: nil)
    }
    
    /// Show short lived account info so users can log in and test the app.
    @objc func hintButtonTouched() {
        let alertController = UIAlertController(title: "We've got you covered", message: "Try\n501336north\n&\n713809\n\nP.S. Just remember the password.  We've copied the username to the pasteboard for you.", preferredStyle: .alert)
        
        let action1 = UIAlertAction(title: "Alrighty!", style: .default) { (action:UIAlertAction) in
            UIPasteboard.general.string = "501336north"
        }
        alertController.addAction(action1)
        alertController.view.tintColor = UIColor.topTraxxAccentDark
        
        present(alertController, animated: true, completion: nil)
    }
    
    /// Auth to a Spotify Premium account
    @objc func loginButtonTouched() {
        
        if ( isInternetAvailable() == false ) {
            showNoInternetAlert()
            return
        }
        
        guard let session = auth.session else { openLoginPage(); return }
        
        if (session.isValid()) {
            // It's still valid, show the player.
            showTrackList()
        } else {
            openLoginPage()
        }
    }
    
    /// Present Top Tracks for our Band in a CollectionView
    func showTrackList() {
        if let networkService = ServiceFactory.resolve(serviceType: SpotifyNetworkingProtocol.self) {
            networkService.retrieveTopTracks(for: selectedBand, closure: {
                let nextViewController: TracksCollectionViewController = TracksCollectionViewController()
                let navController: UINavigationController = UINavigationController(rootViewController: nextViewController)
                navController.modalTransitionStyle = .flipHorizontal
                
                self.present(navController, animated: true, completion: nil)
            })
        }
        
    }
    
    /// Present Authentication flow
    func openLoginPage() {
        isWebAuth = !SPTAuth.spotifyApplicationIsInstalled()
        if isWebAuth {
            // Web flow
            present(authViewController, animated:true, completion:nil)
        } else {
            // Spotify iOS app flow
            UIApplication.shared.open(auth.spotifyAppAuthenticationURL())
        }
    }
    

    /// Test if internet is reachable
    /// - Return: Bool letting you know if internet is reachable
    func isInternetAvailable() -> Bool
    {
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        
        let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {zeroSockAddress in
                SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
            }
        }
        
        var flags = SCNetworkReachabilityFlags()
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) {
            return false
        }
        let isReachable = flags.contains(.reachable)
        let needsConnection = flags.contains(.connectionRequired)
        return (isReachable && !needsConnection)
    }
    

}

