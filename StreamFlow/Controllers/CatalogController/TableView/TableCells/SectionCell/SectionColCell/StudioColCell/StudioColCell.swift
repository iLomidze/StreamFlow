//
//  StudioColCell.swift
//  StreamFlow
//
//  Created by Irakli Lomidze on 16.06.21.
//

import UIKit

class StudioColCell: UICollectionViewCell {

    @IBOutlet weak var studioNameLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    
    var topStudioData: TopStudiosData?
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        studioNameLabel.layer.masksToBounds = true
        imageView.layer.masksToBounds = true
        
        studioNameLabel.layer.cornerRadius = 8
        imageView.layer.cornerRadius = 8
    }

    
    func initCell(topStudioData: TopStudiosData) {
        self.topStudioData = topStudioData
    
        if let imgData = topStudioData.imgData {
            imageView.image = UIImage(data: imgData)
            studioNameLabel.text = ""
            imageView.isHidden = false
        } else {
            studioNameLabel.text = topStudioData.name
            imageView.isHidden = true
        }
    }
    
   
    @objc func btnAction() {
        print("brnaction")
    }
    
}
