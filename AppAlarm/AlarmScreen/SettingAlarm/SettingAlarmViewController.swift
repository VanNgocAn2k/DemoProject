//
//  SettingAlarmViewController.swift
//  AppAlarm
//
//  Created by Van Ngoc An  on 24/09/2022.
//

import UIKit


protocol timelabelRepeatDelegate {
    func setTimeLabelRepeatAlarm(time: String, labelAlarm: String, repeatAlarm: String)
    
}

class SettingAlarmViewController: UIViewController {
    
//    var timeArray: [AlarmClock] = [AlarmClock]()
    var arrData = [Alarm]()
    
    @IBOutlet weak var alarmTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        alarmTableView.tableFooterView = UIView()
        self.alarmTableView.dataSource = self
        self.alarmTableView.delegate = self
        
        self.registerTableViewCells()
        fetchData()
    }
    
    func fetchData() {
        arrData = Manager.shared.getAllAlarm()
        alarmTableView.reloadData()
    }
    
    @IBAction func editBarButtonAction(_ sender: Any) {
        alarmTableView.isEditing = !alarmTableView.isEditing
        
    }
    
    //MARK: - add new alarm clock
    @IBAction func addBarButtonAction(_ sender: UIBarButtonItem) {
        self.performSegue(withIdentifier: "showVC", sender: nil)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showVC" {
            if let vc = segue.destination as? EditAlarmViewController {
                vc.delegate = self
            }
        }
    }
    private func registerTableViewCells(){
        let alarmCell = UINib(nibName: "CustomTableViewCell", bundle: nil)
        self.alarmTableView.register(alarmCell, forCellReuseIdentifier: "CustomTableViewCell")
    }
}

extension SettingAlarmViewController: timelabelRepeatDelegate{
    func setTimeLabelRepeatAlarm(time: String, labelAlarm: String, repeatAlarm: String) {
        
//        let timeLabelRepeat = AlarmClock(time: time, labelAlarm: labelAlarm, repeatAlarm: repeatAlarm, isEnable: true)
//        timeArray.append(timeLabelRepeat)
        let timeLabelRepeat2 = Alarm(time: time, labelAlarm: labelAlarm, repeatAlarm: repeatAlarm, soundAlarm: "", isEnable: true)
        arrData.append(timeLabelRepeat2)
        self.alarmTableView.reloadData()
    }
}
extension SettingAlarmViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrData.count
//        return timeArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "CustomTableViewCell", for: indexPath) as? CustomTableViewCell{
            let object = arrData[indexPath.row]
            cell.timeLabel.text = object.time
            cell.labelRepeatAlarmLabel.text = "\(object.labelAlarm) \(object.repeatAlarm)"
//            cell.timeLabel.text = timeArray[indexPath.row].time
//            cell.labelRepeatAlarmLabel.text = "\(timeArray[indexPath.row].labelAlarm) \(timeArray[indexPath.row].repeatAlarm)"
            let backgroundView = UIView()
            backgroundView.backgroundColor = UIColor.black
            cell.selectedBackgroundView = backgroundView
            return cell
        }
        return UITableViewCell()
    }
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteButton = UIContextualAction(style: .destructive, title: "Delete") { _, _, _ in
//            // xóa phần tử tại indexPath.row
//            self.arrData.remove(at: indexPath.row)
//            tableView.reloadData() // đổ lại dữ liệu cho tableView
//            // đổ lại dữ liệu cho một mảng section
////            tableView.reloadSections([indexPath.section], with: .left)
            let deleteAlarm = self.arrData[indexPath.row]
            Manager.shared.removeAlarm(alarm: deleteAlarm)
            self.fetchData()
        }
        deleteButton.backgroundColor = .red
        return UISwipeActionsConfiguration(actions: [deleteButton])
    }
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete{
//            timeArray.remove(at: indexPath.row)
            arrData.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .left)
        }
    }
    func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to toIndexPath: IndexPath) {
        
//        let affectedEvent = timeArray[fromIndexPath.row]
//        timeArray.remove(at: fromIndexPath.row)
//        timeArray.insert(affectedEvent, at: toIndexPath.row)
        let affectedEvent = arrData[fromIndexPath.row]
        arrData.remove(at: fromIndexPath.row)
        arrData.insert(affectedEvent, at: toIndexPath.row)
        
        tableView.reloadData()
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        self.performSegue(withIdentifier: "showVC", sender: nil)

        func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            if segue.identifier == "showVC" {
                if let vc = segue.destination as? EditAlarmViewController {
////                    vc.objectAlarm = arrData[indexPath.row].time
////                    vc.selectedMinute = timeArray[indexPath.row].time
//                    vc.minutes = arrData[indexPath.row].time
//                    vc.hour = arrData[indexPath.row].time
//                    vc.objectAlarm.repeatAlarm = arrData[indexPath.row].repeatAlarm
//                    vc.objectAlarm.repeatAlarm = "arrData[indexPath.row].repeatAlarm"
//                    print(arrData[indexPath.row].repeatAlarm)
////                    vc.objectAlarm.labelAlarm = arrData[indexPath.row].labelAlarm
//                    vc.objectAlarm.labelAlarm = "arrData[indexPath.row].labelAlarm"
//                    print(arrData[indexPath.row].labelAlarm)
////                    vc.objectAlarm.soundAlarm = arrData[indexPath.row].soundAlarm
//                    vc.objectAlarm.soundAlarm = "arrData[indexPath.row].soundAlarm"
//                    print(arrData[indexPath.row].soundAlarm)
//                    vc.objectAlarm?.repeatAlarm = arrData[indexPath.row]
//                    vc.objectAlarm?.labelAlarm = arrData[indexPath.row].labelAlarm
                    vc.objectAlarm = arrData[indexPath.row]
                    vc.objectAlarm.time = "\(arrData[indexPath.row].time)"
                    vc.objectAlarm.repeatAlarm = "\(arrData[indexPath.row])"
                }
            }
        }
    }
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//            self.performSegue(withIdentifier: "showVC", sender: nil)
//            print(arrData[indexPath.row].time)
//            print(arrData[indexPath.row].repeatAlarm)
//            print(arrData[indexPath.row].labelAlarm)
//            print(arrData[indexPath.row].soundAlarm)
//
//        }
}
