//
//  CatalogNetworkRequest.swift
//  StreamFlow
//
//  Created by Irakli Lomidze on 12.06.21.
//

import Foundation


enum CatalogNetworkRequest: NetworkRequestType {
    
    case topTrailers
    case allGenre
    case topStudios
    case singleStudio(studioId: String)
    
    
    
    var endPoint: String {
        switch self {
        case .allGenre:
            return "https://api.imovies.cc/api/v1/genres"
        case .topStudios:
            return "https://api.imovies.cc/api/v1/studios"
        case .topTrailers:
            return "https://api.imovies.cc/api/v1/trailers/trailer-day"
        case .singleStudio(_):
            return "https://api.imovies.cc/api/v1/movies"
        }
    }
    
//    https://api.imovies.cc/api/v1/movies?page=1&per_page=6&filters%5Bstudio%5D=192&filters%5Bwith_files%5D=yes&sort=-year
//    
    var params: [String : String] {
        switch self {
        case .allGenre:
            return ["page": "1", "per_page": "100"]
        case .topStudios:
            return ["page": "1", "per_page": "15", "sort": "-rating"]
        case .topTrailers:
            return ["page": "1", "&per_page": "5"]
        case .singleStudio(let studioId):
            return ["page": "1", "&per_page": "6", "filters%5Bstudio%5D": studioId, "filters%5Bwith_files%5D": "yes", "sort": "-year"]
        }
    }
    
    var header: [String : String] {
        return ["User-Agent": "imovies"]
    }
    
}
