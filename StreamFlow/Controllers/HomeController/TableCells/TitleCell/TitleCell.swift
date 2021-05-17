//
//  TitleCell.swift
//  StreamFlow
//
//  Created by ilomidze on 09.05.21.
//

import UIKit

protocol TitleCellDelegate: AnyObject {
    func movieOfTheDayClicked()
}

class TitleCell: UITableViewCell {

    public weak var delegate: TitleCellDelegate?
    
    @IBOutlet weak var coverBtn: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var coverImageView: UIImageView!
    
    
    var movieOfTheDayData: MovieData?
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    
    @IBAction func coverBtnAction(_ sender: Any) {
        delegate?.movieOfTheDayClicked()
    }
    
    
    // ------
    
    //-
    func initCell(movieOfTheDayData: MovieData) {
        if movieOfTheDayData.id == nil { return }
        
        self.movieOfTheDayData = movieOfTheDayData
        titleLabel.text = movieOfTheDayData.primaryName
        setImage(urlString: (movieOfTheDayData.cover?.large)!)
    }
    
    //-
    func setImage(urlString: String) {
//        let dataRequestManager = DataRequestManager()
        
        DataRequestManager.instance.getImage(urlString: urlString) { [weak self] data in
            DispatchQueue.main.async {
                self?.coverImageView.image = UIImage(data: data)
                self?.addGradientView()
            }
        }
    }
    
    // adds gradient to cover image
    func addGradientView() {
        let gradientView = UIView(frame: coverImageView.frame)
        
        let gradient = CAGradientLayer()
        
        gradient.frame = gradientView.frame

        gradient.colors = [UIColor.clear.cgColor, UIColor.init(red: CGFloat(10/255), green: CGFloat(5/255), blue: CGFloat(10/255), alpha: 1).cgColor]

        gradient.locations = [0.0, 0.83]

        gradientView.layer.insertSublayer(gradient, at: 0)

        coverImageView.addSubview(gradientView)

        coverImageView.bringSubviewToFront(gradientView)
    }
    
}
