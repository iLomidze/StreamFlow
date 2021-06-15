//
//  CatalogTableView.swift
//  StreamFlow
//
//  Created by Irakli Lomidze on 11.06.21.
//

import Foundation
import UIKit

extension CatalogController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "CatalogTitleCell", for: indexPath) as? CatalogTitleCell else { fatalError("CatalogTitleCell creation Error") }
        
            cell.initCell(topTrailersDataArr: topTrailersData, screenSize: CGSize(width: view.frame.width, height: view.frame.height), parent: nil)            
            
            return cell
        } else if indexPath.row == 1{
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "CatalogSectionCell", for: indexPath) as? CatalogSectionCell else { fatalError("CatalogSectionCell creation Error") }
            
            cell.initGenreCell(allGenresData: allGenresData)
            
            return cell
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "CatalogSectionCell", for: indexPath) as? CatalogSectionCell else { fatalError("CatalogSectionCell creation Error") }
            
            cell.initStudioCell(topStudioData: topStudiosData)
            return cell
        }
    }
    
    
}
