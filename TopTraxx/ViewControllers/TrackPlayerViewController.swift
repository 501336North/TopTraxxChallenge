//
//  TrackPlayerViewController.swift
//  TopTraxx
//
//  Created by Yanick Lavoie on 2018-02-21.
//  Copyright © 2018 Radappz. All rights reserved.
//

import UIKit
import Spotify
import AVFoundation
import TYBlurImage
import ColorThiefSwift

class TrackPlayerViewController: UIViewController {

    /// selected track
    var trackToPlay: SPTTrack?
    var isCurrentlyPlaying: Bool = false
    var isChangingProgress: Bool = false
    /// the dominant color from the album artwork
    var dominantColor: UIColor = UIColor.clear
    /// color to use on button, navbar, etc... depends on the
    var readableColor: UIColor = UIColor.clear   dominant color
    /// artwork to the album on which the selected track can be found
    var artworkImage: UIImage?
    
    /// Spotify player
    private lazy var player: SPTAudioStreamingController = {
        return SPTAudioStreamingController.sharedInstance()
    }()
    
    private lazy var trackTitleLabel: UILabel = {
        let label = UILabel()
        
        label.font = UIFont.topTraxxFontRegular22
        label.numberOfLines = 0
        label.textAlignment = .center
        label.textColor = UIColor.topTraxxWhite
        
        if let trackToPlay = trackToPlay {
            label.text = trackToPlay.name
        }

        return label
    }()
    
    /// simple progressbar to show track position while playing
    private lazy var progressSlider: TopTraxxSlider = {
        let slider = TopTraxxSlider()
        
        slider.minimumValue = 0
        slider.maximumValue = Float(trackToPlay!.duration)
        slider.isContinuous = true
        slider.tintColor = UIColor.topTraxxAccent
        slider.setThumbImage(UIImage(), for: .normal)

        return slider
    }()
    
    /// play / pause button
    private lazy var playerButton: UIButton = {
        let button = UIButton(type: UIButtonType.custom)
        button.layer.cornerRadius = 30
        button.clipsToBounds = true
        button.addTarget(self, action: #selector(playerButtonTouched), for: .touchUpInside)
        button.setTitle("Pause", for: .normal)
        button.backgroundColor = UIColor.topTraxxBlack
        
        return button
        
    }()
    
    private lazy var albumArtworkImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 4
        imageView.clipsToBounds = true
    
        return imageView
    }()
    
    /// UIImageView used on view background.  We are using album artwork to which some filters are applied.
    private lazy var blurredAlbumArtworkBackgroundImageView: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let auth: SPTAuth = SPTAuth.defaultInstance()
        
        albumArtworkImageView.image = artworkImage
        
        // computing filter on album artwork to use it on background view
        let blurRadius: CGFloat = 30.0
        let saturationDeltaFactor: CGFloat = 0.8
        let tintColor = UIColor.topTraxxBlack.withAlphaComponent(0.25)
        let blurredImage = UIImage.ty_imageByApplyingBlur(to: artworkImage!, withRadius: blurRadius, tintColor: tintColor, saturationDeltaFactor: saturationDeltaFactor, maskImage: nil)
        blurredAlbumArtworkBackgroundImageView.image = blurredImage
        
        // compute dominant color from artwork imagee
        if let color: MMCQ.Color = ColorThief.getColor(from: artworkImage!) {
            dominantColor = color.makeUIColor()
        }
        playerButton.backgroundColor = dominantColor.withAlphaComponent(0.8)
        
        let clientID = auth.clientID
        do {
            try player.start(withClientId: clientID)
        }
        catch {
        }
        player.delegate = self
        player.playbackDelegate = self
        player.diskCache = SPTDiskCache(capacity: 1024 * 1024 * 64)
        player.login(withAccessToken: auth.session.accessToken)

        // configure navigation based on dominant color from album artwork
        guard let navController = navigationController else { return }
        navController.navigationBar.tintColor = dominantColor
        navController.navigationBar.barTintColor = dominantColor
        
