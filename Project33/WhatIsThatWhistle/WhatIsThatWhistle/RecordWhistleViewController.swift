//
//  RecordWhistleViewController.swift
//  WhatIsThatWhistle
//
//  Created by Ben Hall on 20/04/2018.
//  Copyright © 2018 BeshBashBosh. All rights reserved.
//

import UIKit
import AVFoundation // Audio-Visual apple framework

class RecordWhistleViewController: UIViewController, AVAudioRecorderDelegate {

    // MARK: - Properties
    var stackView: UIStackView!
    var recordButton: UIButton!
    var recordingSession: AVAudioSession! // Handles a recording session
    var whistleRecorder: AVAudioRecorder! // Does the actual data acquisition
    
    var playButton: UIButton! // Button to replay recordings
    var whistlePlayer: AVAudioPlayer!
    
    // MARK: - Actions
    @objc func recordTapped() {
        if whistleRecorder == nil {
            startRecording()
            // Started recording so hide the play button (if it shown)
            if !playButton.isHidden {
                UIView.animate(withDuration: 0.35) { [unowned self] in
                    self.playButton.isHidden = true
                    self.playButton.alpha = 0
                }
            }
        } else {
            finishRecording(success: true)
        }
    }
    
    @objc func nextTapped() {
        
    }
    
    // Playback of recording
    @objc func playTapped() {
        let audioURL = RecordWhistleViewController.getWhistleURL() // Get where the recording was saved
        
        do {
            whistlePlayer = try AVAudioPlayer(contentsOf: audioURL) // try to read the contents of the URL
            whistlePlayer.play() // Play it!
        } catch {
            // Failed, alert the user
            let ac = UIAlertController(title: "Playback Failed",
                                       message: "There was a problem playing the audio recording, please try again.",
                                       preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
        }
    }
    
    // MARK: - Custom Methods
    // Create a UI for enabling recording audio
    func loadRecordingUI() {
        // Add a UIButton to view to start recording
        recordButton = UIButton()
        recordButton.translatesAutoresizingMaskIntoConstraints = false // View will be added to hierarchy using autolayout.
        recordButton.setTitle("Tap to Record", for: .normal) // What does the button say?
        recordButton.titleLabel?.font = UIFont.preferredFont(forTextStyle: .title1) // What font is the button?
        recordButton.addTarget(self, action: #selector(recordTapped), for: .touchUpInside) // What does pressing the button do?
        stackView.addArrangedSubview(recordButton) // Add button to stackView
        
        // Add the replay button
        playButton = UIButton()
        playButton.translatesAutoresizingMaskIntoConstraints = false
        playButton.setTitle("Tap to Play", for: .normal)
        playButton.isHidden = true // Start play button as hidden... (THIS REMOVES THE VIEW FROM TAKING UP SPACE IN THE STACKVIEW)
        playButton.alpha = 0 // and completely transparent. (THIS STOPS THE VIEW FROM BEING VISIBLE AT START WHEN WE ANIMATE IT IN)
        playButton.titleLabel?.font = UIFont.preferredFont(forTextStyle: .title1)
        playButton.addTarget(self, action: #selector(playTapped), for: .touchUpInside)
        stackView.addArrangedSubview(playButton)
    }
    
    // Create a UI telling the user recording not possible
    func loadFailUI() {
        let failLabel = UILabel()
        failLabel.font = UIFont.preferredFont(forTextStyle: .headline) // Font style of the label
        failLabel.text = "Recording failed: please ensure app has access to your microphone." // what does the label say
        failLabel.numberOfLines = 0 // Multiline label
        stackView.addArrangedSubview(failLabel) // add to stackview
    }
    
    // Helper method for getting apps document directory (class func, so call on class not instance of class)
    class func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentsDirectory = paths[0]
        return documentsDirectory
    }
    
    // Creates a URL to save the audio recording to
    class func getWhistleURL() -> URL {
        return getDocumentsDirectory().appendingPathComponent("whistle.m4a")
    }
    
    func startRecording() {
        // 1. Make view have red background so user knows in recording state
        view.backgroundColor = UIColor(red: 0.6, green: 0, blue: 0, alpha: 1)
        // 2. Change button to say "Tap to Stop"
        recordButton.setTitle("Tap to Stop", for: .normal)
        // 3. Call getWhistleURL to get file+loc to save recording to
        let audioURL = RecordWhistleViewController.getWhistleURL()
        print(audioURL.absoluteURL)
        // 4. Create a settings dictionary describing the recording
        let settings = [
            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
            AVSampleRateKey: 12000,
            AVNumberOfChannelsKey: 1,
            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
        ]
        // 5. create AVAudioRecorder with settings at file URL, set delegate, and call record()
        do {
            whistleRecorder = try AVAudioRecorder(url: audioURL, settings: settings)
            whistleRecorder.delegate = self
            whistleRecorder.record()
        } catch {
            finishRecording(success: false)
        }
    }
    
    func finishRecording(success: Bool) {
        view.backgroundColor = UIColor(red: 0, green: 0.6, blue: 0, alpha: 1) // Set color to green
        whistleRecorder.stop() // Stop the recording
        whistleRecorder = nil // unintialise the recorder
        
        if success { // recording successful
            recordButton.setTitle("Tap to Re-record", for: .normal) // set button to re-record
            // navbar option for proceeding with recording
            navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Next", style: .plain, target: self, action: #selector(nextTapped))
        } else { // recording failed
            recordButton.setTitle("Tap to Record", for: .normal) // reset recording button to record
            let ac = UIAlertController(title: "Recording failed", message: "There was a problem recording your whistle; please try again.",
                                       preferredStyle: .alert) // invoke alert controller alerting user recording failed
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
        }
        
        // Finished recording so now display the replay button (animate it)
        if playButton.isHidden {
            UIView.animate(withDuration: 0.35) { [unowned self] in
                self.playButton.isHidden = false
                self.playButton.alpha = 1
            }
        }
    }
    
    // MARK: - AVAudioRecorder delegate methods
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        // If recording failed we need to handle that correctly
        if !flag { finishRecording(success: false) }
    }
    
    // MARK: - VC Lifecycle methods
    // Do all view loading in code
    override func loadView() {
        super.loadView()
        
        view.backgroundColor = .gray // set color of main view
        
        // Create the stackview
        stackView = UIStackView()
        stackView.spacing = 30
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.distribution = .fillEqually
        stackView.alignment = .center
        stackView.axis = .vertical
        view.addSubview(stackView)
        
        // Constraints for stackview
        stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        // Navbar setup
        title = "Record your whistle"
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "Record", style: .plain,
                                                           target: nil, action: nil)
        
        // Set-up recording session
        recordingSession = AVAudioSession.sharedInstance()
        
        // Attempt requesting recording priveleges
        do {
            try recordingSession.setCategory(AVAudioSessionCategoryPlayAndRecord)
            try recordingSession.setActive(true)
            recordingSession.requestRecordPermission() { [unowned self] allowed in
                DispatchQueue.main.async {
                    if allowed {
                        self.loadRecordingUI()
                    } else {
                        self.loadFailUI()
                    }
                }
            }
        } catch {
            self.loadFailUI()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
