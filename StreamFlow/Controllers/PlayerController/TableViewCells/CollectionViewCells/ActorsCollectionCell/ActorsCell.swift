//
//  ActorsCell.swift
//  StreamFlow
//
//  Created by Irakli Lomidze on 03.06.21.
//

import UIKit
import SDWebImage

class ActorsCell: UICollectionViewCell {
    
    // MARK: - Outlets
    
    @IBOutlet weak private var imageView: UIImageView!
    @IBOutlet weak private var label: UILabel!
    
    
    // MARK: - Properties
    
    private var image: UIImage?
    private var name: String?
    
    var indicator: UIActivityIndicatorView!
    
    
    // MARK: - Executive
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        imageView.layer.cornerRadius = 35
    
        imageView.image = nil
        
        indicator = UIActivityIndicatorView(style: .large)
        indicator.color = .green
        indicator.startAnimating()
        
    }

    
    // MARK: - Functions
    
    ///
    func prepCell(name: String, imageData: Data?) {
        self.name = name
        if let imageData = imageData {
            self.image = UIImage(data: imageData)
        } else {
            self.image = nil
        }
        
        updateCell()
    }
    
    ///
    func updateCell() {
        if image != nil {
            imageView.image = image
        } else {
            imageView.image = UIImage(named: "noAvatar")
        }
        indicator.stopAnimating()
        
        if label.text != nil {
            label.text = name
        }
    }
}
