//
//  TabBarController.swift
//  AppAlarm
//
//  Created by Van Ngoc An  on 24/09/2022.
//

import UIKit

class TabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBar.unselectedItemTintColor = .gray
        self.tabBar.tintColor = .orange
        self.tabBar.backgroundColor = .black
        self.tabBar.barTintColor = .clear

    }

}
