//
//  FilteredCatalogNetworkRequest.swift
//  StreamFlow
//
//  Created by Irakli Lomidze on 17.06.21.
//

import Foundation

enum FilteredCatalogNetworkRequest: NetworkRequestType {
    case genre(genreId: Int, pageNum: Int)
    case studio(studioId: Int, pageNum: Int)
    
    var endPoint: String {
        return "https://api.imovies.cc/api/v1/movies"
    }
    
    var params: [String: String] {
        switch self {
        case .genre(let genreId, let pageNum):
            return ["page": "\(pageNum)", "per_page": "20", "filters[genre]": String(genreId), "filters[with_files]": "yes", "sort": "-year"]
        case .studio(let studioId, let pageNum):
            return ["page": "\(pageNum)", "per_page": "20", "filters[studio]": String(studioId), "filters[with_files]": "yes", "sort": "-year"]
        }
    }
    
    var header: [String : String] {
        return ["User-Agent": "imovies"]
    }
}
