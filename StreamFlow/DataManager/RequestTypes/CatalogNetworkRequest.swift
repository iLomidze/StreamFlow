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
    
    
    
    var endPoint: String {
        switch self {
        case .allGenre:
            return "https://api.imovies.cc/api/v1/genres"
        case .topStudios:
            return "https://api.imovies.cc/api/v1/studios"
        case .topTrailers:
            return "https://api.imovies.cc/api/v1/trailers/trailer-day"
        }
    }
    

    var params: [String : String] {
        switch self {
        case .allGenre:
            return ["page": "1", "per_page": "100"]
        case .topStudios:
            return ["page": "1", "per_page": "15", "sort": "-rating"]
        case .topTrailers:
            return ["page": "1", "&per_page": "5"]
        }
    }
    
    var header: [String : String] {
        return ["User-Agent": "imovies"]
    }
    
}
