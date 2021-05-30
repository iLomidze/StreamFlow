//
//  MovieData.swift
//  StreamFlow
//
//  Created by ilomidze on 09.05.21.
//

import Foundation


// MARK: - Upper JSON Key-Values

class MovieDataArr: Codable {
    var data: [MovieData]?
}

class MovieData: Codable {
    var id: Int?
    var primaryName: String?
    var secondaryName: String?
    var originalName: String?
    var isTvShow: Bool?
    var covers: CoversData?
    
    var imageData: Data?
    
    init() {
    }
    
    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try? values.decode(Int.self, forKey: .id)
        primaryName = try? values.decode(String.self, forKey: .primaryName)
        secondaryName = try? values.decode(String.self, forKey: .secondaryName)
        originalName = try? values.decode(String.self, forKey: .originalName)
        isTvShow = try? values.decode(Bool.self, forKey: .isTvShow)
        covers = try? values.decode(CoversData.self, forKey: .covers)
    }
    
    private enum CodingKeys: String, CodingKey {
        case id
        case primaryName
        case secondaryName
        case originalName
        case isTvShow
        case covers
    }
}


// MARK: - Covers Data Substructure

struct CoversData: Codable {
    var data: CoversDataSizes?
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        data = try? values.decode(CoversDataSizes.self, forKey: .data)
    }
    
    private enum CodingKeys: String, CodingKey {
        case data
    }
    
}

struct CoversDataSizes: Codable {
//    var xl: String?
    var l: String?
    var m: String?
    var s: String?
//    var xs: String?
    
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
//        xl = try? values.decode(String.self, forKey: .xl)
        l = try? values.decode(String.self, forKey: .l)
        m = try? values.decode(String.self, forKey: .m)
        s = try? values.decode(String.self, forKey: .s)
//        xs = try? values.decode(String.self, forKey: .xs)
    }
    
    private enum CodingKeys: String, CodingKey {
//        case xl = "1920"
        case l = "1050"
        case m = "510"
        case s = "367"
//        case xs = "145"
    }
}


// MARK: - Getters

extension CoversDataSizes {
    var maxSize: String? {
        // may add another sizes if needed
        return l ?? m ?? s
    }
    
    var minSize: String? {
        // may add another sizes if needed
        return s ?? m ?? l
    }
}


extension MovieData {
    var anyName: String? {
        if primaryName != "" {
            return primaryName
        } else if secondaryName != "" {
            return secondaryName
        } else {
            return originalName
        }
    }
}


