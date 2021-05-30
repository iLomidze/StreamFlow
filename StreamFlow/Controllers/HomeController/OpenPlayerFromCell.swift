//
//  CellClickedController.swift
//  StreamFlow
//
//  Created by ilomidze on 24.05.21.
//

import Foundation
import UIKit


/// When title cell button is pushed
extension HomeController: TitleCellDelegate {
    /// TitleCell Delegate function - used when movie of the day is clicked
    func movieOfTheDayClicked() {
        guard let vc = storyboard?.instantiateViewController(identifier: "TestPlayerController") as? PlayerController else {
            print("Cant Instantiate PlayerController")
            return
        }
        guard let id = movieOfTheDayData.id else {
            print("No Movie ID")
            return
        }
        vc.prepVC(videoID: id)
        navigationController?.pushViewController(vc, animated: true)
    }
}


/// when movieListCollectionCell button is pushed
extension HomeController {
    
    func addObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(movieSelectedInCell), name: NSNotification.Name(rawValue: movieCellPicked), object: nil)
    }
    
    @objc func movieSelectedInCell(notification: NSNotification){
        guard let id = notification.userInfo?["movieID"] as? Int else {
            print("No Movie ID")
            return
        }
        guard let vc = storyboard?.instantiateViewController(identifier: "PlayerController") as? PlayerController else {
            print("Cant Instantiate PlayerController")
            return
        }
        
        vc.prepVC(videoID: id)
        navigationController?.pushViewController(vc, animated: true)
    }
}
