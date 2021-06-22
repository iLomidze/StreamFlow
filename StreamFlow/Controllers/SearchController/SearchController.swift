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
    @IBOutlet weak var imoviesLogo: UIImageView!
    
    
    // MARK: - Properties
    
    var dataFetcher = DataRequestManager()
    var moviesDataArr: MovieDataArr? {
        didSet {
            DispatchQueue.main.async { [weak self] in
                if let listSize = self?.moviesDataArr?.data?.count {
                    if listSize > 0 {
                        self?.imoviesLogo.isHidden = true
                    } else {
                        self?.imoviesLogo.isHidden = false
                    }
                }
                self?.tableView.reloadData()
            }
        }
    }
    
    
    // MARK: - Executive
    
    override func viewDidLoad() {
        super.viewDidLoad()

//        title = "Search"
        
        tableView.register(UINib(nibName: "SearchTableCell", bundle: nil), forCellReuseIdentifier: "SearchTableCell")
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "profileIcon"), style: .plain, target: self, action: #selector(profileBtnAction))
        
        addSingleTapRecognizer()
    }
    
    
    // MARK: - Functions
    
    ///
    @objc func profileBtnAction() {
        let secondaryStoryboard = UIStoryboard(name: "Secondary", bundle: nil)
        guard let profileVC = secondaryStoryboard.instantiateViewController(identifier: "ProfileController") as? ProfileController else { return }
        navigationController?.pushViewController(profileVC, animated: true)
    }
    
    ///
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
    
    ///
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
    
    ///
    func addSingleTapRecognizer() {
        let singleTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(singleTap(sender:)))
        singleTapGestureRecognizer.numberOfTapsRequired = 1
        singleTapGestureRecognizer.isEnabled = true
        singleTapGestureRecognizer.cancelsTouchesInView = false
        self.view.addGestureRecognizer(singleTapGestureRecognizer)
    }
    
    ///
    @objc func singleTap(sender: UITapGestureRecognizer) {
        searchBar.endEditing(true)
    }
    
    // End Class
}


extension SearchController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let searchWord = searchBar.text {
            fetchData(searchWord: searchWord)
        }
        searchBar.resignFirstResponder()
    }
    
    func searchBarShouldEndEditing(_ searchBar: UISearchBar) -> Bool {
        searchBar.resignFirstResponder()
        return true
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
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        searchBar.endEditing(true)
    }
}
