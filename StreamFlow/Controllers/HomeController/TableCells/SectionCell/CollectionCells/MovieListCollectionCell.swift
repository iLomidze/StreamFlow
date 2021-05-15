//
//  MovieListCollectionCell.swift
//  StreamFlow
//
//  Created by ilomidze on 12.05.21.
//

import UIKit


class MovieListCollectionCell: UICollectionViewCell {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    
    var movieData = MovieData()
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func initCell(movieData: MovieData) {
        self.movieData = movieData
        titleLabel.text = movieData.primaryName
        
        if movieData.covers?.data?.m != "" {
            setImage(urlString: (movieData.covers?.data?.m)!)
        }
    }
    

//-
func setImage(urlString: String) {
    let dataRequestManager = DataRequestManager()
    
    if movieData.id == nil {
        return
    }
    
    dataRequestManager.getImage(urlString: urlString) { [weak self] data in
        DispatchQueue.main.async {
            self?.imageView.image = UIImage(data: data)
        }
    }
}

}
