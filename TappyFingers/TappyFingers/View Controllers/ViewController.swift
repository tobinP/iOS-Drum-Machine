//
//  ViewController.swift
//  TappyFingers
//
//  Created by Tobin Pomeroy on 3/4/18.
//  Copyright © 2018 Tobin Pomeroy. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet var padViews: [PadView]!
    
    let drumFileNames = ["closedhat", "dirtkick", "floortom", "openhat", "snare", "symbol"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        for i in 0..<padViews.count {
            padViews[i].audioPlayerSetup(fileName: drumFileNames[i])
        }
        
    }

}

