//
//  TitleCell.swift
//  StreamFlow
//
//  Created by ilomidze on 09.05.21.
//

import UIKit


protocol TitleCellDelegate: AnyObject {
    func movieOfTheDayClicked(data: MovieData)
}

class TitleCell: UITableViewCell {

    public weak var delegate: TitleCellDelegate?
    
    
    // MARK: - Outlets
    
    @IBOutlet private weak var coverBtn: UIButton!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var coverImageView: UIImageView!
    
    
    // MARK: - Properties
    
    let indicator = UIActivityIndicatorView(style: .large)
    var gradient = CAGradientLayer()
    
    var movieOfTheDayData: MovieData?
    var gradientIsSet = false
    
    private var gradientLayer: CAGradientLayer?
    
    
    // MARK: - Executive
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.color = .green
        addSubview(indicator)
        addGradientView()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()

        self.gradientLayer?.frame = coverImageView.frame
        
        gradient.colors = [UIColor.clear.cgColor, UIColor(named: "backgroundColor")!.cgColor]
        
        indicator.centerXAnchor.constraint(equalTo: coverImageView.centerXAnchor).isActive = true
        indicator.centerYAnchor.constraint(equalTo: coverImageView.centerYAnchor).isActive = true
        
        if coverImageView.image == nil {
            indicator.startAnimating()
        }
    }
    
    
    // MARK: - OutletActions
    
    @IBAction func coverBtnAction(_ sender: Any) {
        delegate?.movieOfTheDayClicked(data: movieOfTheDayData ?? MovieData())
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
        
//        gradient.colors = [UIColor.clear.cgColor, UIColor(named: "backgroundColor")!.cgColor]

        gradient.startPoint = CGPoint(x: 0.0, y: 0.3);
        gradient.endPoint = CGPoint(x: 0.0, y: 1.0);
//                gradient.locations = [0.0, 0.83]
        
        self.gradientLayer = gradient

        coverImageView.layer.insertSublayer(gradient, at: 0)
//        coverImageView.bringSubviewToFront(gradientView)
    }
    
    //ec
}
