//
//  HomeController.swift
//  StreamFlow
//
//  Created by ilomidze on 08.05.21.
//

import UIKit


class HomeController: UIViewController {
    
    // MARK: - Outlets
    
    @IBOutlet weak var tableView: UITableView!
    
    
    // MARK: - Properties
    
    // MARK: General Properties
    
    var isTabBarMoveFinished = true
    
    var movieOfTheDayDataIsDownloaded = false
    var newAddedMoviesDataIsDownloaded = false
    var popularMoviesDataIsDownloaded = false
    var popularSeriesDataIsDownloaded = false
    var continueWatchingIsDownloaded = false
    
    var dataFetcher: DataFetcherType?

    
    // MARK: Data for each Section
    
    var movieOfTheDayData = MovieData() {
        didSet {
            downloadSectionMovieImages(on: .movieOfTheDay)
        }
    }
    ///
    var newAddedMoviesData = [MovieData]() {
        didSet {
            downloadSectionMovieImages(on: .newAdded)
        }
    }
    ///
    var popularMoviesData = [MovieData]() {
        didSet {
            downloadSectionMovieImages(on: .popularMovies)
        }
    }
    ///
    var popularSeriesData = [MovieData]() {
        didSet {
            downloadSectionMovieImages(on: .popularSeries)
        }
    }
    ///
    var continueWatchingMovieData = [MovieData]()
    
