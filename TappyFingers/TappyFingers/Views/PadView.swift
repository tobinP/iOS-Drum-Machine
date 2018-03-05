//
//  PadView.swift
//  TappyFingers
//
//  Created by Tobin Pomeroy on 3/4/18.
//  Copyright © 2018 Tobin Pomeroy. All rights reserved.
//

import UIKit
import AVFoundation

class PadView: UIView {
    
    var audioPlayer = AVAudioPlayer()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    func setup() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(padWasTapped))
        self.addGestureRecognizer(tap)
        self.isUserInteractionEnabled = true
        
        let bombSound = NSURL(fileURLWithPath: Bundle.main.path(forResource: "bomb", ofType: "mp3")!)
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: bombSound as URL)
            audioPlayer.prepareToPlay()
        } catch {
            print("Problem getting File")
        }
    }
    
    @objc func padWasTapped() {
        print("tapped!")
        audioPlayer.play()
    }
}
