//
//  ViewController.swift
//  EggTimer
//
//  Created by Angela Yu on 08/07/2019.
//  Copyright © 2019 The App Brewery. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var progressBar: UIProgressView! 
    
    
    /* Alternative way
     let softTime = 5
     let mediumTime = 7
     let hardTime = 12
     */
    // With using Dictionary
    let eggTimes = ["Soft": 10, "Medium": 7, "Hard": 5] //Named same as Buttons so it matches automatically
        // 5 7 12
    var counter: Int = 0
    var secondsPassed = 0
    var eggType: String = ""
    
    
    // **************************** TIMER SETTINGS ******************
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateCounter), userInfo: nil, repeats: true)
    }
    
    // *************************** ALARM SOUND ************************
    var player: AVAudioPlayer?

    func playSound() {
        guard let url = Bundle.main.url(forResource: "alarm_sound", withExtension: "mp3") else { return }

        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)

            player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.mp3.rawValue)

            guard let player = player else { return }

            player.play()

        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    
    
    
    
    
    // ********************** PROGRESS BAR ****************************
    
    @objc func updateCounter() {
        //updating progress bar
        if secondsPassed <= counter {
            let percentageProgress = Float(secondsPassed) / Float(counter)
            secondsPassed += 1
            progressBar.progress = percentageProgress
            
        } else {
            titleLabel.text = "Done!"
            playSound()
        }
    }
    
    // *********************** WHEN USER PRESSES BUTTON ************************
    
    @IBAction func hardnessSelect(_ sender: UIButton) {
        let hardness = sender.currentTitle! // returns; Soft, Medium or Hard
        eggType = sender.currentTitle!
        print("Starting timer for \(eggType)")
        counter = eggTimes[hardness]!
        progressBar.progress = 0.0
        secondsPassed = 0
        titleLabel.text = hardness
        
    }
    
    
}
