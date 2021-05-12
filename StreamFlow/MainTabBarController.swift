//
//  MainTabBarController.swift
//  StreamFlow
//
//  Created by ilomidze on 11.05.21.
//

import UIKit

class MainTabBarController: UITabBarController {

    
    override var shouldAutorotate: Bool {
        return false
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

}
