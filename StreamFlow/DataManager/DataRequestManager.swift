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
    
    
    
    // Generic funcion for getting data
    func getData<DataType: Codable>(request: NetworkRequestType, completiton: @escaping (DataType) -> Void) {
        DispatchQueue.global().async {
            let url = URL(string: request.endPoint)
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
    func getImage(urlString: String, completiton: @escaping (Result<Data, ErrorRequests>) -> Void) {
        if urlString == "" {
            completiton(.failure(.noURL))
            return
        }
        
        DispatchQueue.global().async {
            let url = URL(string: urlString)
            let request = URLRequest(url: url!)
            
            let task = URLSession.shared.dataTask(with: request) { data, responce, error in
                guard let data = data, error == nil else {
                    print("Something went wrong during image data download")
                    return
                }
                completiton(.success(data))
            }
            
            task.resume()
        }
    }
    
    //ec
}
