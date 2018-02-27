//
//  TopTraxxSlider.swift
//  TopTraxx
//
//  Created by Yanick Lavoie on 2018-02-22.
//  Copyright © 2018 Radappz. All rights reserved.
//

import UIKit

class TopTraxxSlider: UISlider {

    /// @IBInspectable superflous in this case since we aren't using storyboards but very useful if we were.
    @IBInspectable open var trackWidth:CGFloat = 5 {
        didSet {setNeedsDisplay()}
    }
    
    /// overriding trackRect for bounds to have the track a tad taller.  Was a bit too thin for our needs.
    override open func trackRect(forBounds bounds: CGRect) -> CGRect {
        let defaultBounds = super.trackRect(forBounds: bounds)
        
        return CGRect(
            x: defaultBounds.origin.x,
            y: defaultBounds.origin.y + defaultBounds.size.height/2 - trackWidth/2,
            width: defaultBounds.size.width,
            height: trackWidth
        )
    }

}
