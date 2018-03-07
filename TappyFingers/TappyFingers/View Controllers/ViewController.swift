//
//  ViewController.swift
//  TappyFingers
//
//  Created by Tobin Pomeroy on 3/4/18.
//  Copyright © 2018 Tobin Pomeroy. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var labelStackView: UIStackView!
    @IBOutlet var labels: [UILabel]!
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
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        rotateAllPads180()
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
}

extension ViewController: PadViewDelegate {
    
    func padWasLongPressed() {
        blurEffectView.frame = view.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(blurEffectView)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissMenu))
        blurEffectView.addGestureRecognizer(tap)
        blurEffectView.isUserInteractionEnabled = true
        
        UIView.animate(withDuration: 1.6, delay: 0, options: [], animations: {
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
        UIView.animate(withDuration: 0.9, delay: 0, options: [], animations: {
            self.blurEffectView.effect = nil
        }, completion: { _ in self.blurEffectView.removeFromSuperview() } )
    }
}
