//
//  WebAuthViewController.swift
//  TopTraxxChallenge
//
//  Created by Yanick Lavoie on 2018-02-22.
//  Copyright © 2018 Radappz. All rights reserved.
//

import UIKit
import WebKit
import Spotify

class WebAuthViewController: UIViewController {
    
    var webView: UIWebView = UIWebView(frame: UIScreen.main.bounds)
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
    
    convenience init(with initialURL: URL) {
        self.init(nibName: nil, bundle: nil)
        let initialRequest: URLRequest = URLRequest(url: initialURL)
        
        view.addSubview(webView)
        navigationItem.setLeftBarButton(cancelBarButtonItem, animated: false)
        
        webView.loadRequest(initialRequest)
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
