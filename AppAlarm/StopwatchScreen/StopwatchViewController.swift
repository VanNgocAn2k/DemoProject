//
//  StopwatchViewController.swift
//  AppAlarm
//
//  Created by Van Ngoc An  on 27/09/2022.
//

import UIKit

class StopwatchViewController: UIViewController {

    @IBOutlet weak var timerLabel: UILabel!
    
    @IBOutlet weak var containerStartButtonView: UIView!
    @IBOutlet weak var containerLapButtonView: UIView!
    @IBOutlet weak var lapButton: UIButton!
    @IBOutlet weak var startButton: UIButton!
    
    @IBOutlet weak var tableView: UITableView!
    
    var isTimerRunning = false
    var isTimerStarted = false
    
    var lapTimer : Timer?
    
    var lapTimerCounter = 0
    
    var lapArray = [Lap]()
    
    var minIndex = 0
    var maxIndex = 0
    var isMinAndMaxIndexAvailable = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configContainerView()
        lapButton.layer.cornerRadius = 45
        startButton.layer.cornerRadius = 45
        lapButton.isEnabled = false
        tableView.dataSource = self
        tableView.backgroundColor = .clear
        tableView.register(UINib(nibName: "LapTableViewCell", bundle: nil), forCellReuseIdentifier: "LapTableViewCell")
    }
    
    @IBAction func startButtonAction(_ sender: UIButton) {
        checkTimerStatus()
        
    }
    
   
    @IBAction func lapButtonAction(_ sender: UIButton) {
        if isTimerRunning{
            addLap()
        }else{
            resetTimer()
        }
    }
   func configContainerView(){
       containerStartButtonView.layer.cornerRadius = 49
       containerStartButtonView.layer.borderWidth = 1
       containerLapButtonView.layer.cornerRadius = 49
       containerLapButtonView.layer.borderWidth = 1
       lapButton.backgroundColor = UIColor.gray.withAlphaComponent(0.3)
       containerLapButtonView.layer.borderColor = UIColor.gray.withAlphaComponent(0.3).cgColor
       startButton.backgroundColor = UIColor.green.withAlphaComponent(0.3)
       containerStartButtonView.layer.borderColor = UIColor.green.withAlphaComponent(0.3).cgColor
    }
    
    func checkTimerStatus(){
        
        if !isTimerStarted{
            startTimer()
            lapButton.isEnabled = true
            startButton.setTitle("Dừng", for: .normal)
            startButton.setTitleColor(.red, for: .normal)
            startButton.backgroundColor = UIColor.red.withAlphaComponent(0.3)
            containerStartButtonView.layer.borderColor = UIColor.red.withAlphaComponent(0.3).cgColor
            lapButton.setTitleColor(.white, for: .normal)
            lapButton.backgroundColor = UIColor.gray.withAlphaComponent(0.6)
            containerLapButtonView.layer.borderColor = UIColor.gray.withAlphaComponent(0.6).cgColor
            isTimerStarted = true
            isTimerRunning = true
        }else{
            if isTimerRunning{
                stopTimer()
                startButton.setTitle("Tiếp tục", for: .normal)
                startButton.setTitleColor(.green, for: .normal)
                startButton.backgroundColor = UIColor.green.withAlphaComponent(0.3)
                containerStartButtonView.layer.borderColor = UIColor.green.withAlphaComponent(0.3).cgColor
                lapButton.setTitle("Đặt lại", for: .normal)
                lapButton.setTitleColor(.white, for: .normal)
                lapButton.backgroundColor = UIColor.gray.withAlphaComponent(0.6)
                containerLapButtonView.layer.borderColor = UIColor.gray.withAlphaComponent(0.6).cgColor
            }else{
                startTimer()
                startButton.setTitle("Dừng", for: .normal)
                startButton.setTitleColor(.red, for: .normal)
                lapButton.setTitle("Vòng", for: .normal)
                lapButton.setTitleColor(.white, for: .normal)
                lapButton.backgroundColor = UIColor.gray.withAlphaComponent(0.3)
                containerLapButtonView.layer.borderColor = UIColor.gray.withAlphaComponent(0.3).cgColor
            }
            isTimerRunning = !isTimerRunning
        }
    }
    func startTimer(){
 
        if lapTimer == nil{
            lapTimer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(updateLapTimer), userInfo: nil, repeats: true)
            RunLoop.main.add(lapTimer!, forMode: .common )
        }
    }
    
    @objc func updateLapTimer(){
        lapTimerCounter = lapTimerCounter + 1
        timerLabel.text = intToTime( lapTimerCounter )
    }
    
    func resetTimer(){
        
        lapTimerCounter = 0
        
        isTimerRunning = false
        isTimerStarted = false
        
        lapButton.isEnabled = false
        
        startButton.setTitle("Bắt đầu", for: .normal)
        startButton.setTitleColor(.green, for: .normal)
        lapButton.setTitle("Vòng", for: .normal)
        lapButton.setTitleColor(.gray, for: .normal)
        lapButton.backgroundColor = UIColor.gray.withAlphaComponent(0.3)
        containerLapButtonView.layer.borderColor = UIColor.gray.withAlphaComponent(0.3).cgColor
       
        timerLabel.text = "00:00,00"
        stopTimer()
        lapArray.removeAll()
        
        isMinAndMaxIndexAvailable = false
        
        minIndex = 0
        maxIndex = 0
        
        tableView.reloadData()
        
    }
    
    func addLap(){
        
      //  let time = lapTimerCounter
        let title = "Vòng " + String( lapArray.count + 1 )
        let lap  = Lap(title: title, time: lapTimerCounter)
        lapArray.append(lap)
        
      //  lapTimerCounter = 0
        timerLabel.text = intToTime(lapTimerCounter)
        
        if lapArray.count >= 2{
            checkMinAndMaxIndex()
        }
        
        tableView.reloadData()
    }
    
    func checkMinAndMaxIndex(){
        isMinAndMaxIndexAvailable = true
        var minTime = lapArray[ minIndex ].time
        var maxTime = lapArray[ maxIndex ].time
        
        for( index, value ) in lapArray.enumerated(){
            let time = value.time
            if time > maxTime{
                maxTime = time
                maxIndex = index
            }else if time < minTime{
                minTime = time
                minIndex = index
            }
        }
    }
    
    func  stopTimer(){

        lapTimer?.invalidate()
        lapTimer = nil
    }
    
    func intToTime( _ counter : Int ) -> String{
        let hour = counter / 3600
        let min  = ( counter % 3600 ) / 60
        let sec = ( counter % 3600 ) % 60
        return String( format: "%0.2d:%0.2d:%0.2d", hour,min,sec)
    }
   
}

    

extension StopwatchViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return lapArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "LapTableViewCell", for: indexPath) as! LapTableViewCell
        let index = lapArray.count - ( indexPath.row + 1 )
        
        var textColor = UIColor.white
        
        if isMinAndMaxIndexAvailable{
            if index == minIndex{
                textColor = .green
            }else if index == maxIndex{
                textColor = .red
            }
        }
        
//        cell.detailTextLabel?.textColor = textColor
        cell.textLabel?.textColor = textColor
        cell.timeLapLabel.textColor = textColor
        cell.numberLapLabel.text = (lapArray[ index ].title)
        cell.timeLapLabel.text = intToTime(lapArray[index].time)
        //tableView.reloadData()
        return cell
    }


}
