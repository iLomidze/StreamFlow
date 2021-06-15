//
//  CatalogColTitleCell.swift
//  StreamFlow
//
//  Created by Irakli Lomidze on 11.06.21.
//

import UIKit


protocol TrailerPlayProt: AnyObject {
    func playTrailer(videoStringURL: String)
}


class CatalogColTitleCell: UICollectionViewCell {
    
    var trailerPlayerDelegate: TrailerPlayProt?
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var trailerLabel: UILabel!
    @IBOutlet weak var movieNameLabel: UILabel!
    
    var topTrailerData: TopTrailersData?
    
    
    override func awakeFromNib() {
        super.awakeFromNib()

        trailerLabel.layer.cornerRadius = 5
        imageView.layer.cornerRadius = 10
        
    }
    
    func initCell(topTrailerData: TopTrailersData) {
        self.topTrailerData = topTrailerData
        
        movieNameLabel.text = topTrailerData.originalName
        
        if let imgData = topTrailerData.imgData {
            imageView.image = UIImage(data: imgData)
        }
    }
    
    ///
    @IBAction func playBtnAction(_ sender: Any) {
        // TODO: Play Video
        trailerPlayerDelegate?.playTrailer(videoStringURL: topTrailerData?.trailers.anyTrailer ?? "")
    }
    
    
    
// End Class
}
