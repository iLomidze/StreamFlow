//
//  GenreColCell.swift
//  StreamFlow
//
//  Created by Irakli Lomidze on 17.06.21.
//

import UIKit

class GenreColCell: UICollectionViewCell {

    @IBOutlet weak var genreLabel: UILabel!
    
//    var genreData: GenresData?
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        genreLabel.layer.masksToBounds = true
        genreLabel.layer.cornerRadius = 8
    }

    
    func initCell(genresData: GenresData) {
        genreLabel.text = genresData.anyName
    }
}
