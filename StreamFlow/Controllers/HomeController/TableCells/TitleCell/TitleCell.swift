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
    
    let indicator = UIActivityIndicatorView(style: .large)
    
    var movieOfTheDayData: MovieData?
    var gradientIsSet = false
    
    
    // MARK: - Executive
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.color = .green
        addSubview(indicator)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        #warning("srul ekranze ar gadadis - chatvirtuli araa subview")
        if !gradientIsSet {
            addGradientView()
        }
        
        indicator.centerXAnchor.constraint(equalTo: coverImageView.centerXAnchor).isActive = true
        indicator.centerYAnchor.constraint(equalTo: coverImageView.centerYAnchor).isActive = true
        
        if coverImageView.image == nil {
            indicator.startAnimating()
        }
    }
    
    
    // MARK: - OutletActions
    
    @IBAction func coverBtnAction(_ sender: Any) {
        delegate?.movieOfTheDayClicked()
    }
    
    
    // MARK: - Functions
    
    ///
    func initCell(movieOfTheDayData: MovieData) {
        self.movieOfTheDayData = movieOfTheDayData
        
        titleLabel.text = movieOfTheDayData.anyName

        updateImage()
    }
    
    /// Updates|Sets image in ImageView
    func updateImage() {
        guard let imageData = movieOfTheDayData?.imageData else { return }
        coverImageView.image = UIImage(data: imageData)
        indicator.stopAnimating()
    }
    
    
    /// adds gradient to cover image
    func addGradientView() {
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