    let firestoreManager = FirestoreManager()
    /// Number of raws in tableview (will change to 5 when "continue watching movies exists/set)
    var tableNumOfRows = 4
    
    
    // MARK: - Execution
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UINib(nibName: "TitleCell", bundle: nil), forCellReuseIdentifier: "TitleCell")
        tableView.register(UINib(nibName: "SectionCell", bundle: nil), forCellReuseIdentifier: "SectionCell")
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "profileIcon"), style: .plain, target: self, action: #selector(profileBtnAction))
        
        let nc = NotificationCenter.default
        nc.addObserver(self, selector: #selector(updateContinueWatching), name: Notification.Name(NotificationCenterKeys.continueWatchingUpdated.rawValue), object: nil)
        
        getMovieOfTheDayData()
        getNewAddedMoviesData()
        getPopularMoviesData()
        getPopularSeriesData()
        
        updateContinueWatchingData()
        
        // To hide !Tabbar Space! when Tabbar is hidden and tableview is scrolled in the bottom
        if #available(iOS 11.0, *) {
            self.tableView.contentInsetAdjustmentBehavior = .never
        }
    }
    
    
    // MARK: - Functions
    
    // MARK: General Functions
    
    ///
    @objc func updateContinueWatching() {
        updateContinueWatchingData()
        tableView.reloadData()
    }
    
    ///
    @objc func profileBtnAction() {
        let secondaryStoryboard = UIStoryboard(name: "Secondary", bundle: nil)
        guard let profileVC = secondaryStoryboard.instantiateViewController(identifier: "ProfileController") as? ProfileController else { return }
        profileVC.playerControllerDelegate = self
        navigationController?.pushViewController(profileVC, animated: true)
    }
    
    
    // MARK: Fetching Data
    
    /// Gets Movie of the day Data from iMovies API
    func getMovieOfTheDayData() {
        dataFetcher?.getData(requestType: HomeNetworkRequest.movieOfTheDay) { [weak self] (result: Result<MovieDataArr, ErrorRequests>)  in
            switch result {
            case .failure(let error):
                print(error)
            case .success(let movieDataArr):
                self?.movieOfTheDayData = (movieDataArr.data?[0]) ?? MovieData()
            }
        }
    }
    
    /// Gets New added movies Data from iMovies API
    func getNewAddedMoviesData() {
        dataFetcher?.getData(requestType: HomeNetworkRequest.newAddedMovies) { [weak self] (result: Result<MovieDataArr, ErrorRequests>) in
            switch result {
            case .failure(let error):
                print(error)
            case .success(let movieDataArr):
                self?.newAddedMoviesData = movieDataArr.data ?? [MovieData()]
            }
        }
    }
    
    /// Gets Popular  movies Data from iMovies API
    func getPopularMoviesData() {
        dataFetcher?.getData(requestType: HomeNetworkRequest.popularMovies) { [weak self] (result: Result<MovieDataArr, ErrorRequests>) in
            switch result {
            case .failure(let error):
                print(error)
            case .success(let movieDataArr):
                self?.popularMoviesData = movieDataArr.data ?? [MovieData()]
            }
        }
    }
    
    /// Gets Popular  series Data from iMovies API
    func getPopularSeriesData() {
        dataFetcher?.getData(requestType: HomeNetworkRequest.popularSeries) { [weak self] (result: Result<MovieDataArr, ErrorRequests>) in
            switch result {
            case .failure(let error):
                print(error)
            case .success(let movieDataArr):
                self?.popularSeriesData = movieDataArr.data ?? [MovieData()]
            }
        }
    }
    
    
    
    // MARK: Fetching Images
    
    /// Downloads all the images for the corresponding section class and saves them in that class data
    func downloadSectionMovieImages(on sectionName: SectionNames) {
        // choose which section class should be changed
        var editableSectionClass: [MovieData]
        
        switch sectionName {
        case .movieOfTheDay:
            if movieOfTheDayDataIsDownloaded {
                return
            }
            movieOfTheDayDataIsDownloaded = true
            editableSectionClass = [movieOfTheDayData]
        case .newAdded:
            if newAddedMoviesDataIsDownloaded {
                return
            }
            newAddedMoviesDataIsDownloaded = true
            editableSectionClass = newAddedMoviesData
        case .popularMovies:
            if popularMoviesDataIsDownloaded {
                return
            }
            popularMoviesDataIsDownloaded = true
            editableSectionClass = popularMoviesData
        case .popularSeries:
            if popularSeriesDataIsDownloaded {
                return
            }
            popularSeriesDataIsDownloaded = true
            editableSectionClass = popularSeriesData
        case .continueWatching:
            print("HomeController: ")
            continueWatchingIsDownloaded = true
            editableSectionClass = popularSeriesData
        }
        
        if sectionName != .movieOfTheDay {
            //To add number of cells according to the fetched data
            DispatchQueue.main.async { [weak self] in
                self?.tableView.reloadData()
            }
        }
        
        //Download image for each cell
        for itemIndex in 0..<(editableSectionClass.count) {
            if sectionName == .movieOfTheDay {
                guard let maxSizeImageURL = editableSectionClass[itemIndex].covers?.data?.maxSize else {
                    print("\(sectionName): No cover url in \(itemIndex)th element")
                    return
                }
                downloadImageAndUpdateCell(for: editableSectionClass[itemIndex], from: maxSizeImageURL, sectionName: sectionName, itemInSection: itemIndex)
            } else {
                guard let minSizeImageURL = editableSectionClass[itemIndex].covers?.data?.minSize else {
                    print("\(sectionName): No cover url in \(itemIndex)th element")
                    return
                }
                downloadImageAndUpdateCell(for: editableSectionClass[itemIndex], from: minSizeImageURL, sectionName: sectionName, itemInSection: itemIndex)
            }
        }
    }
    
    
    /// Downloads image from url, Saves int to specified MovieData class data and Updates appropriate  [titleCell or collectionView cell]
    func downloadImageAndUpdateCell(for movieData: MovieData, from urlString: String, sectionName: SectionNames, itemInSection: Int) {
        dataFetcher?.getImage(urlString: urlString) { [weak self] resultData in
            switch resultData {
            case .failure(let error):
                print("Error: Cover image download for \(String(describing: movieData.originalName ?? "No Movie Name"))  - \(error)")
                movieData.imageData = UIImage(named: "noMovieCover")!.pngData() 
            case .success(let data):
                movieData.imageData = data
                
                DispatchQueue.main.async {
                    if sectionName == .movieOfTheDay {
                        let titleCell = self?.tableView.cellForRow(at: IndexPath(row: sectionName.rawValue, section: 0)) as! TitleCell
                        
                        titleCell.updateImage()
                        self?.tableView.reloadRows(at: [IndexPath(row: sectionName.rawValue, section: 0)], with: .automatic)
                        
                    } else {
                        let rowNum: Int
                        if self?.tableView.numberOfRows(inSection: 0) == 4 {
                            rowNum = sectionName.rawValue
                        } else {
                            if sectionName.rawValue == 4 {
                                rowNum = 1
                            } else {
                                rowNum = sectionName.rawValue + 1
                            }
                        }
                        
                        if let sectionCell = self?.tableView.cellForRow(at: IndexPath(row: rowNum, section: 0)) as? SectionCell {
                            
                            sectionCell.updateImageForMovieListCollectionCell(at: itemInSection)
                        }
                    }
                }
            }
        }
    }
    
    /// Downloads movie data based on ID's in database Array (storing ID & PlaybackTime)
    func getContinueWatchingData() {
        continueWatchingMovieData = [MovieData]()
        let contWatchData = ContinueWatchingData.getData()
//        let contWatchData: [String : Double] = [:]
        
        let filteredKeys = getRawMovieIDs(for: Array(contWatchData.keys))
        
        let countAllContWatchData = filteredKeys.count
        var countCurContWatchData = 0
        
        for id in filteredKeys {
            dataFetcher?.getData(requestType: PlayerNetworkRequest.movieDesc(id: id), completion: { [weak self] (result: Result<MovieDataSingle, ErrorRequests>) in
                countCurContWatchData += 1
                switch result {
                
                case .failure(let error):
                    print("HomeController: ", error.localizedDescription)
                    
                case .success(let movieDataSingle):
                    guard let movieData = movieDataSingle.data else { print("HomeController: ", "Data Error"); return }
                    
                    guard let imgUrl = movieData.covers?.data?.maxSize else {
                        print("HomeController: ", "image N/A")
                        self?.continueWatchingMovieData.append(movieData)
                        if countAllContWatchData == countCurContWatchData {
                            DispatchQueue.main.async {
                                if self?.tableNumOfRows == 4 {
                                    self?.tableNumOfRows = 5
                                    self?.tableView.reloadData()
                                } else {
                                    self?.tableView.reloadRows(at: [IndexPath(item: 1, section: 0)], with: .automatic)
                                }
                            }
                        }
                        return
                    }
                    self?.dataFetcher?.getImage(urlString: imgUrl, completion: { (imgResult: Result<Data, ErrorRequests>) in
                        switch imgResult{
                        case .failure(let error):
                            print("HomeController: ", error.localizedDescription)
                        case .success(let imgDataRes):
                            movieData.imageData = imgDataRes
                            self?.continueWatchingMovieData.append(movieData)
                            
                            if countAllContWatchData == countCurContWatchData {
                                DispatchQueue.main.async {
                                    if self?.tableNumOfRows == 4 {
                                        self?.tableNumOfRows = 5
                                        self?.tableView.reloadData()
                                    } else {
                                        self?.tableView.reloadRows(at: [IndexPath(item: 1, section: 0)], with: .automatic)
                                    }
                                }
                            }
                        }
                    })

                }
            })
        }
    }
    
    /// Filters  movie id suffix: Separator, Season and  Episode markers && removes similar ID s
    func getRawMovieIDs(for keys: [String]) -> [String] {
        var filteredKeys = [String]()
        let idSuffix = ContinueWatchingData.idSuffix
        
        for k in keys {
            if let endIndex = k.indexOfSubString(of: idSuffix) {
                let rawId = String(k[..<endIndex])
                if !filteredKeys.contains(rawId) {
                    filteredKeys.append(rawId)
                }
            } else {
                filteredKeys.append(k)
            }
        }
        return filteredKeys
    }
    
    
    
    // MARK: Firebase | UserDefault functions
    
    /// Updates array - which is storing movie ID & PlaybackTime
    func updateContinueWatchingData(clearData: Bool = false) {
        if clearData {
            continueWatchingMovieData = [MovieData]()
            tableNumOfRows = 4
            tableView.reloadData()
            
            return
        }
        firestoreManager.fetchAllDataFirestore { [weak self] result in
            switch result {
            case .failure(let error):
                print(error.localizedDescription)
                ContinueWatchingData.getUserDefaultsData()
                self?.getContinueWatchingData()
//                continueWatchingMovieData = ContinueWatchingData.getData()
            case .success():
                ContinueWatchingData.updateData(data: self?.firestoreManager.getData() ?? [:])
                self?.getContinueWatchingData()
            }
        }
    }
    
    // End Class
}



