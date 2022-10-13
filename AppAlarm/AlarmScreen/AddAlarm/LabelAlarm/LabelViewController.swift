//
//  LabelViewController.swift
//  AppAlarm
//
//  Created by Van Ngoc An  on 04/10/2022.
//

import UIKit

protocol PassLabelDelegate {
    func updateLabelAlarm(labelAlarm: String)
}

class LabelViewController: UIViewController {

    @IBOutlet weak var labelAlarmTextField: UITextField!
    
    var delegateLabel: PassLabelDelegate?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    
    @IBAction func backAction(_ sender: UIBarButtonItem) {
        dismiss(animated: true)
        delegateLabel?.updateLabelAlarm(labelAlarm: labelAlarmTextField.text!)
        
    }
    
    

}
