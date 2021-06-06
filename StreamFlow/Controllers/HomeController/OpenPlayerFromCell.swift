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
    func movieOfTheDayClicked(data: MovieData) {
        guard let storyBoard = self.storyboard,
              let vc = PlayerController.prepare(withData: data, onStoryboard: storyBoard, dataFetcher: self.dataFetcher) else { return }
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

/// When Section cell button is pushed
extension HomeController: MovieSectionCellDelegate {
    func movieSection(_ cell: SectionCell, didChooseWithIndexPath indexPath: IndexPath, withMoviesData data: MovieData) {
        guard let storyBoard = self.storyboard,
              let vc = PlayerController.prepare(withData: data, onStoryboard: storyBoard, dataFetcher: self.dataFetcher) else { return }
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
