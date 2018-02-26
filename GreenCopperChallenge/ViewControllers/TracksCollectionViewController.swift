//
//  TracksCollectionViewController.swift
//  TopTraxxChallenge
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
    
    // button to Logout of the App and kill Spotift session
    private lazy var logoutBarButtonItem: UIBarButtonItem = {
        let barButtonItem = UIBarButtonItem(title: "Logout", style: UIBarButtonItemStyle.plain, target: self, action: #selector(logoutButtonTapped))

        barButtonItem.tintColor = UIColor.topTraxxBlack
        barButtonItem.setTitleTextAttributes([NSAttributedStringKey.font: UIFont.topTraxxFontRegular15, NSAttributedStringKey.foregroundColor: UIColor.topTraxxAccentDark as Any], for: .normal)

        return barButtonItem
    }()
    
    convenience init() {
        self.init(nibName:nil, bundle:nil)
    }
    
    convenience init(with bandParam: Band) {
        self.init(nibName: nil, bundle: nil)
        band = bandParam
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Top Traxx".uppercased()
        view.addSubview(collectionView)
        navigationItem.setLeftBarButton(logoutBarButtonItem, animated: false)
        
        if let band = band {
            retrieveSpotifyData(for: band)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        guard let navController = navigationController else { return }
        navController.navigationBar.tintColor = UIColor.topTraxxAccentDark
        navController.navigationBar.barTintColor = UIColor.topTraxxDarkGray
        navController.navigationBar.titleTextAttributes = [NSAttributedStringKey.font: UIFont.topTraxxFontRegular17, NSAttributedStringKey.foregroundColor: UIColor.topTraxxAccentDark as Any]
        
        UIApplication.shared.statusBarStyle = .lightContent
    }
    
    // function to Logout of the App and kill Spotift session - returns the user to the login screen
    @objc func logoutButtonTapped() {
        SPTAuth.defaultInstance().session = nil
        dismiss(animated: true, completion: nil)
    }
    
    // Connect to the Spotify API and get Top Tracks data for what ever Band is passed for parameter
    func retrieveSpotifyData(for band: Band) {
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
                            for track in topTracks {
                                let topTrack = try SPTTrack(decodedJSONObject: track)
                                self.trackItems.append(topTrack)
                            }
                        } else {
                            return
                        }
                    } else {
                        print("error!!!")
                        return
                    }
                } catch {
                    return
                }
            
                self.collectionView.reloadData()
            })

        } catch _ {
        }
    }
    
}

// MARK: CollectionView extensions
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
