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
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (videoUrlDataArr?.data.count ?? 0)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "EpisodesCell", for: indexPath) as? EpisodesCell else { fatalError() }
    
        cell.episodeLabel.text = "ეპიზოდი \(indexPath.row + 1)"
        cell.titleLabel.text = videoUrlDataArr?.data[indexPath.row].title ?? "N/A"

        guard let imageData = videoUrlDataArr?.data[indexPath.row].imgData else { return cell }
//        cell.imageData = imageData
        cell.imageView?.image = UIImage(data: imageData)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        playVideo(episode: indexPath.row)
    }
    
}
