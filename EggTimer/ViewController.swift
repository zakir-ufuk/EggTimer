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
    @IBOutlet weak var stopTimerButton: UIButton!
    @IBOutlet weak var timeLeft: UILabel!
    
    /* Alternative way
     let softTime = 5
     let mediumTime = 7
     let hardTime = 12
     */
    // With using Dictionary
    let eggTimes = ["Soft": 10, "Medium": 7, "Hard": 5] //Named same as Buttons so it matches automatically
    // 5 7 12
    var totalTime: Int = 0
    var secondsPassed = 0
    var eggType: String = ""
    var timer = Timer()
    var player: AVAudioPlayer!
    
    
    // ********************** HOW THE PROGRAM LOADS / START UP SETTINGS **********************
    override func viewDidLoad() {
        super.viewDidLoad()
        timeLeft.isHidden = true
        titleLabel.font = .boldSystemFont(ofSize: 30)
        stopTimerButton.isHidden = true
        stopTimerButton.layer.cornerRadius = 15
        timeLeft.font = .boldSystemFont(ofSize: 40)
        progressBar.setProgress(0, animated: false)
        // rounded edges for progressBar
        progressBar.layer.cornerRadius = 11
        progressBar.clipsToBounds = true
    }
    
    // ********************** WHEN USER SELECTS HARDNESS **********************
    
    @IBAction func hardnessSelect(_ sender: UIButton) {
        if progressBar.progress == 0 //fixes bug where you can start two Timers at the same time!
        { let hardness = sender.currentTitle! // returns; Soft, Medium or Hard
            timer.invalidate() //invalidate timer before it starts a new one on pressing button
            titleLabel.font = .boldSystemFont(ofSize: 50)
            eggType = sender.currentTitle!
            print("Starting timer for \(eggType)")
            totalTime = eggTimes[hardness]!
            progressBar.setProgress(0, animated: true) //set progress back to zero
            secondsPassed = 0
            titleLabel.font = .boldSystemFont(ofSize: 30)
            titleLabel.text = "\(hardness) eggs coming up!"
            timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateCounter), userInfo: nil, repeats: true)
            
        }
        else
        {
            print("Player is playing")
        }
        
        
    }
    // *********************** AFTER USER SELECTS HARDNESS (COUNTER GOING DOWN) **********************
    @objc func updateCounter() {
        if secondsPassed < totalTime {
            
            secondsPassed += 1
            
            progressBar.setProgress(Float(secondsPassed) / Float(totalTime), animated: true)
            
            print(Float(secondsPassed) / Float(totalTime))
            
            timeLeft.isHidden = false
            
            //      timeLeft.text = String((totalTime) - (secondsPassed))
            //UPDATE UI LAbel with minutes and seconds!!!
            let i = ((totalTime) - (secondsPassed))
            timeLeft.text = String(timeString(time: TimeInterval(i))) //isnt upda
        }
        
        else {
            // ********************** WHEN EGGS ARE READY (REMANINING TIME 0) **********************
            timer.invalidate()
            titleLabel.font = .boldSystemFont(ofSize: 30)
            titleLabel.text = String("Egg's are Ready!!!")
            playSound(soundName: "alarm_sound")
            stopTimerButton.isHidden = false
            timeLeft.text = ""
            timeLeft.font = .boldSystemFont(ofSize: 40)
            
            //FLASH ANIMATION WHEN EGGS ARE READY
            UIView.animate(withDuration: 0.5, delay: 0.25, options: [.repeat, .autoreverse], animations: {
                self.titleLabel.alpha = 0
            }, completion: nil)
        }
    }
    
    
    // ********************** SOUND SETTINGS **********************
    func playSound(soundName: String) {
        let url = Bundle.main.url(forResource: soundName, withExtension: "mp3")
        self.player = try! AVAudioPlayer(contentsOf: url!)
        self.player.play()
        self.player.numberOfLoops = -1
        
    }
    
    func stopSound() {
        player.stop()
    }
    // ********************** DISPLAYED TIME LEFT (CONVERTION) **********************
    func timeString(time: TimeInterval) -> String {
        //            let hour = Int(time) / 3600
        let minute = Int(time) / 60 % 60
        let second = Int(time) % 60
        
        // return formated string
        return String(format: "%02i:%02i", minute, second)
    }
    
    // ********************** WHEN USER PRESSES STOP TIMER BUTTON **********************
    @IBAction func stopTimer(_ sender: UIButton) {
        stopSound() //stops sound
        //returns back to starting point
        stopTimerButton.isHidden = true
        progressBar.setProgress(0, animated: true)
        secondsPassed = 0
        titleLabel.text = "How do you like your eggs?"
        timeLeft.isHidden = true
        titleLabel.alpha = 1
    }
    
    
}

