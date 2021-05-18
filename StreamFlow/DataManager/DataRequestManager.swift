//
//  DataRequestManager.swift
//  StreamFlow
//
//  Created by ilomidze on 09.05.21.
//

import Foundation


protocol NetworkRequestType {
    
}

class DataRequestManager {
    
    public static let instance = DataRequestManager()
    
    private init(){
    }
    
    //-
    func getApiLinksDict() -> [String: String]{
        let apiLinksDict = [
            "movieOfTheDay": "https://api.imovies.cc/api/v1/movies/movie-day?page=1&per_page=1",
            "newAddedMovies": "https://api.imovies.cc/api/v1/movies?filters%5Bwith_files%5D=yes&filters%5Btype%5D=movie&sort=-upload_date&per_page=55",
            "popularMovies": "https://api.imovies.cc/api/v1/movies/top?type=movie&period=day&page=1&per_page=20",
            "popularSeries": "https://api.imovies.cc/api/v1/movies/top?type=series&period=day&per_page=55"
        ]
        
        return apiLinksDict
    }
    
    
    // Generic funcion for getting data
    func getData<DataType: Codable>(urlString: String, completiton: @escaping (DataType) -> Void) {
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
                var jsonDataOpt: DataType?
                do {
                    jsonDataOpt = try JSONDecoder().decode(DataType.self, from: data)
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
            let url = URL(string: urlString)
            let request = URLRequest(url: url!)
            
            let task = URLSession.shared.dataTask(with: request) { data, responce, error in
                guard let data = data, error == nil else {
                    print("Something went wrong during image data download")
                    return
                }
                
                completiton(data)
            }
            
            task.resume()
        }
    }
    
    //ec
}
