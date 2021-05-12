//
//  HomeController.swift
//  StreamFlow
//
//  Created by ilomidze on 08.05.21.
//

import UIKit

class HomeController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    let dataRequestManager = DataRequestManager()
    
    var movieOfTheDayData = MovieData() {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    var popularMoviesData = [MovieData]() {
        didSet {
            print(popularMoviesData.capacity)
        }
    }
    
    var apiLinksDict: [String: String] = [:]

    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "HomeController"
        
        tableView.register(UINib(nibName: "TitleCell", bundle: nil), forCellReuseIdentifier: "TitleCell")
        tableView.register(UINib(nibName: "CommonCell", bundle: nil), forCellReuseIdentifier: "CommonCell")
        
        apiLinksDict = dataRequestManager.getApiLinksDict()
        
        getMovieOfTheDayData(urlString: apiLinksDict["movieOfTheDay"]!)
        getPopularMoviesData(urlString: apiLinksDict["popularMovies"]!)
    }
    
    
    //-
    func getMovieOfTheDayData(urlString: String) {
        dataRequestManager.getApiData(urlString: urlString) { [weak self] movieDataArr in
            self?.movieOfTheDayData = (movieDataArr.data?[0]) ?? MovieData()
        }
    }
    
    func getPopularMoviesData(urlString: String) {
        dataRequestManager.getApiData(urlString: urlString) { [weak self] movieDataArr in
            self?.popularMoviesData = movieDataArr.data ?? [MovieData()]
        }
    }
}


