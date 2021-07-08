//
//  ContinueWatchingData.swift
//  StreamFlow
//
//  Created by Irakli Lomidze on 23.06.21.
//
//  Class for saving Movie ID and time when it was stoped by user


import Foundation




class ContinueWatchingData {

    /// Suffix after id, which separates movie id with its other indo
    static let idSuffix = "SFIDSFXFSARD"
    
    static private var contWatchMovies: [String : Double] = [:]
    
    static func insertData(id: String, seconds: Double) {
        contWatchMovies[id] = seconds
        setUserDefaultsData()
        
        let nc = NotificationCenter.default
        nc.post(name: Notification.Name(NotificationCenterKeys.continueWatchingUpdated.rawValue), object: nil)
    }
    
    static func updateData(data: [String : Double]) {
        contWatchMovies = data
        setUserDefaultsData()
    }
    
    static func getVideoPlaybackTime(id: String) -> Double? {
        if contWatchMovies.keys.contains(id) {
            return contWatchMovies[id]
        }
        return nil
    }
    
    static func getUserDefaultsData() {
        let userDefaults = UserDefaults.standard
        if let defaultData = userDefaults.object(forKey: "continueWatchingData") as? Data {
            let decoder = JSONDecoder()
            if let defaultDecodedData = try? decoder.decode([String : Double].self, from: defaultData) {
                ContinueWatchingData.contWatchMovies = defaultDecodedData
            }
        }
    }
    
    static func setUserDefaultsData() {
        let encoder = JSONEncoder()
        if let encoded  = try? encoder.encode(contWatchMovies) {
            let userDefaults = UserDefaults.standard
            userDefaults.setValue(encoded, forKey: "continueWatchingData")
        }
    }
    
    static func getData() -> [String : Double] {
        return contWatchMovies
    }
    
    static func eraseData() {
        contWatchMovies = [:]
        let userDefaults = UserDefaults.standard
        userDefaults.removeObject(forKey: "continueWatchingData")
        
    }
    // END CLASS
}
