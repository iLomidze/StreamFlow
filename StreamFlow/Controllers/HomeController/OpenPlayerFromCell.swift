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
