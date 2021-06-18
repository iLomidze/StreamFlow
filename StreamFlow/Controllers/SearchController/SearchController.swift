//
//  SearchController.swift
//  StreamFlow
//
//  Created by ilomidze on 08.05.21.
//

import UIKit

class SearchController: UIViewController {

    // MARK: - Outlets
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    
    // MARK: - Properties
    
    var dataFetcher = DataRequestManager()
    var moviesDataArr: MovieDataArr? {
        didSet {
            DispatchQueue.main.async { [weak self] in
                self?.tableView.reloadData()
            }
        }
    }
    
    
    // MARK: - Executive
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "SearchController"
        tableView.register(UINib(nibName: "SearchTableCell", bundle: nil), forCellReuseIdentifier: "SearchTableCell")
    }
    
    
    // MARK: - Functions
    
    func fetchData(searchWord: String) {
        dataFetcher.getData(requestType: SearchNetworkRequest.searchBasic(searchWord: searchWord)) { [weak self] (result: Result<MovieDataArr, ErrorRequests>) in
            switch result {
            case .failure(let error):
                print("Error - searching movie - \(error.localizedDescription)")
            case .success(let moviesDataArr):
                self?.fetchAllImages(dataArr: moviesDataArr, completion: { dataWithImages in
                    self?.moviesDataArr = dataWithImages
                })
            }
        }
    }
    
    func fetchAllImages(dataArr: MovieDataArr, completion: @escaping (MovieDataArr) -> Void) {
        var countFetched = 0
        let maxFetchCount = dataArr.data?.count ?? 0
        
        let dataArrWithImage = dataArr
        
        for i in 0..<(maxFetchCount) {
            guard let urlString = dataArrWithImage.data?[i].covers?.data?.maxSize else { continue }
            
            dataFetcher.getImage(urlString: urlString) { (result: Result<Data, ErrorRequests>) in
                countFetched += 1
                switch result {
                case .failure(let error):
                    print("Cant download image for FilteredCatalog - \(error.localizedDescription)")
                case .success(let imgData):
                    dataArrWithImage.data?[i].imageData = imgData
                    if countFetched == maxFetchCount {
                        completion(dataArrWithImage)
                    }
                }
            }
        }
    }
    
}


extension SearchController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let searchWord = searchBar.text {
            fetchData(searchWord: searchWord)
        }
        searchBar.resignFirstResponder()
    }
}


extension SearchController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        moviesDataArr?.data?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "SearchTableCell", for: indexPath) as? SearchTableCell else { fatalError("Cant dequeue SearchTableCell") }
        
        cell.initCell(data: moviesDataArr!.data![indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let storyboard = self.storyboard else { return }
        guard let data = moviesDataArr?.data?[indexPath.row] else { return }
        guard let vc = PlayerController.prepare(withData: data, onStoryboard: storyboard, dataFetcher: self.dataFetcher) else { return }
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
