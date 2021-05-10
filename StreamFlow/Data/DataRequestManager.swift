//
//  DataRequestManager.swift
//  StreamFlow
//
//  Created by ilomidze on 09.05.21.
//

import Foundation


class DataRequestManager {
    //-
    func getApiLinksDict() -> [String: String]{
        #warning("linkebi shesavsebia")
        let apiLinksDict = [
            "movieOfTheDay": "https://api.imovies.cc/api/v1/movies/movie-day?page=1&per_page=1",
            "newAddedMovies": "",
            "popularMovies": "https://api.imovies.cc/api/v1/movies/top?type=movie&period=day&page=1&per_page=20",
            "popularSeries": ""
        ]
        
        return apiLinksDict
    }
    
    // -
    func getApiData(urlString: String, completiton: @escaping (MovieDataArr) -> Void) {
        DispatchQueue.global().async {
            let url = URL(string: urlString)
            var request = URLRequest(url: url!)
            request.setValue("User-Agent", forHTTPHeaderField: "imovies")
            
            let task = URLSession.shared.dataTask(with: request) { data, responce, error in
                guard let data = data, error == nil else {
                    print("Something went wrong")
                    return
                }
                
                // Now we have data
                var jsonDataOpt: MovieDataArr?
                do {
                    jsonDataOpt = try JSONDecoder().decode(MovieDataArr.self, from: data)
                }
                catch {
                    print("failed to convert \(error.localizedDescription)")
                }
                
                guard let jsonData = jsonDataOpt else {
                    return
                }
                
                completiton(jsonData)
            }
            
            task.resume()
        }
    }
    
    //-
    func getImage(urlString: String, completiton: @escaping (Data) -> Void) {
        DispatchQueue.global().async {
            print(urlString)
            let url = URL(string: urlString)
            let request = URLRequest(url: url!)
            
            let task = URLSession.shared.dataTask(with: request) { data, responce, error in
                guard let data = data, error == nil else {
                    print("Something went wrong")
                    return
                }
                
                completiton(data)
            }
            
            task.resume()
        }
    }
    
    //ec
}
