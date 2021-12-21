//
//  ViewController.swift
//  Timer
//
//  Created by Hajar Alomari on 15/12/2021.
//

import UIKit
import NotificationCenter


var model = [Notifications]()

let notificationContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

class ViewController: UIViewController {

    @IBOutlet weak var timerPicker: UIDatePicker!
    @IBOutlet weak var currentTaskLabel: UILabel!
    @IBOutlet weak var totalTimeLabel: UILabel!
    @IBOutlet weak var workUntilLabel: UILabel!
    @IBOutlet weak var counterLabel: UILabel!
    
    @IBOutlet weak var pauseBtn: UIButton!
    
    public var completion : ((String, String, Date) -> Void)?
    let notificationCenter = UNUserNotificationCenter.current()
    //declare vars
    
    var timer = Timer()
    var seconds: Double = 0.0
    var totalTimeInSeconds = 0.0
    var isPaused: Bool = false
    var workUntil: String = ""
    var titleString = ""
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
            self?.titleString = text
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
        
        let currentTime = Date(timeIntervalSinceNow: (seconds))
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm a"
        workUntil = formatter.string(from: currentTime)
        print(workUntil)
        
        workUntilLabel.text = "Work Until: \(workUntil)"
        
        //notifications
        
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { permissionsGranted , error in
            
            if permissionsGranted {
                // run notification
                self.scheduleNotification()
            } else if let error = error {
                print("error : \(error.localizedDescription)")
            }
        }
        
        

        
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
                let currentTime = Date(timeIntervalSinceNow: (seconds))
                let formatter = DateFormatter()
                formatter.dateFormat = "HH:mm a"
                workUntil = formatter.string(from: currentTime)
                print(workUntil)
                workUntilLabel.text = "Work Until: \(workUntil)"
                
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
    
    func scheduleNotification(){
        //notification content
        let content = UNMutableNotificationContent()
        content.title = titleString
        content.body = "Work Until: \(workUntil)"
        content.sound = .default
        
        
        // notification trigger
        let targetDate = Date().addingTimeInterval(10)
        let trigger = UNCalendarNotificationTrigger(dateMatching: Calendar.current.dateComponents([.day,.hour,.minute,.second], from: targetDate), repeats: false)
        
        //create a request
        
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request) { error in
            
            if error != nil{
                print("Something went wrong")
            }
        }
        addNofitication(title: titleString, body: "work Until: \(workUntil)", date: targetDate)
    }
    
    func addNofitication(title: String, body: String, date: Date){
        let newNotif = Notifications(context: notificationContext)
        newNotif.title = title
        newNotif.body = body
        newNotif.time = date
        do{
            try notificationContext.save()
         
        }catch{
            //error handling
        }
    }
}



