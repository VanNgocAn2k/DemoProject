//
//  ViewController.swift
//  AppAlarm
//
//  Created by Van Ngoc An  on 24/09/2022.
//


import UIKit
import UserNotifications


enum TimerState {
    case starting
    case paused
    case continued
    case cancelled
}

class ViewController: UIViewController, UNUserNotificationCenterDelegate {
    
    let notificationCenter = UNUserNotificationCenter.current()
    
    var timer: Timer?
    var runTimer = false
    var timeLeft = 0
    var currentState: TimerState = .cancelled {
        didSet {
            self.configState()
        }
    }
    @IBOutlet weak var containerCancelButtonView: UIView!
    @IBOutlet weak var containerStartButtonView: UIView!
    
    @IBOutlet weak var timeNotificationView: UIView!
    
    @IBOutlet weak var timeNotiLabel: UILabel!
    
    @IBOutlet weak var notificationImage: UIImageView!
    
    let picker = UIPickerView()
    
    let shapeView : UIImageView = {
        let imageView = UIImageView()
        //        imageView.image = UIImage(named: "Shape")
//              imageView.backgroundColor = .yellow
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
//        let shapeView: UIView = {
//            let view = UIView()
//            view.backgroundColor = .green
//            return view
//        }()
    
//        let labelTime = UILabel(frame: CGRect(x: 0, y: 0, width: 300, height: 60))
    
    var hour:Int = 0
    var minutes:Int = 0
    var seconds:Int = 0
    
    let dateFormatter = DateFormatter()
    
    
   
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var startButton: UIButton!
    
    @IBOutlet weak var soundSettingViewOutlet: UIView!
    
    @IBOutlet weak var soundLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        shapeView.alpha = 0
        timerLabel.alpha = 0
        timerLabel.textColor = .white
        timerLabel.text = ""
        notificationImage.alpha = 0
        timeNotiLabel.alpha = 0
    
        configPicker()
        roundedButton()
        setContraint()
        configState()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        animationCircular()
    }
    
    func configState() {
        self.containerCancelButtonView.layer.borderWidth = 1
        self.containerCancelButtonView.layer.cornerRadius = 49
        self.containerStartButtonView.layer.borderWidth = 1
        self.containerStartButtonView.layer.cornerRadius = 49
       
        self.timeNotiLabel.textColor = .gray.withAlphaComponent(0.3)
        self.notificationImage.tintColor = .gray.withAlphaComponent(0.3)
        
        switch self.currentState {
        case .cancelled:
            
            self.startButton.setTitle("Bắt đầu", for: .normal)
            self.startButton.setTitleColor(.green, for: .normal)
            self.startButton.backgroundColor = .green.withAlphaComponent(0.3)
            self.containerStartButtonView.layer.borderColor = UIColor.green.withAlphaComponent(0.3).cgColor
            
            self.cancelButton.isEnabled = false
            self.cancelButton.setTitleColor(.gray, for: .normal)
            self.containerCancelButtonView.layer.borderColor = UIColor.gray.withAlphaComponent(0.3).cgColor
            self.cancelButton.backgroundColor = .gray.withAlphaComponent(0.3)
            
        case .starting:
            self.startButton.isEnabled = true
            self.startButton.setTitle("Dừng", for: .normal)
            self.startButton.setTitleColor(.orange, for: .normal)
            self.startButton.backgroundColor = .orange.withAlphaComponent(0.3)
            self.containerStartButtonView.layer.borderColor = UIColor.orange.withAlphaComponent(0.3).cgColor
            //
            self.cancelButton.isEnabled = true // bấm được
            self.cancelButton.setTitleColor(.white, for: .normal)
            self.cancelButton.backgroundColor = .gray.withAlphaComponent(0.6)
            self.containerCancelButtonView.layer.borderColor = UIColor.gray.withAlphaComponent(0.4).cgColor
            
            self.timeNotiLabel.textColor = .gray.withAlphaComponent(0.9)
            self.notificationImage.tintColor = .gray.withAlphaComponent(0.9)
            
            
            self.startAnimation()
            self.timerLabel.text =  self.formatSecondsToString(TimeInterval(self.timeLeft))
            self.setTimer()
        case .paused:
            self.startButton.isEnabled = true
            self.startButton.setTitle("Tiếp tục", for: .normal)
            self.startButton.setTitleColor(.green, for: .normal)
            self.startButton.backgroundColor = .green.withAlphaComponent(0.3)
            self.containerStartButtonView.layer.borderColor = UIColor.green.withAlphaComponent(0.3).cgColor
            
            self.timeNotiLabel.textColor = .gray.withAlphaComponent(0.3)
            self.notificationImage.tintColor = .gray.withAlphaComponent(0.3)
            
            timer?.invalidate()
            self.pauseAnimation()
        case .continued:
            self.startButton.isEnabled = true
            self.startButton.setTitle("Dừng", for: .normal)
            self.startButton.setTitleColor(.orange, for: .normal)
            self.startButton.backgroundColor = .orange.withAlphaComponent(0.3)
            self.containerStartButtonView.layer.borderColor = UIColor.orange.withAlphaComponent(0.3).cgColor
            
            self.timeNotiLabel.textColor = .gray.withAlphaComponent(0.9)
            self.notificationImage.tintColor = .gray.withAlphaComponent(0.9)
            
            self.setTimer()
        }
    }
    
