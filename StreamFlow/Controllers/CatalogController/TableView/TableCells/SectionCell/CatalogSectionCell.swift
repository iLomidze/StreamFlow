//
//  CatalogSectionCell.swift
//  StreamFlow
//
//  Created by Irakli Lomidze on 12.06.21.
//

import UIKit



protocol GenreFilterDelegate: AnyObject {
    func genreFilter(id: Int, name: String)
}
protocol StudioFilterDelegate: AnyObject {
    func studioFilter(id: Int, name: String)
}


class CatalogSectionCell: UITableViewCell {

    var genreDelegate: GenreFilterDelegate?
    var studioDelegate: StudioFilterDelegate?
    
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
        
        
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    func initGenreSection(allGenresData: AllGenresData?) {
        sectionNameLabel.text = "ჟანრის მიხედვით"
        isGenreCellSelected = true
        
        guard let allGenresData = allGenresData else { return }
        self.allGenresData = allGenresData
        
        collectionView.register(UINib(nibName: "GenreColCell", bundle: nil), forCellWithReuseIdentifier: "GenreColCell")
    }
    
    func initStudioSection(topStudioData: TopStudiosDataArr?) {
        sectionNameLabel.text = "სტუდიის მიხედვით"
        isStudioCellSelected = true
        
        guard let topStudioData = topStudioData else { return }
        self.topStudioData = topStudioData
        
        collectionView.register(UINib(nibName: "StudioColCell", bundle: nil), forCellWithReuseIdentifier: "StudioColCell")
    }
    //End Class
}



extension CatalogSectionCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if isGenreCellSelected {
            return allGenresData?.data.count ?? 0
        } else {
            print("\n",topStudioData?.data.count ?? 0, "\n")
            return topStudioData?.data.count ?? 0
        }
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        if isGenreCellSelected {
            guard let allGenresData = allGenresData else {
                assert(false, "There must be data in allGenresData")
            }
            guard let genreCell = collectionView.dequeueReusableCell(withReuseIdentifier: "GenreColCell", for: indexPath) as? GenreColCell else { fatalError("Cant dequeue GenreColCell") }
            genreCell.initCell(genresData: allGenresData.data[indexPath.row])
            
            return genreCell
        } else {
            guard let studioCell = collectionView.dequeueReusableCell(withReuseIdentifier: "StudioColCell", for: indexPath) as? StudioColCell else { fatalError("Cant dequeue StudioColCell") }
            guard let topStudioData = topStudioData else {
                assert(false, "There must be data in topStudiosData")
            }
            studioCell.initCell(topStudioData: topStudioData.data[indexPath.row])
            
            return studioCell
        }
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
            return CGSize(width: 150, height: 60)
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if isGenreCellSelected {
            guard let genreData = allGenresData?.data else { assertionFailure("There should be data in allGenresData"); return }
            genreDelegate?.genreFilter(id: genreData[indexPath.row].id, name: genreData[indexPath.row].anyName)
        } else {
            guard let studioData = topStudioData?.data else { assertionFailure("There should be data topStudioData"); return }
            studioDelegate?.studioFilter(id: studioData[indexPath.row].id, name: studioData[indexPath.row].name)
        }
    }

}
