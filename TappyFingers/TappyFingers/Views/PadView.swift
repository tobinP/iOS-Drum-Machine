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
    var soundFileName = "dirtkick"
    
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
    }
    
    func audioPlayerSetup(fileName: String) {
        let drumSound = NSURL(fileURLWithPath: Bundle.main.path(forResource: fileName, ofType: "wav")!)
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: drumSound as URL)
            audioPlayer.prepareToPlay()
        } catch {
            print("Problem getting File")
        }
    }
    
    @objc func padWasTapped() {
        audioPlayer.currentTime = 0
        print("tapped!")
        audioPlayer.play()
    }
}
