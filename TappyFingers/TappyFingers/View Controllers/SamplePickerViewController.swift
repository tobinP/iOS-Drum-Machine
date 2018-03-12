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
    
    @IBOutlet weak var tableView: UITableView!
    weak var delegate: SamplePickerDelegate?
    var samples = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.backgroundView = UIImageView(image:UIImage(named:"backgroundBlue"))

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
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "SamplePickerTableViewCell", for: indexPath as IndexPath) as? SamplePickerTableViewCell else { return UITableViewCell()}
        cell.filenameLabel.text = "Filename: " + samples[indexPath.row]
        cell.authorLabel.text = "Author: "
        cell.mainView.layer.cornerRadius = 10
        
        TransformAnimator.animateHorizontalAxis(view: cell.contentView)

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        delegate?.replacePadSound(fileName: samples[indexPath.row])
        self.dismiss(animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return samples.count
    }

}
