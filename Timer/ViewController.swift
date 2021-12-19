//
//  ViewController.swift
//  Timer
//
//  Created by Hajar Alomari on 15/12/2021.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var timerPicker: UIDatePicker!
    @IBOutlet weak var currentTaskLabel: UILabel!
    @IBOutlet weak var totalTimeLabel: UILabel!
    @IBOutlet weak var workUntilLabel: UILabel!
    @IBOutlet weak var counterLabel: UILabel!
    
    @IBOutlet weak var pauseBtn: UIButton!
    //declare vars
    
    var timer = Timer()
    var seconds: Double = 0.0
    var totalTimeInSeconds = 0.0
    var isPaused: Bool = false
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        //barBtnTapped()
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(barBtnTapped))
       
    }

    @objc func barBtnTapped() {
        let alert = UIAlertController(title: "New Task", message: "Enter new Task", preferredStyle: .alert)
        
        alert.addTextField(configurationHandler: nil)
        
        alert.addAction(UIAlertAction(title: "Submit", style: .cancel, handler: {[weak self]_ in
            guard  let field = alert.textFields?.first, let text = field.text, !text.isEmpty else{
                return
            }
            self?.currentTaskLabel.text = text
            self?.totalTimeLabel.text = "Total Time: 00:00:00"
            self?.counterLabel.text = "00:00:00"
            self?.seconds = 0.0
            self?.totalTimeInSeconds = 0.0
           
        }))
        present(alert, animated: true)
    }

    @IBAction func startBtnPressed(_ sender: UIButton) {
        //print(timerPicker.countDownDuration)
        seconds = timerPicker.countDownDuration
       
        let timeFormated = timeFormatterToString(time: seconds)
        counterLabel.text = timeFormated
        
        
        
        //in order to prevent two timers from working on the same time
        timer.invalidate()
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(countDownTimer), userInfo: nil, repeats: true)
    }
    @IBAction func pauseBtnPressed(_ sender: UIButton) {
        //create an if statement to check if paused then resume
        if isPaused {
          
            if seconds  == 0 {
                pauseBtn.isEnabled = false
            } else{
                pauseBtn.setTitle("Pause", for: .normal)
                let timeFormated = timeFormatterToString(time: seconds)
                counterLabel.text = timeFormated
                timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(countDownTimer), userInfo: nil, repeats: true)
                
            }
            isPaused = false
        } else{
        timer.invalidate()
        pauseBtn.setTitle("Resume", for: .normal)
        totalTimeLabel.text = "Total Time: \(timeFormatterToString(time: totalTimeInSeconds))"
            isPaused = true
        }
       
       
    }
    
    
    @objc func countDownTimer(){
        if seconds == 0{
            timer.invalidate()
            totalTimeLabel.text = "Total Time: \(timeFormatterToString(time: totalTimeInSeconds))"
            
        } else{
        seconds -= 1
        totalTimeInSeconds += 1
        let timeFormated = timeFormatterToString(time: seconds)
        counterLabel.text = timeFormated
        }
    }
    
    func timeFormatterToString(time: TimeInterval) -> String{
        //Time Counter
        let hours = Int(time) / 3600
        let minutes = Int(time) / 60 % 60
        let seconds = Int(time) % 60
        let timeCounter = String(format: "%02i:%02i:%02i" , hours, minutes, seconds)
        
    
        return timeCounter
    }
    
}



