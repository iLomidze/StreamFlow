//
//  TableController.swift
//  StreamFlow
//
//  Created by Irakli Lomidze on 05.06.21.
//

import Foundation
import UIKit

extension PlayerController: UITableViewDelegate, UITableViewDataSource, SeasonChangeDelegate {
    func changeSeason(season: Int) {
        seasonPicked = season
        episodesTableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (movieDescDataArr?.data.seasons?.data[seasonPicked].episodesCount ?? 0)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "EpisodesCell", for: indexPath) as? EpisodesCell else { fatalError() }
    
        cell.episodeLabel.text = "ეპიზოდი \(indexPath.row + 1)"
//        cell.titleLabel.text = movieDescDataArr?.data.
        
        return cell
    }
    
    
}
