//
//  Day.swift
//  AppAlarm
//
//  Created by Van Ngoc An  on 08/10/2022.
//

import Foundation
import RealmSwift

@objc class Alarm: Object {
//    @Persisted var timeAlarm: Date?
//    @Persisted var repeatAlarm: List<String>
//    @Persisted var labelAlarm: String?
//    @Persisted var soundAlarm: String?
//    @objc dynamic var timeAlarm: Date?
//    @objc dynamic var repeatAlarm: [String] = []
    @objc dynamic var time: String = ""
    @objc dynamic var labelAlarm: String = ""
    @objc dynamic var repeatAlarm: String = ""
    @objc dynamic var soundAlarm: String = ""
    @objc dynamic var isEnable: Bool
//    @objc dynamic var time: String?
//    @objc dynamic var labelAlarm: String?
//    @objc dynamic var repeatAlarm: String?
//    @objc dynamic var soundAlarm: String?
//    @objc dynamic var isEnable: Bool
    
    override init() {
        self.soundAlarm = ""
        self.time = ""
        self.labelAlarm = ""
        self.repeatAlarm = ""
        self.isEnable = true
    }
    init(time: String, labelAlarm: String, repeatAlarm: String, soundAlarm: String, isEnable: Bool) {
        self.soundAlarm = soundAlarm
        self.time = time
        self.labelAlarm = labelAlarm
        self.repeatAlarm = repeatAlarm
        self.isEnable = isEnable
    }
    
}


