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
    
    init() {
        
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try? values.decode(Int.self, forKey: .id)
        primaryName = try? values.decode(String.self, forKey: .primaryName)
        secondaryName = try? values.decode(String.self, forKey: .secondaryName)
        isTvShow = try? values.decode(Bool.self, forKey: .isTvShow)
        cover = try? values.decode(Cover.self, forKey: .cover)
        covers = try? values.decode(CoversData.self, forKey: .covers)
    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case primaryName
        case secondaryName
        case isTvShow
        case cover
        case covers
    }
    
}

struct Cover: Codable {
    var small: String?
    var large: String?
}

struct CoversData: Codable {
    var data: CoversDataSizes?
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        data = try? values.decode(CoversDataSizes.self, forKey: .data)
    }
    
    enum CodingKeys: String, CodingKey {
        case data
    }
    
}

struct CoversDataSizes: Codable {
    var xl: String?
    var l: String?
    var m: String?
    var s: String?
    var xs: String?
    
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        xl = try? values.decode(String.self, forKey: .xl)
        l = try? values.decode(String.self, forKey: .l)
        m = try? values.decode(String.self, forKey: .m)
        s = try? values.decode(String.self, forKey: .s)
        xs = try? values.decode(String.self, forKey: .xs)
    }
    
    enum CodingKeys: String, CodingKey {
        case xl = "1920"
        case l = "1050"
        case m = "510"
        case s = "367"
        case xs = "145"
    }
}

extension CoversDataSizes {
    var maxSize: String? {
        return xl ?? l ?? m ?? s ?? xs
    }
    
    var minSize: String? {
        return xs ?? s ?? m ?? l ?? xl
    }
}


