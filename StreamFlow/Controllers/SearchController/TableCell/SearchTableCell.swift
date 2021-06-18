//
//  SearchTableCell.swift
//  StreamFlow
//
//  Created by Irakli Lomidze on 18.06.21.
//

import UIKit

class SearchTableCell: UITableViewCell {

    
    @IBOutlet weak var coverImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var detailsLabel: UILabel!
    
    var data: MovieData?
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        coverImage.layer.cornerRadius = 13
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        if let data = data {
            titleLabel.text = data.anyName
            if data.isTvShow ?? false {
                detailsLabel.text = ("ტიპი: სერიალი")
            } else {
                detailsLabel.text = ("ტიპი: ფილმი")
            }
            
            if let imgData = data.imageData {
                coverImage.image = UIImage(data: imgData)
            }
        }
    }
    
    
    func initCell(data: MovieData) {
        self.data = data
    }
    
}
