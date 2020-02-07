//
//  RecordSoundsViewController.swift
//  PitchPerfect
//
//  Created by Pier Lorenzo Paracchini on 24/01/2020.
//  Copyright © 2020 Pier Lorenzo Paracchini. All rights reserved.
//

import UIKit
import AVFoundation

class RecordSoundsViewController: UIViewController, AVAudioRecorderDelegate{
    
    var audioRecorder: AVAudioRecorder!

    @IBOutlet weak var recordingLabel: UILabel!
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var stopRecordingButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        stopRecordingButton.isEnabled = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("func RecordSoundsViewController.viewWillAppear ...")
        // Do any additional staff before the view appears on the screen
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print("func RecordSoundsViewController.viewDidAppear ...")
        // Do any additional staff after the view acually appearss
    }

    @IBAction func recordAudio(_ sender: Any) {
        print("Start Record Audio ...")
        recordingLabel.text = "Recording In Progress"
        stopRecordingButton.isEnabled = true
        recordButton.isEnabled = false
        
        let dirPath = NSSearchPathForDirectoriesInDomains(.documentDirectory,.userDomainMask, true)[0] as String
        let recordingName = "recordedVoice.wav"
        let pathArray = [dirPath, recordingName]
        let filePath = URL(string: pathArray.joined(separator: "/"))
        print(filePath ?? "")

        let session = AVAudioSession.sharedInstance()
        try! session.setCategory(AVAudioSession.Category.playAndRecord, mode: AVAudioSession.Mode.default, options: AVAudioSession.CategoryOptions.defaultToSpeaker)

        try! audioRecorder = AVAudioRecorder(url: filePath!, settings: [:])
        audioRecorder.delegate = self
        audioRecorder.isMeteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record()
    }
    
    @IBAction func stopRecordAudio(_ sender: Any) {
        print("Stop Record Audio ...")
        stopRecordingButton.isEnabled = false
        recordButton.isEnabled = true
        recordingLabel.text = "Tap To Record"
        
        audioRecorder.stop()
        let audioSession = AVAudioSession.sharedInstance()
        try! audioSession.setActive(false)
    }
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        print("Called func audioRecordedDidFinishRecording...")
        if flag {
            print("Move to next View Controller ...")
            performSegue(withIdentifier: "stopRecording", sender: audioRecorder.url)
        }else{
            print("Problem when recording the audio ...")
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "stopRecording"{
            let playSoundsVC = segue.destination as! PlaySoundsViewController
            let recorderAudioURL = sender as! URL
            playSoundsVC.recordedAudioURL = recorderAudioURL
        }
    }
}

