//
//  MainTabBarController.swift
//  Particle
//
//  Created by Artem Misesin on 6/25/17.
//  Copyright © 2017 Artem Misesin. All rights reserved.
//

import UIKit

class MainTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        tabBar.barTintColor = .white
        tabBar.tintColor = Colors.mainColor
        let statusBarView = UIView(frame: UIApplication.shared.statusBarFrame)
        statusBarView.backgroundColor = .white
        view.addSubview(statusBarView)
    }

}
