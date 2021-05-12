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
    var moviesData = [MovieData]() {
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
        
        tableView.register(UINib(nibName: "TitleCell", bundle: nil), forCellReuseIdentifier: "TitleCell")
        tableView.register(UINib(nibName: "CommonCell", bundle: nil), forCellReuseIdentifier: "CommonCell")
        
        apiLinksDict = dataRequestManager.getApiLinksDict()
        
//        let urlString = "https://api.imovies.cc/api/v1/movies/movie-day?page=1&per_page=1"
        getMovieOfTheDayData(urlString: apiLinksDict["movieOfTheDay"]!)
    }
    
    
    func getMovieOfTheDayData(urlString: String) {
        dataRequestManager.getApiData(urlString: urlString) { [weak self] movieDataArr in
            self?.moviesData.append(movieDataArr.data[0])
        }
    }
}


