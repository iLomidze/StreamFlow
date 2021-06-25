//
//  SectionCell.swift
//  StreamFlow
//
//  Created by ilomidze on 09.05.21.
//

import UIKit

protocol MovieSectionCellDelegate: AnyObject {
    func movieSection(_ cell: SectionCell, didChooseWithIndexPath indexPath: IndexPath, withMoviesData data: MovieData)
}

class SectionCell: UITableViewCell {
    
    // MARK: - Outlets
    @IBOutlet private weak var sectionNameLabel: UILabel!
    @IBOutlet private weak var collectionView: UICollectionView!
    
    weak var delegate: MovieSectionCellDelegate?
    
    // MARK: - Properties
    var moviesData = [MovieData]() {
        didSet {
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
    }
    
    
    // MARK: - Executive
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        collectionView.register(UINib(nibName: "MovieListCollectionCell", bundle: nil), forCellWithReuseIdentifier: "MovieListCollectionCell")
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = UIColor(named: "backgroundColor")
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
 
    
    ///
    func initCell(sectionNum: SectionNames, moviesData: [MovieData]) {
        switch sectionNum.rawValue {
        case 1:
            sectionNameLabel.text = "ახალი დამატებული"
        case 2:
            sectionNameLabel.text = "ტოპ ფილმები"
        case 3:
            sectionNameLabel.text = "ტოპ სერიალები"
        default:
            sectionNameLabel.text = "განაგრძე ყურება"
        self.moviesData = moviesData
        }
    }
    
    
    /// Updates image for CollectionList Cell
    func updateImageForMovieListCollectionCell(at itemInSection: Int) {
        if let movieListCollectionCell = collectionView.cellForItem(at: IndexPath(item: itemInSection, section: 0)) as? MovieListCollectionCell {
        
            movieListCollectionCell.updateImage()
            collectionView.reloadItems(at: [IndexPath(item: itemInSection, section: 0)])
        }
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
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.delegate?.movieSection(self, didChooseWithIndexPath: indexPath, withMoviesData: moviesData[indexPath.row])
    }
}
