//
//  ErrorRequests.swift
//  StreamFlow
//
//  Created by ilomidze on 19.05.21.
//

import Foundation


enum ErrorRequests: Error {
    case noURL
    case urlSessionFailed
    case dataModelFailedForJSONParsing
    case fireStoreDataDownloadFailed
    case firesStoreError
    case firestoreNoUserID
}
