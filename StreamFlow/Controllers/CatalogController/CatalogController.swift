//
//  CatalogController.swift
//  StreamFlow
//
//  Created by ilomidze on 08.05.21.
//

import UIKit
import AVFoundation
import AVKit

class CatalogController: UIViewController {

    // MARK: - Outlets
    
    @IBOutlet weak var tableView: UITableView!
    
    
    // MARK: - Properties
    
    var dataFetcher: DataFetcherType?
    
    var topTrailersData: TopTrailersDataArr? {
        didSet {
            DispatchQueue.main.async { [weak self] in
                self?.tableView.reloadRows(at: [IndexPath(row: 0, section: 0)], with: .automatic)
            }
        }
    }
    var allGenresData: AllGenresData? {
        didSet {
            DispatchQueue.main.async { [weak self] in
                self?.tableView.reloadRows(at: [IndexPath(row: 1, section: 0)], with: .automatic)
            }
        }
    }
    var topStudiosData: TopStudiosDataArr? {
        didSet {
            DispatchQueue.main.async { [weak self] in
                self?.tableView.reloadRows(at: [IndexPath(row: 2, section: 0)], with: .automatic)
            }
            
        }
    }
    
    
    
    // MARK: - Executive
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Catalog"
        
        tableView.register(UINib(nibName: "CatalogTitleCell", bundle: nil), forCellReuseIdentifier: "CatalogTitleCell")
        tableView.register(UINib(nibName: "CatalogSectionCell", bundle: nil), forCellReuseIdentifier: "CatalogSectionCell")

        dataFetcher = DataRequestManager()
        
        fetchAllGenre()
        fetchTopStudios()
        fetchTopTrailers()
    }
    
    
    // MARK: - Functions
    
    ///
    func fetchAllGenre() {
        dataFetcher?.getData(requestType: CatalogNetworkRequest.allGenre, completion: { [weak self] (result: Result<AllGenresData, ErrorRequests>) in
            switch result {
            case .failure(let error):
                print(error)
            case .success(let allGenresData):
                self?.allGenresData = allGenresData
            }
        })
    }
    
    ///
    func fetchTopStudios() {
        dataFetcher?.getData(requestType: CatalogNetworkRequest.topStudios, completion: { [weak self] (result: Result<TopStudiosDataArr, ErrorRequests>) in
            switch result {
            case .failure(let error):
                print(error)
            case .success(let fetchedStudioData):
                self?.fetchStudioImages(data: fetchedStudioData) { updatedStudioData in
                    self?.topStudiosData = updatedStudioData
                }
            }
        })
    }
    
    ///
    func fetchStudioImages(data: TopStudiosDataArr, completion: @escaping (TopStudiosDataArr) -> Void ) {
        var updatedData = data
        var count = 0
        
        for i in 0..<(data.data.count) {
            let urlString = data.data[i].poster
            dataFetcher?.getImage(urlString: urlString, completion: { (result: Result<Data, ErrorRequests>) in
                count += 1
                switch result {
                case .failure(let error):
                    print(error)
                case .success(let imgData):
                    updatedData.data[i].imgData = imgData
                    if count == data.data.count {
                        completion(updatedData)
                    }
                }
            })
        }
    }
    
    ///
    func fetchTopTrailers() {
        dataFetcher?.getData(requestType: CatalogNetworkRequest.topTrailers, completion: { [weak self]  (result: Result<TopTrailersDataArr, ErrorRequests>) in
            switch result {
            case .failure(let error):
                print("Cant get TopTrailersData - \(error.localizedDescription)")
            case .success(let trailerData):
                self?.fetchTrailerImages(data: trailerData) { updatedTrailerData in
                    self?.topTrailersData = updatedTrailerData
                }
            }
        })
    }
    
    ///
    func fetchTrailerImages(data: TopTrailersDataArr, completion: @escaping (TopTrailersDataArr) -> Void ) {
        var updatedData = data
        var count = 0
        
        for i in 0..<(data.data.count) {
            guard let urlString = data.data[i].covers.data?.maxSize else { print("No Cover for \(data.data[i].originalName)"); continue }
            dataFetcher?.getImage(urlString: urlString, completion: { (result: Result<Data, ErrorRequests>) in
                count += 1
                switch result {
                case .failure(let error):
                    print(error)
                case .success(let imgData):
                    updatedData.data[i].imgData = imgData
                    if count == data.data.count {
                        completion(updatedData)
                    }
                }
            })
        }
    }
    // End Class
}



extension CatalogController: TrailerPlayDelegate {
    func playTrailer(videoStringURL: String) {
        runPlayer(videoStringURL: videoStringURL)
    }
    
    ///
    func runPlayer(videoStringURL: String) {
        
        if videoStringURL == "" {
            let ac = UIAlertController(title: "ვიდეოს ლინკი ცარიელია", message: nil, preferredStyle: .alert)
            present(ac, animated: true, completion: nil)
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                ac.dismiss(animated: true, completion: nil)
            }
            return
        }
        
        let videoURL = URL(string: videoStringURL)
        
        let headers: [String: String] = [
           "User-Agent": "imovies"
        ]
        
        DispatchQueue.main.async {
            let asset = AVURLAsset(url: videoURL!, options: ["AVURLAssetHTTPHeaderFieldsKey": headers])
            let playerItem = AVPlayerItem(asset: asset)
            let player = AVPlayer(playerItem: playerItem)
            let playerController = AVPlayerViewController()
            playerController.player = player
            self.present(playerController, animated: true, completion: nil)
        }
    }
}


extension CatalogController: StudioFilterDelegate, GenreFilterDelegate {
    func genreFilter(id: Int, name: String) {
        let secondStoryboard = UIStoryboard(name: "Secondary", bundle: nil)
        guard let vc = secondStoryboard.instantiateViewController(identifier: "FilteredCatalogController") as? FilteredCatalogController else { fatalError("cant instantiate FilteredCatalogController") }
        vc.initVC(name: name, id: id, isGenre: true)
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func studioFilter(id: Int, name: String) {
        let secondStoryboard = UIStoryboard(name: "Secondary", bundle: nil)
        guard let vc = secondStoryboard.instantiateViewController(identifier: "FilteredCatalogController") as? FilteredCatalogController else { fatalError("cant instantiate FilteredCatalogController") }
        vc.initVC(name: name, id: id, isGenre: false)
        navigationController?.pushViewController(vc, animated: true)
    }
    //End Class
}
