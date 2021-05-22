//
//  DataRequestManager.swift
//  StreamFlow
//
//  Created by ilomidze on 09.05.21.
//

import Foundation


protocol NetworkRequestType {
    var endPoint: String { get }
}

class DataRequestManager {
    
    public static let instance = DataRequestManager()
    
    private init(){
    }
    
    
    /// Generic function for getting data
    func getData<DataType: Codable>(request: NetworkRequestType, completion: @escaping (Result<DataType, ErrorRequests>) -> Void) {
        DispatchQueue.global().async {
            let url = URL(string: request.endPoint)
            var request = URLRequest(url: url!)
            request.setValue("User-Agent", forHTTPHeaderField: "imovies")
            
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                guard let data = data, error == nil else {
                    print("URL session went wrong")
                    completion(.failure(.urlSessionFailed))
                    return
                }
                
                // Now we have data
                var jsonDataOpt: DataType?
                do {
                    jsonDataOpt = try JSONDecoder().decode(DataType.self, from: data)
                }
                catch {
                    completion(.failure(.dataModelFailedForJSONParsing))
                    print("Failed to convert json - Error: \(error.localizedDescription)")
                }
                
                guard let jsonData = jsonDataOpt else {
                    return
                }
                
                completion(.success(jsonData))
            }
            
            task.resume()
        }
    }
    
    ///
    func getImage(urlString: String, completion: @escaping (Result<Data, ErrorRequests>) -> Void) {
        if urlString == "" {
            completion(.failure(.noURL))
            return
        }
        
        DispatchQueue.global().async {
            let url = URL(string: urlString)
            let request = URLRequest(url: url!)
            
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                guard let data = data, error == nil else {
                    print("Something went wrong during image data download")
                    completion(.failure(.urlSessionFailed))
                    return
                }
                completion(.success(data))
            }
            
            task.resume()
        }
    }
    
    //ec
}
