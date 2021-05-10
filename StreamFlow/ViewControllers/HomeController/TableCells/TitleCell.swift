//
//  TitleCell.swift
//  StreamFlow
//
//  Created by ilomidze on 09.05.21.
//

import UIKit

class TitleCell: UITableViewCell {

    @IBOutlet weak var titleBtn: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    
    var movieData: MovieData?
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    
    @IBAction func titleBtnAction(_ sender: Any) {
    }
    
    
    // ------
    
    //-
    func initCell(movieData: MovieData) {
        self.movieData = movieData
        titleLabel.text = movieData.secondaryName
        setImage(urlString: (movieData.cover?.large)!)
    }
    
    func setImage(urlString: String) {
        let dataRequestManager = DataRequestManager()
        
        dataRequestManager.getImage(urlString: urlString) { [weak self] data in
            DispatchQueue.main.async {
                self?.titleBtn.setImage(UIImage(data: data), for: .normal)
            }
        }
    }
    
}
