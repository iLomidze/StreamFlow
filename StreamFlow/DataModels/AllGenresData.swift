//
//  AllGenresData.swift
//  StreamFlow
//
//  Created by Irakli Lomidze on 12.06.21.
//

import Foundation


struct AllGenresData: Codable {
    var data: [GenresData]
}

struct GenresData: Codable {
    var id: Int
    var primaryName: String
    var secondaryName: String
    var tertiaryName: String
}

extension GenresData {
    var anyName: String {
        if primaryName != "" {
            return primaryName
        } else if secondaryName != "" {
            return secondaryName
        } else {
            return tertiaryName
        }
    }
}
