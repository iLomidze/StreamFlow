//
//  TableViewHome.swift
//  StreamFlow
//
//  Created by ilomidze on 09.05.21.
//

import Foundation
import UIKit


extension HomeController: UITableViewDelegate, UITableViewDataSource, TitleCellDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // For First Row
        if indexPath.row == 0 {
            
            guard let titleCell = tableView.dequeueReusableCell(withIdentifier: "TitleCell", for: IndexPath(row: 0, section: 0)) as? TitleCell else {
                fatalError("Cant Generate Title Cell")
            }
            titleCell.delegate = self
            titleCell.initCell(movieOfTheDayData: movieOfTheDayData)
            return titleCell
        }        
        // For Every Row Except 0
        guard let commonCell = tableView.dequeueReusableCell(withIdentifier: "CommonCell", for: indexPath) as? CommonCell else {
            fatalError("Cant Generate Common Cell")
        }

        return commonCell
    }
    
    // TitleCell Delegate function - used when movie of the day is clicked
    func movieOfTheDayClicked() {
        guard let vc = storyboard?.instantiateViewController(identifier: "PlayerController") as? PlayerController else {
            print("Cant Instantiate PlayerController")
            return
        }
        vc.videoID = movieOfTheDayData.id
        navigationController?.pushViewController(vc, animated: true)
    }
}
