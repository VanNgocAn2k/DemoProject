//
//  TimezoneTableViewCell.swift
//  AppAlarm
//
//  Created by Van Ngoc An  on 08/10/2022.
//

import UIKit

class TimezoneTableViewCell: UITableViewCell {

    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var timeZoneLabel: UILabel!
    
    var timer: Timer?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(setTime), userInfo: nil, repeats: true)
        RunLoop.current.add(timer!, forMode: RunLoop.Mode.common)
        
    }
    @objc func setTime() {
        timeLabel.text = getTime()
    }
    func getTime() -> String {
       var timeString = ""
        if timeZoneLabel.text != "" {
            let formatter = DateFormatter()
            formatter.timeStyle = .long
            formatter.timeZone = TimeZone(identifier: timeZoneLabel.text!)
            let date = Date()
            timeString = formatter.string(from: date)
            
        }
        
        return timeString
    }

    
    
}
    
