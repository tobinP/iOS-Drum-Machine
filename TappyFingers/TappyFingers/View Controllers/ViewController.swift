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
    
    // MARK: Options Menu IB Outlets
    
    @IBOutlet weak var soundsCategoryLabel: UILabel!
    @IBOutlet weak var recordOptionButton: UIButton!
    @IBOutlet weak var pickSampleOptionButton: UIButton!
    @IBOutlet weak var visualCategoryLabel: UILabel!
    @IBOutlet weak var wiggleOptionButton: UIButton!
    @IBOutlet weak var colorMorphOptionButton: UIButton!
    @IBOutlet weak var optionContainerView: UIView!
    
    // MARK: Transforms
    let rotate360 = CGAffineTransform(rotationAngle: 6)
    let rotate180 = CGAffineTransform(rotationAngle: CGFloat.pi)
    var rotate90 = CGAffineTransform(rotationAngle: CGFloat.pi / 2)
    let shrink = CGAffineTransform(scaleX: 0.5, y: 0.5)
    
    var gradientLayer = CAGradientLayer()
    let blurEffectView = UIVisualEffectView()
    
    let drumFileNames = ["closedhat", "dirtkick", "floortom", "openhat", "snare", "symbol"]
    var focusedPadView: PadView?
    
    // MARK: Life Cycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        for i in 0..<padViews.count {
            padViews[i].audioPlayerSetup(fileName: drumFileNames[i], fileType: .wav)
            padViews[i].delegate = self
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        rotateAllPads180()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "SamplePickerSegue" {
            guard let destinationVC = segue.destination as? SamplePickerViewController else { return }
            destinationVC.delegate = self
        }
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
    
    // MARK: IB Action Methods
    
    @IBAction func displayRecordingView(_ sender: UIButton) {
        // Animate the view expansion and alpha
        self.view.bringSubview(toFront: recordingView)
        UIView.animate(withDuration: 1, delay: 0, options: [.curveEaseOut], animations: {
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
    
    func padWasLongPressed(pad: PadView) {
        
        // This pad will be the one to have it's sample file updated from the sample picker
        focusedPadView = pad
        
        blurEffectView.frame = view.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(blurEffectView)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissMenu))
        blurEffectView.addGestureRecognizer(tap)
        blurEffectView.isUserInteractionEnabled = true
        
        UIView.animate(withDuration: 0.3, delay: 0, options: [], animations: {
            self.blurEffectView.effect = UIBlurEffect(style: .dark)
        }, completion: { _ in self.displayOptionMenu() } )
    }
    
    func displayOptionMenu() {
        soundsCategoryLabel.transform = CGAffineTransform(translationX: 0, y: 256)
        recordOptionButton.transform = CGAffineTransform(translationX: 0, y: 256)
        pickSampleOptionButton.transform = CGAffineTransform(translationX: 0, y: 256)
        self.view.bringSubview(toFront: optionContainerView)
        
        optionContainerView.isHidden = false
        soundsCategoryLabel.alpha = 1
        recordOptionButton.alpha = 1
        pickSampleOptionButton.alpha = 1
        UIView.animate(withDuration: 0.6, delay: 0.0, options: [], animations: {
            self.soundsCategoryLabel.transform = CGAffineTransform(translationX: 0, y: 0)
            self.recordOptionButton.transform = CGAffineTransform(translationX: 0, y: 0)
            self.pickSampleOptionButton.transform = CGAffineTransform(translationX: 0, y: 0)
        }, completion: displayVisualOptions)
    }
    
    func displayVisualOptions(_: Bool) {
        visualCategoryLabel.transform = CGAffineTransform(translationX: 0, y: 256)
        wiggleOptionButton.transform = CGAffineTransform(translationX: 0, y: 256)
        colorMorphOptionButton.transform = CGAffineTransform(translationX: 0, y: 256)
        
        visualCategoryLabel.alpha = 1
        wiggleOptionButton.alpha = 1
        colorMorphOptionButton.alpha = 1
        UIView.animate(withDuration: 0.6, delay: 0.2, options: [], animations: {
            self.visualCategoryLabel.transform = CGAffineTransform(translationX: 0, y: 0)
            self.wiggleOptionButton.transform = CGAffineTransform(translationX: 0, y: 0)
            self.colorMorphOptionButton.transform = CGAffineTransform(translationX: 0, y: 0)
        }, completion: nil)
    }
    
    @objc func dismissMenu() {
        
        // Slowly dismiss the blur view
        UIView.animate(withDuration: 0.4, delay: 0, options: [], animations: {
            self.blurEffectView.effect = nil
        }, completion: { _ in self.blurEffectView.removeFromSuperview() } )
        
        // Shrink and hide the recording view
        UIView.animate(withDuration: 0.4, delay: 0, options: [.curveEaseOut], animations: {
            self.recordingView.alpha = 0
        }, completion: nil )
        self.recordingViewWidthConstraint.constant = 0
        UIView.animate(withDuration: 0.5) {
            self.view.layoutIfNeeded()
        }
        
        // Hide option view and content
        self.view.sendSubview(toBack: optionContainerView)
        visualCategoryLabel.alpha = 0
        wiggleOptionButton.alpha = 0
        colorMorphOptionButton.alpha = 0
    }
}

extension ViewController: SamplePickerDelegate {
    func replacePadSound(fileName: String) {
        focusedPadView?.audioPlayerSetup(fileName: fileName, fileType: .m4a)
    }
}
