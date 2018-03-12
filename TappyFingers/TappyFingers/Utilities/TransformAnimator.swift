//
//  TransformAnimator.swift
//  TappyFingers
//
//  Created by Tobin Pomeroy on 3/11/18.
//  Copyright © 2018 Tobin Pomeroy. All rights reserved.
//

import UIKit

class TransformAnimator {
    
    // Statically allocated transform since this will be called every time a cell becomes visible
    static var forwardRotatedTransform: CATransform3D = {
        let rotationRadians: CGFloat = 180 * (CGFloat.pi/180)
        var startTransform = CATransform3DRotate(CATransform3DIdentity, rotationRadians, 1, 0, 0)
        startTransform = CATransform3DTranslate(startTransform, 0, 0, 0)
        
        return startTransform
    }()
    
    class func animateHorizontalAxis(view: UIView) {
        view.layer.transform = forwardRotatedTransform
        view.layer.opacity = 0.5
        
        UIView.animate(withDuration: 1) {
            view.layer.transform = CATransform3DIdentity
            view.layer.opacity = 0.8
        }
    }
}
