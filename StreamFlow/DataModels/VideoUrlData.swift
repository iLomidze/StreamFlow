//
//  videoURL.swift
//  StreamFlow
//
//  Created by ilomidze on 12.05.21.
//

import Foundation


struct VideoUrlDataArr: Codable {
    var data: [VideoUrlData]
}

struct VideoUrlData: Codable {
    var episode: Int
    var episodes_include: String
    var title: String
    var description: String
    var rating: Double
    var file_will_be_added_soon: Bool
    var files: [FileAllLang]
//    var covers: CoversData // See MovieData dataModel for CoversData structure definition
    var poster: String
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        episode = try values.decode(Int.self, forKey: .episode)
        episodes_include = try values.decode(String.self, forKey: .episodes_include)
        title = try values.decode(String.self, forKey: .title)
        description = try values.decode(String.self, forKey: .description)
        rating = try values.decode(Double.self, forKey: .rating)
        file_will_be_added_soon = try values.decode(Bool.self, forKey: .file_will_be_added_soon)
        files = try values.decode([FileAllLang].self, forKey: .files)
//        covers = try values.decode(CoversData.self, forKey: .covers)
        poster = try values.decode(String.self, forKey: .poster)
    }
    
    private enum CodingKeys: String, CodingKey {
        case episode
        case episodes_include
        case title
        case description
        case rating
        case file_will_be_added_soon
        case files
//        case covers
        case poster
    }
}

struct FileAllLang: Codable {
    var lang: String
    var files: [File]
}

struct File: Codable {
    var id: Int
    var quality: String
    var src: String
    var duration: Int
}

