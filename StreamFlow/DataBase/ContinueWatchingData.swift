//
//  ContinueWatchingData.swift
//  StreamFlow
//
//  Created by Irakli Lomidze on 23.06.21.
//
//  Class for saving Movie ID and time when it was stoped by user


import Foundation


class ContinueWatchingData {

    static private var contWatchMovies: [String : Double] = [:]
    
    static func insertData(id: Int, seconds: Double) {
        let idStr = String(id)
        contWatchMovies[idStr] = seconds
        setUserDefaultsData()
    }
    
    static func updateData(data: [String : Double]) {
        contWatchMovies = data
        setUserDefaultsData()
    }
    
    static func getVideoPlaybackTime(id: Int) -> Double? {
        let idStr = String(id)
        if contWatchMovies.keys.contains(idStr) {
            return contWatchMovies[idStr]
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
