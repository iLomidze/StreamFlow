//
//  FilteredCatalogController.swift
//  StreamFlow
//
//  Created by Irakli Lomidze on 17.06.21.
//

import UIKit

class FilteredCatalogController: UIViewController {

    // MARK: - Outlets
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    
    // MARK: - Properties
    
    var dataFetcher: DataFetcherType = DataRequestManager()
    
    var id: Int?
    var isGenre = true
    var downloadPage = 1
    var savedIndexPath = IndexPath(item: 0, section: 0)
    var isDataFetched = false {
        didSet {
            if isDataFetched {
                print("isDataFetched - true")
            } else {
                print("isDataFetched - false")
            }
            
        }
    }
    var isCellsLoaded = false
    
    var data: MovieDataArr?  // {
//        didSet {
//            DispatchQueue.main.async { [weak self] in
//                self?.collectionView.reloadData()
//            }
//        }
//    }
    
    
    
    // MARK: - Executive
    
    override func viewDidLoad() {
        super.viewDidLoad()
         
        collectionView.register(UINib(nibName: "MovieListCollectionCell", bundle: nil), forCellWithReuseIdentifier: "MovieListCollectionCell")
    }
    
    
    // MARK: - Functions
    
    func initVC(name: String, id: Int, isGenre: Bool) {
        self.id = id
        self.isGenre = isGenre
        fetchData(id: id, pageNum: downloadPage)
        title = name
    }

    
    func fetchData(id: Int, pageNum: Int, append: Bool = false) {
        var networkRequestType: FilteredCatalogNetworkRequest
        if isGenre {
            networkRequestType = FilteredCatalogNetworkRequest.genre(genreId: id, pageNum: pageNum)
        } else {
            networkRequestType = FilteredCatalogNetworkRequest.studio(studioId: id, pageNum: pageNum)
        }
        
        isDataFetched = false
        dataFetcher.getData(requestType: networkRequestType , completion: { [weak self] (result: Result<MovieDataArr, ErrorRequests>) in
            switch result {
            case .failure(let error):
                print("Error Getting FilteredCatalog Data - \(error.localizedDescription)")
            case .success(let movieDataArr):
                self?.fetchAllImages(dataArr: movieDataArr) { dataArrWithImage in
                    
                    if append {
                        self?.data?.data? += dataArrWithImage.data!
                        DispatchQueue.main.async {
                            self?.collectionView.performBatchUpdates({
                                self?.isDataFetched = true
                                self?.collectionView.reloadData()
                            }, completion: nil)
                        }
                        
                    } else {
                        self?.data = dataArrWithImage
                        DispatchQueue.main.async {
                            self?.isDataFetched = true
                            self?.collectionView.reloadData()
                        }
                    }
                }
            }
        })
    }
    
    func fetchAllImages(dataArr: MovieDataArr, completion: @escaping (MovieDataArr) -> Void) {
        var countFetched = 0
        let maxFetchCount = dataArr.data?.count
        
        let dataArrWithImage = dataArr
        
        for i in 0..<(maxFetchCount ?? 0) {
            guard let urlString = dataArrWithImage.data?[i].covers?.data?.minSize else { continue }
            
            dataFetcher.getImage(urlString: urlString) { (result: Result<Data, ErrorRequests>) in
                countFetched += 1
                switch result {
                case .failure(let error):
                    print("Cant download image for FilteredCatalog - \(error.localizedDescription)")
                case .success(let imgData):
                    dataArrWithImage.data![i].imageData = imgData
                    if countFetched == maxFetchCount {
                        completion(dataArrWithImage)
                    }
                }
            }
        }
    }
    
    func fetchDataIfNeeded(indexPath: IndexPath) {
        guard let dataCount = data?.data?.count else { return }
        
        if !isDataFetched { return }
        
        let indexPathNumb = indexPath.item
        
        if indexPathNumb > (dataCount - 5) {
            isCellsLoaded = false
            downloadPage += 1
            fetchData(id: id!, pageNum: downloadPage, append: true)
        }
    }
    
    // End Class
}
