//
//  NotificationsTableViewController.swift
//  Timer
//
//  Created by Hajar Alomari on 21/12/2021.
//

import UIKit
import UserNotifications



class NotificationsTableViewController: UITableViewController {
    
   
   

    override func viewDidLoad() {
        super.viewDidLoad()
            
        fetchData()
       
        }
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return model.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! NotificationsTableViewCell
        let notify = model[indexPath.row]
        
        if notify.title != nil && notify.body != nil && notify.time != nil {
            cell.setNotification(title: notify.title!, body: notify.body! , date: notify.time!)
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { permissionsGranted , error in
            
            if permissionsGranted {
                // run notification
                self.scheduleNotification()
            } else if let error = error {
                print("error : \(error.localizedDescription)")
            }
        }
    }
    
    func scheduleNotification(){
        //notification content
        let content = UNMutableNotificationContent()
        content.title = "Notification Title"
        content.body = "Content Body"
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
    }
    
    
    func fetchData(){
        do{
            try model = notificationContext.fetch(Notifications.fetchRequest())
            tableView.reloadData()
        }catch{
            print("Failed to fetch data")
        }
    }

    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
