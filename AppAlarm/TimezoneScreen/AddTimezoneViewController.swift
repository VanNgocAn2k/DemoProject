//
//  AddTimezoneViewController.swift
//  AppAlarm
//
//  Created by Van Ngoc An  on 08/10/2022.
//

import UIKit

protocol WorldClockDelegate: AnyObject {
    func addTimeZone(timeZone: String)
}

class AddTimezoneViewController: UIViewController {

    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var tableView: UITableView!
    
    var timeZones: [String] = []
    var delegate: WorldClockDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchTextField.delegate = self
        searchTextField.clipsToBounds = true
        searchTextField.layer.cornerRadius = 10
        configTbv()
        
        timeZones = NSTimeZone.knownTimeZoneNames
//        print(timeZones.count)
        // set padding left
        searchTextField.leftViewMode = .always
        searchTextField.leftView = UIView(frame: .init(x: 0, y: 0, width: 16, height: 0))
        // set padding right
        searchTextField.rightViewMode = .always
        searchTextField.rightView = UIView(frame: .init(x: 0, y: 0, width: 16, height: 0))
        
    }
    func configTbv() {
        tableView.delegate = self
        tableView.dataSource = self
        let nibCell = UINib(nibName: "AddTimezoneTableViewCell", bundle: nil)
        self.tableView.register(nibCell, forCellReuseIdentifier: "AddTimezoneTableViewCell")
    }
    @IBAction func cancelAction(_ sender: Any) {
        dismiss(animated: true)
        
    }
}
extension AddTimezoneViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return timeZones.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AddTimezoneTableViewCell", for: indexPath) as! AddTimezoneTableViewCell
        cell.countryCityLabel.text = timeZones[indexPath.row]
        
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedTimeZone: String = timeZones[indexPath.row]
        delegate?.addTimeZone(timeZone: selectedTimeZone)
        self.dismiss(animated: true)
    }
}
extension AddTimezoneViewController: UITextFieldDelegate {
    func textFieldDidChangeSelection(_ textField: UITextField) {
        let text = textField.text
        if text != "" {
            timeZones = NSTimeZone.knownTimeZoneNames.filter { $0.contains(text ?? "") }
        } else {
            timeZones = NSTimeZone.knownTimeZoneNames
        }
        tableView.reloadData()
    }
}
