//
//  MovieDescrData.swift
//  StreamFlow
//
//  Created by Irakli Lomidze on 28.05.21.
//

import Foundation


struct MovieDescrData: Codable {
    var data: MovieDescrDataInfo
}


struct MovieDescrDataInfo: Codable {
    var id: Int
    var primaryName: String
    var secondaryName: String
    var originalName: String
    var year: Int
    var isTvShow: Bool
    var duration: Int
    var canBePlayed: Bool
    var rating: Rating
    var plot: Plot?
    var genres: Genres?
    var trailers: Trailers
    var countries: Countries
    var studios: Studios?
    var seasons: Seasons?
}


// MARK: - Rating

struct Rating: Codable {
    var imovies: ImoviesRating
    var imdb: ImdbRating
    var rotten: RottenRating
}

struct ImoviesRating: Codable {
    var score: Double
}

struct ImdbRating: Codable {
    var score: Double
}

struct RottenRating: Codable {
    var score: Double
}


// MARK: - Plot

struct Plot: Codable {
    var data: PlotData
}

struct PlotData: Codable {
    var description: String
}


// MARK: - Genres

struct Genres: Codable {
    var data: [Genre]
}

struct Genre: Codable {
    var primaryName: String
    var secondaryName: String
}


// MARK: - Trailers

struct Trailers: Codable {
    var data: [TrailerData]
}

struct TrailerData: Codable {
    var language: String
    var fileUrl: String
}


// MARK: - Countries

struct Countries: Codable {
    var data: [CountryData]
}

struct CountryData: Codable {
    var primaryName: String
    var secondaryName: String
}


// MARK: - Studios

struct Studios: Codable {
    var data: [StudioData]
}

struct StudioData: Codable {
    var name: String
}


// MARK: - Seasons

struct Seasons: Codable {
    var data: [SeasonsData]
}

struct SeasonsData: Codable {
    var name: String
    var episodesCount: Int
}