        navController.interactivePopGestureRecognizer?.isEnabled = false

    }
    
    convenience init(track: SPTTrack, artwork: UIImage) {
        self.init(nibName: nil, bundle: nil)
        
        trackToPlay = track
        artworkImage = artwork
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureSubviews()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        isChangingProgress = true
        player.logout()
        super.viewWillDisappear(animated)
    }
    
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        
        progressSlider.snp.remakeConstraints { (make) in
            make.width.equalToSuperview()
            make.height.equalTo(14)
            make.centerX.equalToSuperview()
            
            if UIApplication.shared.statusBarOrientation == UIInterfaceOrientation.portrait || UIApplication.shared.statusBarOrientation == UIInterfaceOrientation.portraitUpsideDown {
                make.top.equalTo(27)
            } else {
                make.top.equalTo(57)
            }
        }
        
        albumArtworkImageView.snp.remakeConstraints { (make) in
            if UIApplication.shared.statusBarOrientation == UIInterfaceOrientation.portrait || UIApplication.shared.statusBarOrientation == UIInterfaceOrientation.portraitUpsideDown {
                let margin: CGFloat = 50
                make.width.height.equalTo( min(UIScreen.main.bounds.size.width, UIScreen.main.bounds.size.height) - (margin * 2))
                make.left.equalTo(margin)
                make.centerY.equalToSuperview().offset(15)

            } else {
                let margin: CGFloat = 40
                make.width.height.equalTo( min(UIScreen.main.bounds.size.width, UIScreen.main.bounds.size.height) - (margin * 2))
                make.centerX.equalToSuperview()
                make.top.equalTo(60 + margin)

            }
        }
        
        playerButton.snp.remakeConstraints { (make) in
            if UIApplication.shared.statusBarOrientation == UIInterfaceOrientation.portrait || UIApplication.shared.statusBarOrientation == UIInterfaceOrientation.portraitUpsideDown {
                make.height.equalTo(60)
                make.width.equalTo(240)
                make.right.equalToSuperview().offset(-50)
                make.centerY.equalToSuperview().offset(15)

            } else {
                make.height.equalTo(60)
                make.width.equalTo(240)
                make.centerX.equalToSuperview()
                make.bottom.equalToSuperview().offset(-40)
            }
        }
        
        if UIApplication.shared.statusBarOrientation == UIInterfaceOrientation.portrait || UIApplication.shared.statusBarOrientation == UIInterfaceOrientation.portraitUpsideDown {
            trackTitleLabel.isHidden = true
            title = trackToPlay?.name
        } else {
            trackTitleLabel.isHidden = false
            title = ""
        }

    }
    
    /// Configure UI Elements and layout programmatically
    private func configureSubviews() {
        view.addSubview(blurredAlbumArtworkBackgroundImageView)
        view.addSubview(albumArtworkImageView)
        view.addSubview(trackTitleLabel)
        view.addSubview(playerButton)
        view.addSubview(progressSlider)
        
        blurredAlbumArtworkBackgroundImageView.snp.makeConstraints { (make) in
            make.centerX.width.centerY.height.equalToSuperview()
        }
        
        albumArtworkImageView.snp.makeConstraints { (make) in
            if UIApplication.shared.statusBarOrientation == UIInterfaceOrientation.portrait || UIApplication.shared.statusBarOrientation == UIInterfaceOrientation.portraitUpsideDown {
                let margin: CGFloat = 40
                make.width.height.equalTo( min(UIScreen.main.bounds.size.width, UIScreen.main.bounds.size.height) - (margin * 2))
                make.centerX.equalToSuperview()
                make.top.equalTo(60 + margin)

            } else {
                let margin: CGFloat = 50
                make.width.height.equalTo( min(UIScreen.main.bounds.size.width, UIScreen.main.bounds.size.height) - (margin * 2))
                make.left.equalTo(margin)
                make.centerY.equalToSuperview().offset(15)
            }
        }
        
        trackTitleLabel.snp.makeConstraints { (make) in
            make.centerX.width.height.equalToSuperview()
            make.centerY.equalTo(albumArtworkImageView.snp.bottom).offset(80)
        }
        
        playerButton.snp.makeConstraints { (make) in
            if UIApplication.shared.statusBarOrientation == UIInterfaceOrientation.portrait || UIApplication.shared.statusBarOrientation == UIInterfaceOrientation.portraitUpsideDown {
                make.height.equalTo(60)
                make.width.equalTo(240)
                make.centerX.equalToSuperview()
                make.bottom.equalToSuperview().offset(-40)

            } else {
                make.height.equalTo(60)
                make.width.equalTo(240)
                make.right.equalToSuperview().offset(-50)
                make.centerY.equalToSuperview().offset(15)
            }
        }
        
        progressSlider.snp.makeConstraints { (make) in
            make.width.equalToSuperview()
            make.height.equalTo(14)
            make.centerX.equalToSuperview()
            if UIApplication.shared.statusBarOrientation == UIInterfaceOrientation.portrait || UIApplication.shared.statusBarOrientation == UIInterfaceOrientation.portraitUpsideDown {
                make.top.equalTo(57)
            } else {
                make.top.equalTo(27)
            }
        }
        
        progressSlider.maximumTrackTintColor = dominantColor
        
        readableColor = UIColor.topTraxxBlack
        UIApplication.shared.statusBarStyle = .default

        if (shouldUseLightForeColor(with: dominantColor) == true) {
            readableColor = UIColor.topTraxxWhite
            UIApplication.shared.statusBarStyle = .lightContent
        }
        
        playerButton.setTitleColor(readableColor, for: .normal)
        trackTitleLabel.textColor = readableColor
        navigationController?.navigationBar.tintColor = readableColor
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.font: UIFont.topTraxxFontRegular17, NSAttributedStringKey.foregroundColor: readableColor as Any]
    }

    /// compute if we should light or dark color for text color depending on color passed as parameter (this param will be the dominant color we got from album artwork)
    func shouldUseLightForeColor(with color: UIColor) -> Bool {
        let threshold: CGFloat = 0.0000014
        let multiplier: CGFloat = 2.2
        
        if let colorComponentsArray = color.cgColor.components {
        
            var Y: CGFloat = 0.0
            let R: CGFloat = colorComponentsArray[0]
            let G: CGFloat = colorComponentsArray[1]
            let B: CGFloat = colorComponentsArray[2]
        
            let subR =  pow(0.2126 * R/255, multiplier)
            let subG =  pow(0.7151 * G/255, multiplier)
            let subB =  pow(0.0721 * B/255, multiplier)
        
            Y =  subR +  subG  +  subB
            return Y < threshold
        }
        
        return false
    }
    
    /// Update button title based on player state.
    func updatePlayerUI() {
        if (isCurrentlyPlaying) {
            playerButton.setTitle("Pause", for: .normal)
        } else {
            playerButton.setTitle("Play", for: .normal)
        }
    }
    
    /// Pause / Play the track
    @objc func playerButtonTouched() {
        player.setIsPlaying(!isCurrentlyPlaying, callback: nil)
        isCurrentlyPlaying = !isCurrentlyPlaying
        updatePlayerUI()
    }

    
    /// MARK: Audio Session
    func activateAudioSession() {
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
        }
    }
    
    func deactivateAudioSession() {
        do {
            try AVAudioSession.sharedInstance().setActive(false)
        } catch {
        }
    }
}

