//
//  VideoNetworkRequest.swift
//  StreamFlow
//
//  Created by Irakli Lomidze on 28.05.21.
//

import Foundation


enum PlayerNetworkRequest: NetworkRequestType {
    
    case videoUrl(credentials: (id: String, episode: String))
    case movieDesc(id: String)
    case persons(id: String)
    case relatedMovies(id: String)
      
    var endPoint: String {
        switch self {
        case .videoUrl(let credentials):
            let id = credentials.id as String
            let episode = credentials.episode as String
            return ("https://api.imovies.cc/api/v1/movies/" + id + "/season-files/" + episode)
        case .movieDesc(let id):
            return ("https://api.imovies.cc/api/v1/movies/" + id)
        case .persons(let id):
            return ("https://api.imovies.cc/api/v1/movies/" + id + "/persons")
        case .relatedMovies(let id):
            return ("https://api.imovies.cc/api/v1/movies/" + id + "/related")
        }
    }
    
    var params: [String : String] {
        switch self {
        case .videoUrl(_), .movieDesc(_), .persons(_):
            return [:]
        case .relatedMovies(_):
            return ["page": "1", "per_page": "10"]
        }
    }
    
    var header: [String : String] {
        switch self {
        case .videoUrl(_), .movieDesc(_), .persons(_), .relatedMovies(_):
            return ["User-Agent": "imovies"]
        }
    }
    
    
}
