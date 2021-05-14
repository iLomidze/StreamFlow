//
//  MovieData.swift
//  StreamFlow
//
//  Created by ilomidze on 09.05.21.
//

import Foundation


struct MovieDataArr: Codable {
    var data: [MovieData]?
}

struct MovieData: Codable {
    var id: Int?
    var primaryName: String?
    var secondaryName: String?
    var isTvShow: Bool?
    var cover: Cover?
    var covers: CoversData?
}

struct Cover: Codable {
    var small: String?
    var large: String?
}

struct CoversData: Codable {
    var data: CoversDataSizes
}

struct CoversDataSizes: Codable {
    var xl: String?
    var l: String?
    var m: String?
    var s: String?
    var xs: String?
    enum ECodingKeys: String, CodingKey {
        case xl = "1920"
        case l = "1050"
        case m = "510"
        case s = "367"
        case xs = "145"
    }
}


