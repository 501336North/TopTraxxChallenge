//
//  TracksCollectionViewCell.swift
//  TopTraxxChallenge
//
//  Created by Yanick Lavoie on 2018-02-20.
//  Copyright © 2018 Radappz. All rights reserved.
//

import UIKit
import AlamofireImage
import Spotify
import SnapKit

class TracksCollectionViewCell: UICollectionViewCell {
    
    private lazy var trackTitleLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = UIColor.topTraxxBlack45
        label.font = UIFont.topTraxxFontRegular22
        label.numberOfLines = 2
        label.textAlignment = .center
        label.textColor = UIColor.topTraxxWhite
        return label
    }()
    
    lazy var albumArtworkImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 4
        imageView.clipsToBounds = true
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureSubviews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func prepareForReuse() {
        trackTitleLabel.alpha = 0.0
        trackTitleLabel.text = ""
    }
        
    func configureCell(trackName: String, albumArtworkURL: URL) {
        trackTitleLabel.alpha = 0.0
        
        let url = albumArtworkURL
        guard let placeHolderImage: UIImage = UIImage(named:"albumArtworkPlaceholder") else { return }
        
        albumArtworkImageView.af_setImage(withURL: url, placeholderImage: placeHolderImage, completion: { (data) in
            
             if (self.albumArtworkImageView.image?.size != placeHolderImage.size) {
                self.trackTitleLabel.text = trackName
                UIView.animate(withDuration: 0.35, animations: {
                    self.trackTitleLabel.alpha = 1.0
                })
            }
        })
        
        
    }
    
    private func configureSubviews() {
        backgroundColor = UIColor.topTraxxDarkGray
        
        contentView.addSubview(albumArtworkImageView)
        contentView.addSubview(trackTitleLabel)
        
        trackTitleLabel.snp.makeConstraints { (make) in
            make.centerX.bottom.width.equalToSuperview()
            make.height.equalTo(60)
        }
        
        albumArtworkImageView.snp.makeConstraints { (make) in
            make.width.height.equalToSuperview()
            make.top.bottom.left.right.equalTo(0)
        }
    }
    
    
}