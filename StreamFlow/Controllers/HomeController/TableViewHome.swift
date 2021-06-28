//
//  TableViewHome.swift
//  StreamFlow
//
//  Created by ilomidze on 09.05.21.
//

import Foundation
import UIKit


extension HomeController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        if ContinueWatchingData.getData().isEmpty {
//            return 4
//        } else {
//            return 5
//        }
        return tableNumOfRows
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
        
        sectionCell.delegate = self
        
        if tableView.numberOfRows(inSection: 0) == 4 {
            if indexPath.row == 1 {
                sectionCell.initCell(sectionNum: .newAdded, moviesData: newAddedMoviesData)
            } else
            if indexPath.row == 2 {
                sectionCell.initCell(sectionNum: .popularMovies, moviesData: popularMoviesData)
            } else
            if indexPath.row == 3 {
                sectionCell.initCell(sectionNum: .popularSeries, moviesData: popularSeriesData)
            }
        } else {
            if indexPath.row == 1 {
                sectionCell.initCell(sectionNum: .continueWatching, moviesData: continueWatchingMovieData)
            } else
            if indexPath.row == 2 {
                sectionCell.initCell(sectionNum: .newAdded, moviesData: newAddedMoviesData)
            } else
            if indexPath.row == 3 {
                sectionCell.initCell(sectionNum: .popularMovies, moviesData: popularMoviesData)
            } else
            if indexPath.row == 4 {
                sectionCell.initCell(sectionNum: .popularSeries, moviesData: popularSeriesData)
            }
        }
        
        
        sectionCell.selectionStyle = .none
        
        return sectionCell
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if !isTabBarMoveFinished { return }
        if scrollView.panGestureRecognizer.translation(in: scrollView).y < 0 {
            changeTabBar(hidden: true, animated: true)
        }
        else {
            changeTabBar(hidden: false, animated: true)
        }
    }
    
    
    // MARK: - Functions
    
    
    /// Hides Tab Bar if scrolled down and shows if scrolled up
    func changeTabBar(hidden:Bool, animated: Bool){
        guard let tabBar = self.tabBarController?.tabBar else { return; }
        if tabBar.isHidden == hidden{ return }
        
        isTabBarMoveFinished = false
        
        let frame = tabBar.frame
        let offset = hidden ? frame.size.height : -frame.size.height
        let duration:TimeInterval = (animated ? 0.5 : 0.0)
        tabBar.isHidden = false

        UIView.animate(withDuration: duration, animations: {
            tabBar.frame = frame.offsetBy(dx: 0, dy: offset)
        }, completion: { [weak self] (true) in
            tabBar.isHidden = hidden
            self?.isTabBarMoveFinished = true
        })
    }
    //ec
}
