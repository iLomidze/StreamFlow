//
//  CatalogSectionCell.swift
//  StreamFlow
//
//  Created by Irakli Lomidze on 12.06.21.
//

import UIKit

class CatalogSectionCell: UITableViewCell {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var sectionNameLabel: UILabel!
    
    var allGenresData: AllGenresData? {
        didSet {
            collectionView.reloadData()
        }
    }
    var topStudioData: TopStudiosDataArr? {
        didSet {
            collectionView.reloadData()
        }
    }
    
    var isGenreCellSelected = false
    var isStudioCellSelected = false
    
    
    // MARK: - Executive
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.register(UINib(nibName: "CatalogColSectionCell", bundle: nil), forCellWithReuseIdentifier: "CatalogColSectionCell")
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    func initGenreCell(allGenresData: AllGenresData?) {
        sectionNameLabel.text = "ჟანრის მიხედვით"
        isGenreCellSelected = true
        
        guard let allGenresData = allGenresData else { return }
        self.allGenresData = allGenresData
    }
    
    func initStudioCell(topStudioData: TopStudiosDataArr?) {
        sectionNameLabel.text = "სტუდიის მიხედვით"
        isStudioCellSelected = true
        
        guard let topStudioData = topStudioData else { return }
        self.topStudioData = topStudioData
    }
    
}


extension CatalogSectionCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if isGenreCellSelected {
            return allGenresData?.data.count ?? 0
        } else {
            return topStudioData?.data.count ?? 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CatalogColSectionCell", for: indexPath) as? CatalogColSectionCell else { fatalError("Cant dequeue CatalogColSectionCell") }
        
        if isGenreCellSelected {
            guard let allGenresData = allGenresData else {
                assert(false, "There must be data in allGenresData")
            }
            cell.initGenreCell(genreData: allGenresData.data[indexPath.row])
        } else {
            // TODO: for studioCell
            guard let topStudioData = topStudioData else {
                assert(false, "There must be data in topStudiosData")
            }
            cell.initStudioCell(topStudioData: topStudioData.data[indexPath.row])
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
            return CGSize(width: 150, height: 60)
    }
    
}
