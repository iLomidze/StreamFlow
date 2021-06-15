//
//  CatalogColSectionCell.swift
//  StreamFlow
//
//  Created by Irakli Lomidze on 12.06.21.
//

import UIKit

class CatalogColSectionCell: UICollectionViewCell {

    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var imgView: UIImageView!
    
    
    var genreData: GenresData?
    var topStudioData: TopStudiosData?
    
    // MARK: - Executive
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        label.layer.masksToBounds = true
        label.layer.cornerRadius = 9
    }
    
    
    // MARK: - Functions
    
    func initGenreCell(genreData: GenresData) {
        self.genreData = genreData
        imgView.isHidden = true
        label.text = genreData.anyName
    }
    
    
    func initStudioCell(topStudioData: TopStudiosData) {
        self.topStudioData = topStudioData
    
        if let imgData = topStudioData.imgData {
            imgView.image = UIImage(data: imgData)
            label.text = ""
            imgView.isHidden = false
        } else {
            label.text = topStudioData.name
            imgView.isHidden = true
        }
    }
    
    
    @IBAction func btnAction(_ sender: Any) {
        if genreData != nil {
            // TODO: get single genre data in a new controller
        } else {
            // TODO: get single studio data in a new controller
        }
    }
    
    
}
