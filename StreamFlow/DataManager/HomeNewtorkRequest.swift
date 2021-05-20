//
//  HomeNewtorkRequest.swift
//  StreamFlow
//
//  Created by ilomidze on 18.05.21.
//

import Foundation



enum HomeNetworkRequest: NetworkRequestType {
    case movieOfTheDay
    case newAddedMovies
    case popularMovies
    case popularSeries
    case custom(url: String)
    
    #warning("query gaaswore - gadacema rom shegedzlos")
    var endPoint: String {
        switch self {
        case .movieOfTheDay:
            return "https://api.imovies.cc/api/v1/movies/movie-day?page=1&per_page=1"
        case .newAddedMovies:
            return "https://api.imovies.cc/api/v1/movies?filters%5Bwith_files%5D=yes&filters%5Btype%5D=movie&sort=-upload_date&per_page=55"
        case .popularMovies:
            return "https://api.imovies.cc/api/v1/movies/top?type=movie&period=day&page=1&per_page=20"
        case .popularSeries:
            return "https://api.imovies.cc/api/v1/movies/top?type=series&period=day&per_page=55"
        case .custom(let url):
            return url
        }
    }
}
