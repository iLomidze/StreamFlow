//
//  PersonsData.swift
//  StreamFlow
//
//  Created by Irakli Lomidze on 28.05.21.
//

import Foundation


struct PersonsData: Codable {
    var data: [PersonData]
}

struct PersonData: Codable {
    var originalName: String
    var primaryName: String
    var poster: String
    var personRole: PersonalRoleData
}

struct PersonalRoleData: Codable {
    var data: PersonalRoleDataInfo
}

struct PersonalRoleDataInfo: Codable {
    var role: String
    var character: String
}
