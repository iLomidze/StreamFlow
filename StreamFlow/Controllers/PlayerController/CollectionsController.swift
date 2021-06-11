//
//  ActorsCollection.swift
//  StreamFlow
//
//  Created by Irakli Lomidze on 04.06.21.
//

import Foundation
import UIKit
import SDWebImage

protocol SeasonChangeDelegate: AnyObject {
    func changeSeason(season: Int)
}

extension PlayerController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // First collection view
        if collectionView == actorsCollection {
            return castArr.count
        } else
    
        // Second collection view
        if collectionView == relatedMoviesCollection {
            return relatedMoviesData?.data.count ?? 0
        }

        // Third collection view
        if collectionView == seasonsCollectionView {
            return movieDescDataArr?.data.seasons?.data.count ?? 0
        }
        
        // Default
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // First collection view
        if collectionView == actorsCollection {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ActorsCell", for: indexPath) as? ActorsCell else {
                fatalError("PlayerController - CollectionView: Cant find ActorsCell")
            }
            
            let person = castArr[indexPath.item]
            
            if let imageData = person.imageData {
                cell.prepCell(name: person.originalName, imageData: imageData)
            } else {
                cell.prepCell(name: person.originalName, imageData: nil)
            }

            return cell
        }
        
        // Second collection view
        if collectionView == relatedMoviesCollection {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MovieListCollectionCell", for: indexPath) as? MovieListCollectionCell else {
                fatalError("PlayerController - CollectionView: Cant find ActorsCell")
            }
            
            cell.initCellForRelatedMovies(relatedMovisData: relatedMoviesData!.data[indexPath.item])

            return cell
        }
        
        // Third collection view
        if collectionView == seasonsCollectionView {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SeasonsCollectionCell", for: indexPath) as? SeasonsCollectionCell else {
                fatalError("PlayerController - CollectionView: Cant find SeasonsCollectionCell")
            }
            cell.seasonLabel.text = "სეზონი \(indexPath.row + 1)"
            
            return cell
        }
        
        // Default
        return UICollectionViewCell()
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == relatedMoviesCollection {
            let movieData = MovieData()
            movieData.originalName = relatedMoviesData?.data[indexPath.item].originalName
            movieData.secondaryName = relatedMoviesData?.data[indexPath.item].secondaryName
            movieData.imageData = relatedMoviesData?.data[indexPath.item].imageData
            movieData.id = relatedMoviesData?.data[indexPath.item].id
            movieData.isTvShow = relatedMoviesData?.data[indexPath.item].isTvShow
            
            guard let storyBoard = self.storyboard,
                  let vc = PlayerController.prepare(withData: movieData, onStoryboard: storyBoard, dataFetcher: self.dataFetcher) else { return }
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
        if collectionView == seasonsCollectionView {
            seasonDelegate?.changeSeason(season: (indexPath.item + 1) )
        }
    }
    
    // --
    
    // TODO: collection cell ebi gaaaswore
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
//                        sizeForItemAt indexPath: IndexPath) -> CGSize {
//
//    }
//
//    func collectionView(_ collectionView: UICollectionView,
//                        layout collectionViewLayout: UICollectionViewLayout,
//                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
//        return 1.0
//    }
//
//    func collectionView(_ collectionView: UICollectionView, layout
//        collectionViewLayout: UICollectionViewLayout,
//                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
//        return 1.0
//    }
    
    // End Class
}


