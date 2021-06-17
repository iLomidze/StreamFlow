//
//  TopStudiosData.swift
//  StreamFlow
//
//  Created by Irakli Lomidze on 12.06.21.
//

import Foundation


struct TopStudiosDataArr: Codable {
    var data: [TopStudiosData]
}

struct TopStudiosData: Codable {
    var id: Int
    var name: String
    var poster: String
    var imgData: Data?
}
