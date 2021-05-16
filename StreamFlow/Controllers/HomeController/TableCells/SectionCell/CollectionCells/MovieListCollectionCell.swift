//
//  MovieListCollectionCell.swift
//  StreamFlow
//
//  Created by ilomidze on 12.05.21.
//

import UIKit


class MovieListCollectionCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView! {
        didSet {
            if indicator == nil { return }
           
            if imageView.image == nil {
                indicator.startAnimating()
            } else {
                indicator.stopAnimating()
            }
        }
    }
    @IBOutlet weak var titleLabel: UILabel!
    
    
    var movieData = MovieData()
    var indicator: UIActivityIndicatorView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        indicator = UIActivityIndicatorView(style: .large)
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.color = .green
        self.addSubview(indicator)
        
        indicator.centerXAnchor.constraint(equalTo: imageView.centerXAnchor).isActive = true
        indicator.centerYAnchor.constraint(equalTo: imageView.centerYAnchor, constant: 20).isActive = true
        
        if imageView.image == nil {
            indicator.startAnimating()
        }
    }
    
    func initCell(movieData: MovieData) {
        self.movieData = movieData
        
        if movieData.primaryName != "" {
            titleLabel.text = movieData.primaryName
        } else if movieData.secondaryName != "" {
            titleLabel.text = movieData.secondaryName
        } else {
            titleLabel.text = movieData.originalName
        }
        
        
        guard let imageData = movieData.imageData else { return }
        imageView.image = UIImage(data: imageData)
    }

}
