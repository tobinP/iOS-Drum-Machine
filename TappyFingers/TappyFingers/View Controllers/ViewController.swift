//
//  ViewController.swift
//  TappyFingers
//
//  Created by Tobin Pomeroy on 3/4/18.
//  Copyright © 2018 Tobin Pomeroy. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var recordingViewWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var recordingView: RecordingView!
    @IBOutlet var padViews: [PadView]!
    @IBOutlet weak var topMiddlePad: PadView!
    @IBOutlet weak var topStackView: UIStackView!
    @IBOutlet weak var bottomStackView: UIStackView!
    @IBOutlet weak var optionLabel: UILabel!
    @IBOutlet weak var optionContainerView: UIView!
    
    // MARK: Transforms
    let rotate360 = CGAffineTransform(rotationAngle: 6)
    let rotate180 = CGAffineTransform(rotationAngle: CGFloat.pi)
    var rotate90 = CGAffineTransform(rotationAngle: CGFloat.pi / 2)
    let shrink = CGAffineTransform(scaleX: 0.5, y: 0.5)
    
    var gradientLayer = CAGradientLayer()
    let blurEffectView = UIVisualEffectView()
    
    let drumFileNames = ["closedhat", "dirtkick", "floortom", "openhat", "snare", "symbol"]
    
    // MARK: Life Cycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        for i in 0..<padViews.count {
            padViews[i].audioPlayerSetup(fileName: drumFileNames[i])
            padViews[i].delegate = self
        }
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(displayRecordingView))
        optionLabel.addGestureRecognizer(tap)
        optionLabel.isUserInteractionEnabled = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
//        rotateAllPads180()
    }
    
    func createGradientLayer() {
        gradientLayer.frame = self.view.bounds
        gradientLayer.colors = [UIColor.red.cgColor, UIColor.yellow.cgColor]
        self.view.layer.addSublayer(gradientLayer)
    }
    
    // MARK: Animation Methods
    
    func rotateAllPads180() {
        UIView.animate(withDuration: 0.6, delay: 0, options: [.curveEaseOut], animations: {
            self.padViews.forEach {
                $0.transform = self.rotate180.concatenating(self.shrink)
            }
        }, completion: { _ in self.resetAllPads() } )
    }
    
    func resetAllPads() {
        UIView.animate(withDuration: 0.6, delay: 0, options: [.curveEaseOut], animations: {
            self.padViews.forEach {
                $0.transform = .identity
            }
        }, completion: nil )
    }
    
    @objc func displayRecordingView() {
        
        // Animate the view expansion and alpha
        self.view.bringSubview(toFront: recordingView)
        UIView.animate(withDuration: 2, delay: 0, options: [.curveEaseOut], animations: {
            self.recordingView.alpha = 1
        }, completion: nil )
        self.recordingViewWidthConstraint.constant = 500
        UIView.animate(withDuration: 2) {
            self.view.layoutIfNeeded()
        }
        
        // Create transparent gradient
//        let mask = CAGradientLayer()
//        mask.startPoint = CGPoint(x: 0, y: 0.5)
//        mask.endPoint = CGPoint(x:0.25, y:0.5)
//        let whiteColor = UIColor.white
//        mask.colors = [whiteColor.withAlphaComponent(0.0).cgColor,
//                       whiteColor.withAlphaComponent(1.0).cgColor,
//                       whiteColor.withAlphaComponent(1.0).cgColor]
//        mask.locations = [NSNumber(value: 0.0),
//                          NSNumber(value: 0.8),
//                          NSNumber(value: 1.0)]
//        mask.frame = view.bounds
//        recordingView.layer.mask = mask
        
        let maskLayer = CAGradientLayer()
        maskLayer.frame = recordingView.bounds
        maskLayer.shadowRadius = 5
        maskLayer.shadowPath = CGPath(roundedRect: recordingView.bounds.insetBy(dx: 5, dy: 5), cornerWidth: 10, cornerHeight: 10, transform: nil)
        maskLayer.shadowOpacity = 1;
        maskLayer.shadowOffset = CGSize.zero;
        maskLayer.shadowColor = UIColor.white.cgColor
        recordingView.layer.mask = maskLayer;
        
    }
}

extension ViewController: PadViewDelegate {
    
    func padWasLongPressed() {
        blurEffectView.frame = view.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(blurEffectView)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissMenu))
        blurEffectView.addGestureRecognizer(tap)
        blurEffectView.isUserInteractionEnabled = true
        
        UIView.animate(withDuration: 0.3, delay: 0, options: [], animations: {
            self.blurEffectView.effect = UIBlurEffect(style: .dark)
        }, completion: { _ in self.popupMenu() } )
    }
    
    func popupMenu() {
        optionContainerView.isHidden = false
        optionLabel.alpha = 1
        self.view.bringSubview(toFront: optionContainerView)
        
        optionLabel.transform = CGAffineTransform(translationX: 0, y: 256)
        UIView.animate(withDuration: 1, delay: 0, options: [], animations: {
            self.optionLabel.transform = CGAffineTransform(translationX: 0, y: 0)
        }, completion: nil)
    }
    
    @objc func dismissMenu() {
        
        // Slowly dismiss the blur view
        UIView.animate(withDuration: 0.9, delay: 0, options: [], animations: {
            self.blurEffectView.effect = nil
        }, completion: { _ in self.blurEffectView.removeFromSuperview() } )
        
        // Shrink and hide the recording view
        UIView.animate(withDuration: 2, delay: 0, options: [.curveEaseOut], animations: {
            self.recordingView.alpha = 0
        }, completion: nil )
        self.recordingViewWidthConstraint.constant = 0
        UIView.animate(withDuration: 2) {
            self.view.layoutIfNeeded()
        }
        
        // Hide option view and content
        self.view.sendSubview(toBack: optionContainerView)
    }
}
