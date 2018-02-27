//
//  TracksCollectionViewController.swift
//  TopTraxx
//
//  Created by Yanick Lavoie on 2018-02-21.
//  Copyright © 2018 Radappz. All rights reserved.
//

import UIKit
import Spotify

private let reuseIdentifier = "TrackCell"

class TracksCollectionViewController: UIViewController {
    
    var trackItems: [SPTTrack] = []
    var band: Band?
    
    private lazy var collectionView: UICollectionView = {
        let margin: CGFloat = 20.0
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: margin, left: margin, bottom: margin, right: margin)
        layout.minimumLineSpacing = margin
        let screenWidth = UIScreen.main.bounds.size.width - (margin * 2)
        layout.itemSize = CGSize(width: screenWidth, height: screenWidth)

        let tracksCollectionView = UICollectionView(frame: view.frame, collectionViewLayout: layout)
        tracksCollectionView.register(TracksCollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        tracksCollectionView.dataSource = self
        tracksCollectionView.delegate = self
        tracksCollectionView.backgroundColor = UIColor.topTraxxDarkGray
        
        return tracksCollectionView
    }()
    
    /// button to Logout of the App and kill Spotift session
    private lazy var logoutBarButtonItem: UIBarButtonItem = {
        let barButtonItem = UIBarButtonItem(title: "Logout", style: UIBarButtonItemStyle.plain, target: self, action: #selector(logoutButtonTapped))

        barButtonItem.tintColor = UIColor.topTraxxBlack
        barButtonItem.setTitleTextAttributes([NSAttributedStringKey.font: UIFont.topTraxxFontRegular15, NSAttributedStringKey.foregroundColor: UIColor.topTraxxAccentDark as Any], for: .normal)

        return barButtonItem
    }()
        
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Top Traxx".uppercased()
        
        navigationItem.setLeftBarButton(logoutBarButtonItem, animated: false)
        NotificationCenter.default.addObserver(self, selector: #selector(spotifyTopTracksReceived), name: NSNotification.Name(rawValue: kSpotifyTopTracksReceived), object: nil)
    }

    deinit {
        // Remove Notification listener
        NotificationCenter.default.removeObserver(self)
    }

    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        configureSubviews()
        
        guard let navController = navigationController else { return }
        navController.navigationBar.tintColor = UIColor.topTraxxAccentDark
        navController.navigationBar.barTintColor = UIColor.topTraxxDarkGray
        navController.navigationBar.titleTextAttributes = [NSAttributedStringKey.font: UIFont.topTraxxFontRegular17, NSAttributedStringKey.foregroundColor: UIColor.topTraxxAccentDark as Any]
        
        UIApplication.shared.statusBarStyle = .lightContent
    }
    
    /// Configure UI Elements and layout programmatically
    private func configureSubviews() {
        view.addSubview(collectionView)
        
        collectionView.snp.makeConstraints { (make) in
            make.top.bottom.left.right.equalToSuperview()
        }
    }
    
    /// function to Logout of the App and kill Spotift session - returns the user to the login screen
    @objc func logoutButtonTapped() {
        SPTAuth.defaultInstance().session = nil
        dismiss(animated: true, completion: nil)
    }
    
    @objc func spotifyTopTracksReceived(notif: Notification) {
        if let topTracks = notif.object as? Array<Any> {
            do {
                for track in topTracks {
                    let topTrack = try SPTTrack(decodedJSONObject: track)
                    self.trackItems.append(topTrack)
                }
            } catch {}
            self.collectionView.reloadData()
        }
    }
}

/// MARK: CollectionView extensions
extension TracksCollectionViewController : UICollectionViewDelegateFlowLayout, UICollectionViewDataSource  {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return trackItems.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: TracksCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! TracksCollectionViewCell
        
        let track = trackItems[indexPath.item]
        guard let artwork = track.album.largestCover else { return cell }
        guard let url = artwork.imageURL else { return cell }
        
        cell.configureCell(trackName: track.name, albumArtworkURL: url)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! TracksCollectionViewCell
        guard let img = cell.albumArtworkImageView.image else { return }
        let nextViewController = TrackPlayerViewController(track: trackItems[indexPath.item], artwork: img)

        if let navController: UINavigationController = navigationController {
            navController.pushViewController(nextViewController, animated: true)
        }
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
}
