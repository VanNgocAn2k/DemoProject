//
//  AlarmInfo.swift
//  AppAlarm
//
//  Created by Van Ngoc An  on 08/10/2022.
//

import Foundation
import RealmSwift

class Manager {
    static let shared = Manager()
    
    var realm: Realm!
    init() {
        realm = try! Realm()
    }
    // lấy ra
    func getAllAlarm() -> [Alarm] {
        let objects = realm.objects(Alarm.self)
        return Array(objects)
    }
    // thêm mới
    func addNewAlarm(alarm: Alarm) {
        do {
            try realm.write({
                realm.add(alarm)
            })
        } catch let error {
            print("Cannot add this alarm, \(error.localizedDescription)")
        }
    }
    // sửa alarm
    func updateAlarm(alarm: Alarm, newTime: String, newRepeat: String, newLabel: String, newSound: String) {
        do {
            try realm.write({
                alarm.time = newTime
                alarm.repeatAlarm = newRepeat
                alarm.labelAlarm = newLabel
                alarm.soundAlarm = newSound
            })
        } catch let error {
            print("Cannot add this alarm, \(error.localizedDescription)")
        }
    }
    // Xoá alarm
    func removeAlarm(alarm: Alarm) {
        do {
            try realm.write({
                realm.delete(alarm)
            })
        } catch let error {
            print("Cannot add this alarm, \(error.localizedDescription)")
        }
    }
}

