//
//  MainNavigationController.swift
//  Particle
//
//  Created by Artem Misesin on 10/27/17.
//  Copyright © 2017 Artem Misesin. All rights reserved.
//

import UIKit

class MainNavigationController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        navigationBar.isTranslucent = true
        navigationBar.barTintColor = .white
        navigationBar.setValue(true, forKey: "hidesShadow")
    }

}
