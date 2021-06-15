//
//  EpisodesCell.swift
//  StreamFlow
//
//  Created by Irakli Lomidze on 05.06.21.
//

import UIKit

class EpisodesCell: UITableViewCell {

  
    @IBOutlet weak var coverImageView: UIImageView!
    @IBOutlet weak var episodeLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    
    var imageData: Data?
    
    
    // MARK: - Executive
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
//        frame.inset(by: UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5))
        
        // TODO: loading indicator daamate
        coverImageView.image = UIImage(named: "noMovieCover")
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func initCell(imageData: Data) {
        self.imageData = imageData
        coverImageView.image = UIImage(data: imageData)
    }
    
    
}
