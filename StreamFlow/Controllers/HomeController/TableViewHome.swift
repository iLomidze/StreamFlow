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
        guard let sectionCell = tableView.dequeueReusableCell(withIdentifier: "SectionCell", for: indexPath) as? SectionCell else {
            fatalError("Cant Generate SectionCell")
        }
        

        if indexPath.row == 1 {
            sectionCell.initCell(sectionNum: .newAdded, moviesData: newAddedMoviesData)
        }
        if indexPath.row == 2 {
            sectionCell.initCell(sectionNum: .populadMovies, moviesData: popularMoviesData)
        }
        if indexPath.row == 3 {
            sectionCell.initCell(sectionNum: .popularSeries, moviesData: popularSeriesData)
        }
        
        sectionCell.selectionStyle = .none
        
        return sectionCell
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
