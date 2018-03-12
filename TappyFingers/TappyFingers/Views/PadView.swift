//
//  PadView.swift
//  TappyFingers
//
//  Created by Tobin Pomeroy on 3/4/18.
//  Copyright © 2018 Tobin Pomeroy. All rights reserved.
//

import UIKit
import AVFoundation

protocol PadViewDelegate: class {
    func padWasLongPressed(pad: PadView)
}

class PadView: UIView {
    
    @IBOutlet var contentView: UIView!
    
    var audioPlayer = AVAudioPlayer()
    weak var delegate: PadViewDelegate?
    
    // MARK: Transforms
    
    let rotate360 = CGAffineTransform(rotationAngle: 6)
    let rotate180 = CGAffineTransform(rotationAngle: CGFloat.pi)
    var rotate90 = CGAffineTransform(rotationAngle: CGFloat.pi / 2)
    
    var gradientLayer = CAGradientLayer()
    var colorSets = [[CGColor]]()
    var currentColorSet = 0
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    func setup() {
        setupView()
        self.isUserInteractionEnabled = true
        createColorSets()
        createGradientLayer()
        
//        self.layer.borderWidth = 2
//        self.layer.cornerRadius = 10
//        self.layer.borderColor = UIColor.black.cgColor
    }
    
    func setupView() {
        Bundle.main.loadNibNamed("PadView", owner: self, options: nil)
        addSubview(contentView)
        contentView.translatesAutoresizingMaskIntoConstraints = false
        contentView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        contentView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        contentView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        contentView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
    }
    
    @IBAction func padWasTapped(_ sender: UIButton) {
        audioPlayer.currentTime = 0
        audioPlayer.play()

        changeGradient()

        //        performRotation()
        //        changeSize()
        wiggle()
    }
    @IBAction func padWasLongPressed(_ sender: UILongPressGestureRecognizer) {
        delegate?.padWasLongPressed(pad: self)
    }
    
    // MARK: Gradient Methods
    
    func createGradientLayer() {
        gradientLayer.frame = self.bounds
//        gradientLayer.cornerRadius = 10
        gradientLayer.colors = colorSets[currentColorSet]
        self.layer.addSublayer(gradientLayer)
    }
    
    func createColorSets() {
        colorSets.append([UIColor.green.cgColor, UIColor.black.cgColor])
        colorSets.append([UIColor.purple.cgColor, UIColor.darkGray.cgColor])
        colorSets.append([UIColor.orange.cgColor, UIColor.green.cgColor])
    }
    
    func changeGradient() {
        currentColorSet = Int(arc4random_uniform(3))

        let colorChangeAnimation = CABasicAnimation(keyPath: "colors")
        colorChangeAnimation.duration = 0.5
        colorChangeAnimation.toValue = colorSets[currentColorSet]
        colorChangeAnimation.fillMode = kCAFillModeForwards
        colorChangeAnimation.isRemovedOnCompletion = false
        gradientLayer.add(colorChangeAnimation, forKey: "colorChange")
    }
    
    // MARK: Animation Methods
    
    func performRotation() {
        rotate90 = rotate90.rotated(by: 3)
        UIView.animate(withDuration: 0.2, delay: 0, options: [], animations: {
            self.transform = self.rotate90
        }, completion: nil )
    }
    
    func changeSize() {
        UIView.animate(withDuration: 0.2, delay: 0, options: [], animations: {
            self.transform = CGAffineTransform(scaleX: 0.75, y: 0.75)
        }, completion: nil )
    }
    
    func wiggle() {
        let rotate = CGAffineTransform(rotationAngle: CGFloat.pi / 8.0)
        self.transform = self.transform.rotated(by: -(CGFloat.pi / 16.0))
        
        UIView.animate(withDuration: 0.1, delay: 0, options: [.repeat, .autoreverse], animations: {
            self.transform = rotate
        }, completion: nil )
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
            self.layer.removeAllAnimations()
            self.transform = .identity
        }
    }
    
    // MARK: Audio Methods
    
    func audioPlayerSetup(fileName: String) {
        let drumSound = NSURL(fileURLWithPath: Bundle.main.path(forResource: fileName, ofType: "wav")!)
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: drumSound as URL)
            audioPlayer.prepareToPlay()
        } catch {
            print("Problem getting File")
        }
    }
    
    func audioPlayerSetup2(fileName: String) {
        let drumSound = URL.getDocumentsDirectory().appendingPathComponent(fileName)
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: drumSound)
            audioPlayer.prepareToPlay()
        } catch {
            print("Problem getting File")
        }
    }
    
}
