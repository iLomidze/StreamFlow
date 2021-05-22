//
//  DataRequestManager.swift
//  StreamFlow
//
//  Created by ilomidze on 09.05.21.
//

import Foundation

///
protocol NetworkRequestType {
    var endPoint: String { get }
    var params: [String: String] { get }
    var header: [String: String] { get }
}

class DataRequestManager {
    
    /// For singelton patters
    public static let instance = DataRequestManager()
    
    /// private - not to be created from outside
    private init(){
    }
    
    
    /// Generic function for getting data
    func getData<DataType: Codable>(requestType: NetworkRequestType, completion: @escaping (Result<DataType, ErrorRequests>) -> Void) {
        DispatchQueue.global().async {
            // setting up url request with components
            var components = URLComponents(string: requestType.endPoint)
            components?.queryItems = requestType.params.map({ (key, value) in
                URLQueryItem(name: key, value: value)
            })
            var request = URLRequest(url: (components?.url)!)
            
            if !Array(requestType.header.keys).isEmpty {
                let headerKey = Array(requestType.header.keys)[0]
                let headerVal = requestType.header[headerKey]
                request.setValue(headerKey, forHTTPHeaderField: headerVal ?? "")
            }
                
            // start url session
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
