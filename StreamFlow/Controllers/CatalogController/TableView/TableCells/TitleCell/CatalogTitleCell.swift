//
//  CatalogTitleCell.swift
//  StreamFlow
//
//  Created by Irakli Lomidze on 11.06.21.
//

import UIKit

class CatalogTitleCell: UITableViewCell {

    
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
    
    #warning("parent may not be needed here")
    func initCell(topTrailersDataArr: TopTrailersDataArr?, screenSize: CGSize, parent: CatalogController?) {
        self.topTrailersDataArr = topTrailersDataArr
        self.screenSize = screenSize
        self.parent = parent
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
        cell.trailerPlayerDelegate = CatalogController
        return cell
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
    
}
