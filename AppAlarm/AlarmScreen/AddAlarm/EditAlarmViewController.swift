//
//  EditAlarmViewController.swift
//  AppAlarm
//
//  Created by Van Ngoc An  on 24/09/2022.
//

import UIKit
import UserNotifications

class EditAlarmViewController: UIViewController, UNUserNotificationCenterDelegate {
    var hour: String = ""
    var minutes: String = ""
    var weekdays: [String] = ["Thứ 2", "Thứ 3", "Thứ 4", "Thứ 5", "Thứ 6", "Thứ 7", "CN"]
    var snoozeEnable = false
    var delegate: timelabelRepeatDelegate?
    
    var repeats: [Int] = []
    var currentSound: String = ""
    var labelAlarm2 = ""
    var repeatText = ""
    var selectedHour: String = "00"
    var selectedMinute: String = "00"
    var time: String = ""
    
    
    var objectAlarm = Alarm()
    
    
   
    
    @IBOutlet weak var picker: UIPickerView!
    
    @IBOutlet weak var repeatLabel: UILabel!
    @IBOutlet weak var labelAlarmLabel: UILabel!
    
    @IBOutlet weak var soundAlarmLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        objectAlarm = Alarm(time: time, labelAlarm: labelAlarm2, repeatAlarm: repeatText, soundAlarm: currentSound, isEnable: true)
//        repeatLabel.text = objectAlarm.repeatAlarm
//        labelAlarmLabel.text = objectAlarm.labelAlarm
//        soundAlarmLabel.text = objectAlarm.soundAlarm
//        print(objectAlarm.repeatAlarm)
        print(objectAlarm.repeatAlarm)
        
        
        pickerSetup()
    }
    
    @IBAction func repeatButtonAction(_ sender: Any) {
        self.performSegue(withIdentifier: "repeatVC", sender: nil)
    }
       
    @IBAction func labelAlarmButtonAction(_ sender: Any) {
        self.performSegue(withIdentifier: "labelVC", sender: nil)
    }
   
    @IBAction func soundButtonAction(_ sender: Any) {
        self.performSegue(withIdentifier: "soundVC", sender: nil)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "labelVC" {
            if let vc = segue.destination as? LabelViewController {
                vc.delegateLabel = self
                
            }
        } else  if segue.identifier == "soundVC" {
            if let vc = segue.destination as? SoundViewController {
                vc.delegate = self
            }
        } else  if segue.identifier == "repeatVC" {
            if let vc = segue.destination as? RepeatViewController {
                vc.delegate = self
            }
        }
        
    }

    @IBAction func snoozeSwitchAction(_ sender: UISwitch) {
        snoozeEnable = sender.isOn
    }
    
    
    @IBAction func dismissButtonAction(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func saveButtonAction(_ sender: UIBarButtonItem) {
        
        //MARK: - Delegate
        if hour == "0"{
            hour = "00"
        } else{
            if (Int(hour) ?? 1) < 10 && hour != "0"{
                hour = "0" + hour
            }
        }
        if minutes == "0"{
            minutes = "00"
        } else {
            if (Int(minutes) ?? 1) < 10 && minutes != "0" {
                minutes = "0" + minutes
            }
        }
        let element: String = "\(hour):\(minutes)"
        self.time = element
        
        if repeats.count == 0 {
            delegate?.setTimeLabelRepeatAlarm(time: element, labelAlarm: labelAlarm2.count == 0 ? "Báo thức" : labelAlarm2, repeatAlarm:  "")
        } else if repeats.count == 7 {
            delegate?.setTimeLabelRepeatAlarm(time: element, labelAlarm: labelAlarm2.count > 0 ? "\(labelAlarm2), " : labelAlarm2, repeatAlarm: "Hàng ngày")
        } else {
            delegate?.setTimeLabelRepeatAlarm(time: element, labelAlarm: labelAlarm2, repeatAlarm: ",\(repeatText)")
        }
        
        // Realm
        let newAlarm = Alarm(time: element, labelAlarm: labelAlarm2, repeatAlarm: repeatText, soundAlarm: currentSound, isEnable: true)
//        print(newAlarm)
        Manager.shared.addNewAlarm(alarm: newAlarm)
        self.objectAlarm = newAlarm
        print(objectAlarm)

        
        
        
//        // Notification
//        //Create Date from picker selected value.
//           func createDate(weekday: Int, hour: Int, minute: Int, year: Int)->Date{
//
//               var components = DateComponents()
//               components.hour = hour
//               components.minute = minute
//               components.year = year
//               components.weekday = weekday // sunday = 1 ... saturday = 7
//               components.weekdayOrdinal = 10
//               components.timeZone = .current
//
//               let calendar = Calendar(identifier: .gregorian)
//               return calendar.date(from: components)!
//           }
//
//           //Schedule Notification with weekly bases.
//           func scheduleNotification(at date: Date, body: String, titles:String) {
//
//               let triggerWeekly = Calendar.current.dateComponents([.weekday,.hour,.minute,.second,], from: date)
//
//               let trigger = UNCalendarNotificationTrigger(dateMatching: triggerWeekly, repeats: true)
//
//               let content = UNMutableNotificationContent()
//               content.title = titles
//               content.body = body
//               content.sound = UNNotificationSound.default
////               content.categoryIdentifier = "todoList"
//
//               let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
//
//               UNUserNotificationCenter.current().delegate = self
//               UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
//               UNUserNotificationCenter.current().add(request) {(error) in
//                   if let error = error {
//                       print("Uh oh! We had an error: \(error)")
//                   }
//               }
//           }
        
        dismiss(animated: true, completion: nil)
        
    }

    func pickerSetup(){
        picker.delegate = self
        picker.dataSource = self
        picker.frame = CGRect(x: 50, y: 70, width: self.view.frame.width - 100, height: 200)
        picker.setValue(UIColor.white, forKey: "textColor")
        picker.selectRow(Int(selectedHour) ?? 0, inComponent: 0, animated: true)
        picker.selectRow(Int(selectedMinute) ?? 0, inComponent: 1, animated: true)
        view.addSubview(picker)
    }
}


extension EditAlarmViewController: UIPickerViewDataSource, UIPickerViewDelegate{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch component {
        case 0:
            return 24
        case 1:
            return 60
        default:
            return 0
        }
        
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch component {
        case 0:
            if row < 10 {
                return "0\(row)"
            } else {
                return "\(row)"
            }
            
        case 1:
            if row < 10 {
                return "0\(row)"
            } else {
                return "\(row)"
            }
        default:
            return nil
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch component {
                case 0:
                    hour = "\(row)"
                
                case 1:
                    minutes = "\(row)"
                default:
                    break;
                }
    }
}
extension EditAlarmViewController: PassLabelDelegate, PassSoundAlarmDelegate, RepeatViewControllerdelgate {

    func pickRepeat(repeats: [Int]) {
        
        let string = repeats.map { weekdays[$0] }.joined(separator: " ")
        if repeats.count == 0 {
            repeatLabel.text = "Không"
        } else if repeats.count == 7 {
            repeatLabel.text = "Hàng ngày"
        } else {
            repeatLabel.text = string
        }
        self.repeatText = string
        self.repeats = repeats
    }
    
    func updateLabelAlarm(labelAlarm: String) {
        labelAlarmLabel.text = labelAlarm
        self.labelAlarm2 = labelAlarm
    }
    func updateSuond(sound: String) {
        soundAlarmLabel.text = sound
        self.currentSound = sound
    }
}
