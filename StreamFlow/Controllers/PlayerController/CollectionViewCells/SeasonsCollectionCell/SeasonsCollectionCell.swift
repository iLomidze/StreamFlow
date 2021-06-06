//
//  SeasonsCollectionCell.swift
//  StreamFlow
//
//  Created by Irakli Lomidze on 05.06.21.
//

import UIKit

class SeasonsCollectionCell: UICollectionViewCell {

    @IBOutlet weak var button: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        button.layer.cornerRadius = 10
    }

    
    @IBAction func buttonAction(_ sender: Any) {
        
    }
    
   // End Class
}
