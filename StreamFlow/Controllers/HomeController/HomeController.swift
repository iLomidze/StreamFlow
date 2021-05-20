//
//  HomeController.swift
//  StreamFlow
//
//  Created by ilomidze on 08.05.21.
//

import UIKit

class HomeController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    
    var newAddedMoviesDataIsDownloaded = false
    var popularMoviesDataIsDownloaded = false
    var popularSeriesDataIsDownloaded = false
    
    
    var movieOfTheDayData = MovieData() {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    //-
    var newAddedMoviesData = [MovieData]() {
        didSet {
            if newAddedMoviesDataIsDownloaded {
                return
            }
            
            newAddedMoviesDataIsDownloaded = true
            
            DispatchQueue.main.async { [weak self] in
                
                self?.tableView.reloadData()
                
                for i in 0..<(self?.newAddedMoviesData.count ?? 1) {
                    guard let minSizeImageURL = self?.newAddedMoviesData[i].covers?.data?.minSize else {
                        print("New added movies: No cover url in \(i)th element")
                        return
                    }
                    DataRequestManager.instance.getImage(urlString: minSizeImageURL) { [weak self] resultData in
                        
                        switch resultData {
                        case .failure(let error):
                            print("Error: \(String(describing: self?.newAddedMoviesData[i].originalName)) - \(error)")
                            self?.newAddedMoviesData[i].imageData = UIImage(named: "NoMovieCover")!.pngData()
                        case .success(let data):
                            self?.newAddedMoviesData[i].imageData = data
                            
                            DispatchQueue.main.async {
                                // aq optionalad gadakaste as?
                                let sectionCell = self?.tableView.cellForRow(at: IndexPath(row: 1, section: 0)) as! SectionCell
                                
                                if let movieListCollectionCell = sectionCell.collectionView.cellForItem(at: IndexPath(item: i, section: 0)) as? MovieListCollectionCell {
                                
                                    movieListCollectionCell.updateImage()
                                    sectionCell.collectionView.reloadItems(at: [IndexPath(item: i, section: 0)])
                                }
                            }
                        }
                       
                    }
                }
            }
        }
    }
    
    var popularMoviesData = [MovieData]() {
        didSet {
            DispatchQueue.main.async { [weak self] in
//                for i in 0..<(self?.popularMoviesData.count ?? 1) {
//                    guard let minSizeImageURL = self?.popularMoviesData[i].covers?.data?.minSize else {
//                        print("Popular Movies: No cover url in \(i)th element")
//                        return
//                    }
//                    self?.dataRequestManager.getImage(urlString: minSizeImageURL) { [weak self] data in
//                        self?.popularMoviesData[i].imageData = data
//                    }
//                }
                self?.tableView.reloadData()
            }
        }
    }
    
    var popularSeriesData = [MovieData]() {
        didSet {
            DispatchQueue.main.async { [weak self] in
//                for i in 0..<(self?.popularSeriesData.count ?? 1) {
//                    guard let minSizeImageURL = self?.popularSeriesData[i].covers?.data?.minSize else {
//                        print("Popular Series: No cover url in \(i)th element")
//                        return
//                    }
//                    self?.dataRequestManager.getImage(urlString: minSizeImageURL) { [weak self] data in
//                        self?.popularSeriesData[i].imageData = data
//                    }
//                }
                self?.tableView.reloadData()
            }
        }
    }

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "HomeController"
        navigationController?.navigationBar.barTintColor = UIColor.init(red: CGFloat(10/255), green: CGFloat(5/255), blue: CGFloat(10/255), alpha: 1)
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
        
        tableView.register(UINib(nibName: "TitleCell", bundle: nil), forCellReuseIdentifier: "TitleCell")
        tableView.register(UINib(nibName: "SectionCell", bundle: nil), forCellReuseIdentifier: "SectionCell")
        
        getMovieOfTheDayData()
        getNewAddedMoviesData()
//        getPopularMoviesData()
//        getPopularSeriesData()
    }
    
    
    //-
    func getMovieOfTheDayData() {
        DataRequestManager.instance.getData(request: HomeNetworkRequest.movieOfTheDay) { [weak self] (movieDataArr: MovieDataArr?) in
            self?.movieOfTheDayData = (movieDataArr?.data?[0]) ?? MovieData()
        }
    }
    
    //-
    func getNewAddedMoviesData() {
        DataRequestManager.instance.getData(request: HomeNetworkRequest.newAddedMovies) { [weak self] (movieDataArr: MovieDataArr?) in
            self?.newAddedMoviesData = movieDataArr?.data ?? [MovieData()]
        }
    }
    
    //-
    func getPopularMoviesData() {
        DataRequestManager.instance.getData(request: HomeNetworkRequest.popularMovies) { [weak self] (movieDataArr: MovieDataArr?) in
            self?.popularMoviesData = movieDataArr?.data ?? [MovieData()]
        }
    }
    
    //-
    func getPopularSeriesData() {
        DataRequestManager.instance.getData(request: HomeNetworkRequest.popularSeries) { [weak self] (movieDataArr: MovieDataArr?) in
            self?.popularSeriesData = movieDataArr?.data ?? [MovieData()]
        }
    }
    
    func downloadSectionMovieImages() {
        
    }
}


