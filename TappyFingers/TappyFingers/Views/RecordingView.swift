//
//  RecordingView.swift
//  TappyFingers
//
//  Created by Tobin Pomeroy on 3/7/18.
//  Copyright © 2018 Tobin Pomeroy. All rights reserved.
//

import UIKit

class RecordingView: UIView {

    // MARK: IB Outlets
    
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var recordingIndicatorLight: UIView!
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var playButton: UIButton!
    
    // MARK: IB Actions
    
    @IBAction func recordButtonTapped(_ sender: UIButton) {
    }
    
    @IBAction func playButtonTapped(_ sender: UIButton) {
    }
    
    // MARK: Initializers
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    func setup() {
        Bundle.main.loadNibNamed("RecordingView", owner: self, options: nil)
        addSubview(contentView)
        contentView.translatesAutoresizingMaskIntoConstraints = false
        contentView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        contentView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        contentView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        contentView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
    }
}
