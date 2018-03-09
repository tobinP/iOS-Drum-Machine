//
//  SamplePickerViewController.swift
//  TappyFingers
//
//  Created by Tobin Pomeroy on 3/8/18.
//  Copyright © 2018 Tobin Pomeroy. All rights reserved.
//

import UIKit

protocol SamplePickerDelegate: class {
    func replacePadSound(fileName: String)
}

class SamplePickerViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    weak var delegate: SamplePickerDelegate?
    var samples = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()

        let fileManager = FileManager.default
        let documentsURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
        do {
            let fileURLs = try fileManager.contentsOfDirectory(at: documentsURL, includingPropertiesForKeys: nil)
            let fileNames = fileURLs.map{ $0.lastPathComponent }
            fileNames.forEach { samples.append($0) }
        } catch {
            print("Error getting files from document directory")
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = samples[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.replacePadSound(fileName: samples[indexPath.row])
        self.dismiss(animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return samples.count
    }

}
