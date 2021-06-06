//
//  MovieListCollectionCell.swift
//  StreamFlow
//
//  Created by ilomidze on 12.05.21.
//

import UIKit
import SDWebImage

class MovieListCollectionCell: UICollectionViewCell {
    
    // MARK: - Outlets
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    
    // MARK: - Properties
    
    var movieData: MovieData!
    var indicator: UIActivityIndicatorView!
    
    
    // MARK: - Executive
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        imageView.layer.cornerRadius = 5
        
        if indicator == nil {
            indicator = UIActivityIndicatorView(style: .large)

            indicator.translatesAutoresizingMaskIntoConstraints = false
            indicator.color = .green
            self.addSubview(indicator)
            
            indicator.centerXAnchor.constraint(equalTo: imageView.centerXAnchor).isActive = true
            indicator.centerYAnchor.constraint(equalTo: imageView.centerYAnchor, constant: 20).isActive = true
        }
        
        if imageView.image == nil {
            indicator.startAnimating()
        }
    }
    
    
    // MARK: - Functions
    
    
    ///
    func initCell(movieData: MovieData) {
        self.movieData = movieData
        
        titleLabel.text = movieData.anyName
        
        updateImage()
    }
    
    ///
    func initCellForRelatedMovies(relatedMovisData: MovieDescrDataInfo) {
        imageView.image = nil
        titleLabel.text = relatedMovisData.anyName
        guard let imageData = relatedMovisData.imageData else {
            imageView.image = UIImage(named: "noMovieCover")
            return
        }
        imageView.image = UIImage(data: imageData)
        indicator.stopAnimating()
    }
    
    /// Updates|Sets image in ImageView
    func updateImage() {
        guard let imageData = movieData.imageData else { return }
        imageView.image = UIImage(data: imageData)
        indicator.stopAnimating()
    }
}