extension TrackPlayerViewController : SPTAudioStreamingDelegate, SPTAudioStreamingPlaybackDelegate {
    
    func audioStreaming(_ audioStreaming: SPTAudioStreamingController!, didReceiveMessage message: String!) {
        let alertController = UIAlertController(title: "Message from Spotify", message: message, preferredStyle: .alert)
        
        let action1 = UIAlertAction(title: "OK", style: .default) { (action:UIAlertAction) in
        }
        alertController.addAction(action1)
        alertController.view.tintColor = UIColor.topTraxxAccentDark
        
        present(alertController, animated: true, completion: nil)
    }
    
    func audioStreaming(_ audioStreaming: SPTAudioStreamingController!, didChangePlaybackStatus isPlaying: Bool) {
        isCurrentlyPlaying = isPlaying
        if (isCurrentlyPlaying) {
            activateAudioSession()
        } else {
            deactivateAudioSession()
        }
    }
    
    func audioStreaming(_ audioStreaming: SPTAudioStreamingController!, didChangePosition position: TimeInterval) {
        if (self.isChangingProgress) {
            return
        }
        progressSlider.value = Float(position)
    }
    
    func audioStreamingDidLogin(_ audioStreaming: SPTAudioStreamingController!) {
        player.playSpotifyURI(trackToPlay?.playableUri.absoluteString, startingWith: 0, startingWithPosition: 1, callback: nil)
        isCurrentlyPlaying = true
        updatePlayerUI()
    }
    
}
