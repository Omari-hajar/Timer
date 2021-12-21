//
//  NotificationsTableViewCell.swift
//  Timer
//
//  Created by Hajar Alomari on 21/12/2021.
//

import UIKit

class NotificationsTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var dateLabel: UILabel!
    
    @IBOutlet weak var bodyLabel: UILabel!
    
    func setNotification(title: String, body: String, date: Date){
        titleLabel.text = title
        bodyLabel.text = body
        
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd/yyyy"
        let date  = formatter.string(from: date)
        
        dateLabel.text = date
        
    }
}