    @IBAction func startButtonAction(_ sender: UIButton) {
        switch self.currentState {
        case .cancelled:
            self.setTimeLeft()
            if self.timeLeft == 0 {
                return
            }
            self.currentState = .starting
            self.resumeAnimation()
        case .starting:
            self.currentState = .paused
        case .paused:
            self.currentState = .continued
            self.resumeAnimation()
            self.addTime()
        case .continued:
            self.currentState = .paused
        }
        
        UIPickerView.animate(withDuration: 0.05) {
            self.picker.alpha = 0
        }
        
        UIView.animate(withDuration: 0.05) {
            self.shapeView.alpha = 1
            
        }
        
        UILabel.animate(withDuration: 0.05) {
            self.timerLabel.alpha = 1
            self.timeNotiLabel.alpha = 1
        }
       
        UIImageView.animate(withDuration: 0.05) {
            self.notificationImage.alpha = 1
        }
    }
    
    func setTimeLeft(){
        timeLeft = 0
        timeLeft += seconds
        timeLeft += minutes * 60
        timeLeft += hour * 60 * 60
        addTime()
        
    }
    func addTime() {
        let date = Date()
        // cộng thời gian
        let currentDateTime = dateFormatter.string(from: date)
        timeNotiLabel.text = currentDateTime
        let addTime = date.addingTimeInterval(TimeInterval(timeLeft))
        dateFormatter.dateFormat = "HH:mm"
        let afterAddTime = dateFormatter.string(from: addTime)
        timeNotiLabel.text = afterAddTime
        
        let content = UNMutableNotificationContent()
        content.title = "Dồng Hồ"
        content.body = "Hẹn giờ"
        content.sound = UNNotificationSound(named: UNNotificationSoundName(self.currentSound + ".mp3"))
        content.userInfo = ["key": "Hẹn giờ"]
        
        let dateComponent = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: addTime)
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponent, repeats: false)
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        
        // xoá trước thêm sau notification
       removePendingNotification()
        self.notificationCenter.add(request) { (error) in
            if (error != nil) {
                print("Error" + error.debugDescription)
                return
            }
        }
       
    }
    func removePendingNotification() {
        notificationCenter.getPendingNotificationRequests { (notificationRequests) in
           var identifiers: [String] = []
           for notification: UNNotificationRequest in notificationRequests {
               if notification.content.userInfo["key"] as? String == "Hẹn giờ" {
                  identifiers.append(notification.identifier)
               }
           }
            self.notificationCenter.removePendingNotificationRequests(withIdentifiers: identifiers)
        }
    }
    
    func setTimer() {
        self.timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [self] timer in
            if self.timeLeft != 0 {
                self.timeLeft -= 1
                self.timerLabel.text = "\(self.formatSecondsToString(TimeInterval(timeLeft)))"
            } else {
                timer.invalidate()
                // khi thời gian kết thúc trả về BUtton Start
                self.currentState = .cancelled
                
                UIPickerView.animate(withDuration: 0.05) {
                    self.picker.alpha = 1
                }
                UIView.animate(withDuration: 0.05) {
                    self.shapeView.alpha = 0
                }
                UIImageView.animate(withDuration: 0.05) {
                    self.notificationImage.alpha = 0
                }
                UILabel.animate(withDuration: 0.05) {
                    self.timerLabel.alpha = 0
                    self.timerLabel.text = ""
                    self.timeNotiLabel.alpha = 0
                }
            }
        }
        runTimer = true
    }
    
    @IBAction func cancelButtonAction(_ sender: UIButton) {
        self.currentState = .cancelled
        UIPickerView.animate(withDuration: 0.05) {
            self.picker.alpha = 1
        }
        UIView.animate(withDuration: 0.05) {
            self.shapeView.alpha = 0
        }
        UILabel.animate(withDuration: 0.05) {
            self.timerLabel.alpha = 0
            self.timeNotiLabel.alpha = 0
        }
        UIImageView.animate(withDuration: 0.05) {
            self.notificationImage.alpha = 0
        }
        
        timeLeft = 0
        timer?.invalidate()
        self.timerLabel.text = ""
        removePendingNotification()
    }
    
    @IBAction func showRingButtonAction(_ sender: Any) {
        self.performSegue(withIdentifier: "showVC", sender: nil)

    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showVC" {
            if let vc = segue.destination as? RingViewController {
                vc.delegate = self
            }
        }
    }
    
    func formatSecondsToString(_ seconds: TimeInterval) -> String {
        if seconds == 0 {
            return "00:00:00"
        }
        let sec = Int(seconds.truncatingRemainder(dividingBy: 60))
        let min = Int(seconds.truncatingRemainder(dividingBy: 3600) / 60)
        let hour = Int(seconds / 3600)
        return String(format: "%02d:%02d:%02d", hour, min, sec)
    }
    
    func configPicker(){
        picker.delegate = self
        picker.dataSource = self
        picker.frame = CGRect(x: 50, y: 70, width: self.view.frame.width - 100, height: 200)
        picker.setValue(UIColor.white, forKey: "textColor")
        view.addSubview(picker)
    }
    
    func roundedButton(){
        cancelButton.layer.cornerRadius = 45
        startButton.layer.cornerRadius = 45
        soundSettingViewOutlet.layer.cornerRadius = 10
    }
    
    //MARK: - Animation
    let shapeLayer = CAShapeLayer()
    
    func animationCircular(){
        let center = CGPoint(x: shapeView.frame.width / 2, y: shapeView.frame.height / 2)
        
        let endAngle = (-CGFloat.pi / 2)
        let startAngle = 2 * CGFloat.pi + endAngle
        
        //MARK: - BezierPath
        let circularPath = UIBezierPath(arcCenter:  center, radius: 175, startAngle: startAngle, endAngle: endAngle, clockwise: false)
        
        
        //MARK: - shapeLayer
        shapeLayer.path = circularPath.cgPath
        shapeLayer.lineWidth = 10
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.strokeEnd = 1
        shapeLayer.lineCap = CAShapeLayerLineCap.round
        shapeLayer.strokeColor = UIColor.orange.cgColor
        
        shapeView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height / 2)
        shapeView.layer.addSublayer(shapeLayer)
    }
    
    func startAnimation() {
        let basicAnmation = CABasicAnimation(keyPath: "strokeEnd")
        basicAnmation.toValue = 0
        basicAnmation.duration = CFTimeInterval(timeLeft)
        basicAnmation.fillMode = CAMediaTimingFillMode.forwards
        basicAnmation.isRemovedOnCompletion = false
        shapeLayer.add(basicAnmation, forKey: "basicAnimation")
    }
    
    func resumeAnimation() {
        let pausedTime = shapeLayer.timeOffset
        shapeLayer.speed = 1.0
        shapeLayer.timeOffset = 0.0
        shapeLayer.beginTime = 0.0
        let timeSincePause = shapeLayer.convertTime(CACurrentMediaTime(), from: nil) - pausedTime
        shapeLayer.beginTime = timeSincePause
    }
    
    func pauseAnimation() {
        let pausedTime : CFTimeInterval = shapeLayer.convertTime(CACurrentMediaTime(), from: nil)
        shapeLayer.speed = 0.0
        shapeLayer.timeOffset = pausedTime
    }
    
    var currentSound: String = ""
}

extension ViewController: UIPickerViewDataSource, UIPickerViewDelegate{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 3
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch component {
        case 0:
            return 12
        case 1:
            return 60
        case 2:
            return 60
        default:
            return 0
        }
        
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch component {
        case 0:
            return "\(row) Giờ"
        case 1:
            return "\(row) Phút"
        case 2:
            return "\(row) Giây"
        default:
            return nil
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch component {
        case 0:
            hour = row
        case 1:
            minutes = row
        case 2:
            seconds = row
        default:
            break;
        }
    }
    
    func setContraint(){
        view.addSubview(shapeView)
       // shapeView.addSubview(timerLabel)
       // shapeView.addSubview(shapeLayer)
        NSLayoutConstraint.activate([
            shapeView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 1),
            shapeView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 2/3),
            shapeView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            shapeView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            //            shapeView.heightAnchor.constraint(equalToConstant: 300),
            //            shapeView.widthAnchor.constraint(equalToConstant: 300)

        ])
    }
}
extension ViewController: PassSoundDelegate {
    func updateSuond(sound: String) {
        soundLabel.text = sound
        self.currentSound = sound
    }
    
}


