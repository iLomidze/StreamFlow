//
//  MainTabBarController.swift
//  StreamFlow
//
//  Created by ilomidze on 11.05.21.
//

import UIKit

class MainTabBarController: UITabBarController, UIScrollViewDelegate {

    
    override var shouldAutorotate: Bool {
        return false
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    
    #warning("tab bar hide - aqedan rom gavaketo...")
//    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
//        if scrollView.panGestureRecognizer.translation(in: scrollView).y < 0 {
//            changeTabBar(hidden: true, animated: true)
//        }
//        else {
//            changeTabBar(hidden: false, animated: true)
//        }
//    }
    
    
//    func changeTabBar(hidden:Bool, animated: Bool){
//        guard let tabBar = self.tabBarController?.tabBar else { return; }
//        if tabBar.isHidden == hidden{ return }
//        let frame = tabBar.frame
//        let offset = hidden ? frame.size.height : -frame.size.height
//        let duration:TimeInterval = (animated ? 0.5 : 0.0)
//        tabBar.isHidden = false
//
//        UIView.animate(withDuration: duration, animations: {
//            tabBar.frame = frame.offsetBy(dx: 0, dy: offset)
//        }, completion: { (true) in
//            tabBar.isHidden = hidden
//        })
//    }
}
