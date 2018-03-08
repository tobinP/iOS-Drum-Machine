//
//  AltViewController.swift
//  TappyFingers
//
//  Created by Tobin Pomeroy on 3/7/18.
//  Copyright © 2018 Tobin Pomeroy. All rights reserved.
//

import UIKit

class AltViewController: UIViewController {

    @IBOutlet weak var testViewWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var testView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    @IBAction func buttonTapped(_ sender: Any) {
        self.testViewWidthConstraint.constant = 200
        UIView.animate(withDuration: 3) {
            self.view.layoutIfNeeded()
        }
    }

}
