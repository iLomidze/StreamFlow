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
    
    
    // MARK: - Outlets
    
    @IBOutlet weak var coverBtn: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var coverImageView: UIImageView!
    
    
    // MARK: - Properties
    
    var movieOfTheDayData: MovieData?
    var gradientIsSet = false
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        #warning("srul ekranze ar gadadis - chatvirtuli araa subview")
        addGradientView()
    }
    
    
    
    // MARK: - OutletActions
    
    @IBAction func coverBtnAction(_ sender: Any) {
        delegate?.movieOfTheDayClicked()
    }
    
    
    // MARK: - Functions
    
    //-
    func initCell(movieOfTheDayData: MovieData) {
        if movieOfTheDayData.id == nil { return }
        
        self.movieOfTheDayData = movieOfTheDayData
        titleLabel.text = movieOfTheDayData.primaryName
        setImage(urlString: (movieOfTheDayData.cover?.large)!)
    }
    
    //-
    func setImage(urlString: String) {
        
        //es garet gaitane
        DataRequestManager.instance.getImage(urlString: urlString) { [weak self] data in
            DispatchQueue.main.async {
                self?.coverImageView.image = UIImage(data: data)
            }
        }
    }
    
    // adds gradient to cover image
    func addGradientView() {
        if gradientIsSet {
            return
        }
        
        let gradientView = UIView(frame: coverImageView.frame)
        
        let gradient = CAGradientLayer()
        
        gradient.frame = gradientView.frame
        gradient.colors = [UIColor.clear.cgColor, UIColor.init(red: CGFloat(10/255), green: CGFloat(5/255), blue: CGFloat(10/255), alpha: 1).cgColor]
        gradient.locations = [0.0, 0.83]
        gradientView.layer.insertSublayer(gradient, at: 0)

        coverImageView.addSubview(gradientView)

        coverImageView.bringSubviewToFront(gradientView)
        
        gradientIsSet = true
    }
    
}
