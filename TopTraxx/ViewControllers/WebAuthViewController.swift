//
//  WebAuthViewController.swift
//  TopTraxx
//
//  Created by Yanick Lavoie on 2018-02-22.
//  Copyright © 2018 Radappz. All rights reserved.
//

import UIKit
import WebKit
import SafariServices
import Spotify

class WebAuthViewController: UIViewController {
    
    /// used to Authenticate user to the Spotify API (if Spotify app is not installed)
    var webView: UIWebView = UIWebView(frame: UIScreen.main.bounds)
    /// Auth URL to show
    var initialURL: URL?
    var loadComplete: Bool = false

    private lazy var cancelBarButtonItem: UIBarButtonItem = {
        let barButtonItem = UIBarButtonItem(title: "Cancel", style: UIBarButtonItemStyle.plain, target: self, action: #selector(cancelButtonTapped))
        
        barButtonItem.tintColor = UIColor.topTraxxBlack
        barButtonItem.setTitleTextAttributes([NSAttributedStringKey.font: UIFont.topTraxxFontRegular15, NSAttributedStringKey.foregroundColor: UIColor.topTraxxAccentDark as Any], for: .normal)
        
        return barButtonItem
    }()
    
    @objc func cancelButtonTapped() {
        SPTAuth.defaultInstance().session = nil
        dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let initialURL = initialURL {
            let initialRequest: URLRequest = URLRequest(url: initialURL)
            webView.loadRequest(initialRequest)
        }
    }
    
    convenience init(with initialURL: URL) {
        self.init(nibName: nil, bundle: nil)
        self.initialURL = initialURL
        
        view.addSubview(webView)
        navigationItem.setLeftBarButton(cancelBarButtonItem, animated: false)
        
        clearCookies()
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    /// Function to clear cookies. So we start the web auth flow fresh each time
    func clearCookies() {
        let storage: HTTPCookieStorage = HTTPCookieStorage.shared
        if let cookies: Array<HTTPCookie> = storage.cookies {
            for cookie in cookies {
                if cookie.domain.range(of: "spotify.") != nil || cookie.domain.range(of: "facebook.") != nil {
                    storage.deleteCookie(cookie)
                }

            }
        }
    }

}
