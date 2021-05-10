//
//  MovieData.swift
//  StreamFlow
//
//  Created by ilomidze on 09.05.21.
//

import Foundation


struct MovieDataArr: Codable {
    var data: [MovieData]
}

struct MovieData: Codable {
    var id: Int?
    var primaryName: String?
    var secondaryName: String?
    var isTvShow: Bool?
    var cover: Cover?
}

struct Cover: Codable {
    var small: String?
    var large: String?
}
