//
//  TopTrailersData.swift
//  StreamFlow
//
//  Created by Irakli Lomidze on 14.06.21.
//

import Foundation

struct TopTrailersDataArr: Codable {
    var data: [TopTrailersData]
}

struct TopTrailersData: Codable {
    var primaryName: String
    var secondaryName: String
    var tertiaryName: String
    var originalName: String
    var covers: CoversData
    var trailers: Trailers
    var imgData: Data?
}

