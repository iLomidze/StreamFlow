//
//  FilteredCatalCollection.swift
//  StreamFlow
//
//  Created by Irakli Lomidze on 17.06.21.
//

import Foundation
import UIKit

extension FilteredCatalogController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        data?.data?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MovieListCollectionCell", for: indexPath) as? MovieListCollectionCell else { fatalError("Cant dequeue MovieListCollectionCell") }
        
        cell.initCell(movieData: (data?.data![indexPath.row])!)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if let dataCount = data?.data?.count {
            if !isDataFetched {
                return
            }
            if indexPath.item >= dataCount - 10 {
                #warning("ramdenjerme shemodis - ratom??")
                print("willdisplay: indexpath >=..  - ", indexPath.item)
                downloadPage += 1
                isDataFetched = false
                fetchData(id: id!, pageNum: downloadPage, append: true)
            }
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let storyboard = self.storyboard else { return }
        guard let data = data?.data?[indexPath.row] else { return }
        guard let vc = PlayerController.prepare(withData: data, onStoryboard: storyboard, dataFetcher: self.dataFetcher) else { return }
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}