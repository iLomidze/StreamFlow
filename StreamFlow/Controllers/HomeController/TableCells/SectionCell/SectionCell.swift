//
//  SectionCell.swift
//  StreamFlow
//
//  Created by ilomidze on 09.05.21.
//

import UIKit

class SectionCell: UITableViewCell {

    
    // MARK: - Outlets
    @IBOutlet weak var sectionNameLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    
    
    // MARK: - Properties
    var moviesData = [MovieData]() {
        didSet {
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        collectionView.register(UINib(nibName: "MovieListCollectionCell", bundle: nil), forCellWithReuseIdentifier: "MovieListCollectionCell")
        collectionView.delegate = self
        collectionView.dataSource = self
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
 
    
    //-
    func initCell(sectionNum: SectionNames, moviesData: [MovieData]) {
        switch sectionNum.rawValue {
        case 1:
            sectionNameLabel.text = "ახალი დამატებული"
        case 2:
            sectionNameLabel.text = "ტოპ ფილმები"
        default:
            sectionNameLabel.text = "ტოპ სერიალები"
        }
        self.moviesData = moviesData
    }
}


extension SectionCell: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        moviesData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MovieListCollectionCell", for: indexPath) as? MovieListCollectionCell else {
            return UICollectionViewCell()
        }
        
        cell.imageView?.image = nil
        
        let movieData = moviesData[indexPath.row]
        cell.awakeFromNib()
        cell.initCell(movieData: movieData)

        return cell
    }
    
    
}
