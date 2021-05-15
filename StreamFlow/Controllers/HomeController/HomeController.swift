//
//  HomeController.swift
//  StreamFlow
//
//  Created by ilomidze on 08.05.21.
//

import UIKit

class HomeController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    
    enum ESectionName: Int {
        case newAdded = 1
        case populadMovies = 2
        case popularSeries = 3
    }
    
    
    let dataRequestManager = DataRequestManager()
    
    var movieOfTheDayData = MovieData() {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    var newAddedMoviesData = [MovieData]() {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
//                for i in 0...50 {
//                    print(self.newAddedMoviesData[i].cover?.small)
//                }
                
            }
        }
    }
    var popularMoviesData = [MovieData]() {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    var popularSeriesData = [MovieData]() {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    var apiLinksDict: [String: String] = [:]

    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "HomeController"
        navigationController?.navigationBar.barTintColor = UIColor.init(red: CGFloat(10/255), green: CGFloat(5/255), blue: CGFloat(10/255), alpha: 1)
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
        
        tableView.register(UINib(nibName: "TitleCell", bundle: nil), forCellReuseIdentifier: "TitleCell")
        tableView.register(UINib(nibName: "SectionCell", bundle: nil), forCellReuseIdentifier: "SectionCell")
        
        apiLinksDict = dataRequestManager.getApiLinksDict()
        
        getMovieOfTheDayData(urlString: apiLinksDict["movieOfTheDay"]!)
        getNewAddedMoviesData(urlString: apiLinksDict["newAddedMovies"]!)
        getPopularMoviesData(urlString: apiLinksDict["popularMovies"]!)
        getPopularSeriesData(urlString: apiLinksDict["popularSeries"]!)
    }
    
    
    //-
    func getMovieOfTheDayData(urlString: String) {
        dataRequestManager.getApiData(urlString: urlString) { [weak self] movieDataArr in
            self?.movieOfTheDayData = (movieDataArr.data?[0]) ?? MovieData()
        }
    }
    
    //-
    func getNewAddedMoviesData(urlString: String) {
        dataRequestManager.getApiData(urlString: urlString) { [weak self] movieDataArr in
            self?.newAddedMoviesData = movieDataArr.data ?? [MovieData()]
        }
    }
    
    //-
    func getPopularMoviesData(urlString: String) {
        dataRequestManager.getApiData(urlString: urlString) { [weak self] movieDataArr in
            self?.popularMoviesData = movieDataArr.data ?? [MovieData()]
        }
    }
    
    //-
    func getPopularSeriesData(urlString: String) {
        dataRequestManager.getApiData(urlString: urlString) { [weak self] movieDataArr in
            self?.popularSeriesData = movieDataArr.data ?? [MovieData()]
        }
    }
}


