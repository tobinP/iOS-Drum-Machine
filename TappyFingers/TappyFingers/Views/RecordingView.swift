//
//  RecordingView.swift
//  TappyFingers
//
//  Created by Tobin Pomeroy on 3/7/18.
//  Copyright © 2018 Tobin Pomeroy. All rights reserved.
//

import UIKit
import AVFoundation

class RecordingView: UIView {

    // MARK: IB Outlets
    
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var recordingIndicatorLight: UIView!
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var sampleTextField: UITextField!
    
    var recordingSession: AVAudioSession!
    var audioRecorder: AVAudioRecorder!
    var audioPlayer = AVAudioPlayer()
    
    // MARK: IB Actions
    
    @IBAction func recordButtonTapped(_ sender: UIButton) {
        guard let fileName = sampleTextField.text, fileName != "" else { return }
        if audioRecorder == nil {
            startRecording(fileName: fileName)
            recordingIndicatorLight.backgroundColor = .red
        } else {
            finishRecording(success: true)
            recordingIndicatorLight.backgroundColor = .lightGray
        }
    }
    
    @IBAction func playButtonTapped(_ sender: UIButton) {
        guard let fileName = sampleTextField.text, fileName != "" else { return }
        playRecordedSample(fileName: fileName)
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
        setupRecordingSession()
        setupView()
    }
    
    func setupView() {
        Bundle.main.loadNibNamed("RecordingView", owner: self, options: nil)
        addSubview(contentView)
        contentView.translatesAutoresizingMaskIntoConstraints = false
        contentView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        contentView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        contentView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        contentView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
    }
    
    // MARK: Audio Recording Methods
    
    func setupRecordingSession() {
        recordingSession = AVAudioSession.sharedInstance()
        
        do {
            try recordingSession.setCategory(AVAudioSessionCategoryPlayAndRecord)
            try recordingSession.setActive(true)
            recordingSession.requestRecordPermission() { [] allowed in
                if allowed {
                    print("is allowed")
                    
                } else {
                    print("not allowed")
                }
            }
        } catch {
            print("failed to setup recorder")
        }
    }
    
    func startRecording(fileName: String) {
        let audioFilename = URL.getDocumentsDirectory().appendingPathComponent(fileName + ".m4a")
        
        let settings = [
            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
            AVSampleRateKey: 12000,
            AVNumberOfChannelsKey: 1,
            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
        ]
        
        do {
            audioRecorder = try AVAudioRecorder(url: audioFilename, settings: settings)
            audioRecorder.delegate = self
            audioRecorder.record()
            
            recordButton.setTitle("Stop recording", for: .normal)
        } catch {
            finishRecording(success: false)
        }
    }
    
    func finishRecording(success: Bool) {
        audioRecorder.stop()
        audioRecorder = nil
        
        if success {
            recordButton.setTitle("Start recording", for: .normal)
        } else {
            recordButton.setTitle("Failed recording", for: .normal)
        }
    }
    
    func playRecordedSample(fileName: String) {
        
        guard let soundURL = URL.getFileURL(fileName: fileName + ".m4a") else { return }
        
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: soundURL as URL)
            audioPlayer.prepareToPlay()
        } catch {
            print("Problem getting File")
        }
        
        audioPlayer.currentTime = 0
        audioPlayer.play()
    }
}

extension RecordingView: AVAudioRecorderDelegate {
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if !flag {
            finishRecording(success: false)
        }
    }
}
