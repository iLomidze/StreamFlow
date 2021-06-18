//
//  SearchNetworkRequest.swift
//  StreamFlow
//
//  Created by Irakli Lomidze on 17.06.21.
//

import Foundation


enum SearchNetworkRequest: NetworkRequestType {
    case searchBasic(searchWord: String)
    
    var endPoint: String {
        return "https://api.imovies.cc/api/v1/search-advanced"
    }
    
    var params: [String: String] {
        switch self {
        case .searchBasic(let searchWord):
            return ["page": "1", "per_page": "20", "filters[type]": "movie", "keywords": searchWord]
        }
    }
    
    var header: [String : String] {
        return ["User-Agent": "imovies"]
    }
}
