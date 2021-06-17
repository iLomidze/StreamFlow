//
//  CatalogTitleCell.swift
//  StreamFlow
//
//  Created by Irakli Lomidze on 11.06.21.
//

import UIKit


protocol TrailerPlayDelegate: AnyObject {
    func playTrailer(videoStringURL: String)
}

class CatalogTitleCell: UITableViewCell {

    var trailerPlayerDelegate: TrailerPlayDelegate?
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    internal var parent: CatalogController?
    internal var screenSize: CGSize?
    internal var topTrailersDataArr: TopTrailersDataArr?
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
     
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.register(UINib(nibName: "CatalogColTitleCell", bundle: nil), forCellWithReuseIdentifier: "CatalogColTitleCell")

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func initCell(topTrailersDataArr: TopTrailersDataArr?, screenSize: CGSize) {
        self.topTrailersDataArr = topTrailersDataArr
        self.screenSize = screenSize
        addCollectionViewConstrains()
    }
    
    func addCollectionViewConstrains() {
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        let heightConstraint = NSLayoutConstraint(item: collectionView!, attribute: NSLayoutConstraint.Attribute.height, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1, constant: (screenSize?.width ?? 20) * 0.5 + 50)
        NSLayoutConstraint.activate([heightConstraint])

    }
    
}



extension CatalogTitleCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        topTrailersDataArr?.data.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CatalogColTitleCell", for: indexPath) as? CatalogColTitleCell else { fatalError("Cant dequeue CatalogColTitleCell") }
        cell.initCell(topTrailerData: topTrailersDataArr!.data[indexPath.row])
//        cell.trailerPlayerDelegate = self
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        trailerPlayerDelegate?.playTrailer(videoStringURL: topTrailersDataArr?.data[indexPath.row].trailers.anyTrailer ?? "")
    }
    
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: (screenSize?.width ?? 20), height: (screenSize?.width ?? 20) * 0.5 + 50)
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }

    func collectionView(_ collectionView: UICollectionView, layout
        collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    //End Class
}


extension CatalogTitleCell: TrailerPlayDelegate {
    func playTrailer(videoStringURL: String) {
        trailerPlayerDelegate?.playTrailer(videoStringURL: videoStringURL)
    }
    
    
}
