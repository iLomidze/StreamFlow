//
//  FirestoreManager.swift
//  StreamFlow
//
//  Created by Irakli Lomidze on 23.06.21.
//

import Foundation
import FirebaseFirestore


class FirestoreManager {
    
    let firestore = Firestore.firestore()
    
//    private let collection = "openedMovies"
//    private let document = "playbackTimes"
    
    private let collection = "playbackTimes"
    private static var document = ""
    
    
    private static var dataBase: [String: Double]?
    
    
    static func setUserID(id: String) {
        document = id
    }
    
    func isIdSet() -> Bool {
        if FirestoreManager.document == "" {
            return false
        } else {
            return true
        }
    }
    
    func saveDataFirestore(id: Int, seconds: Double) {
        let docRef = firestore.document("\(collection)/\(FirestoreManager.document)")
        docRef.setData(["\(id)" : seconds], merge: true)
    }
    
    func fetchAllDataFirestore(completion: @escaping(Result<Void,ErrorRequests>)->Void = {result in} ) {
        if FirestoreManager.document == "" {
            completion(.failure(.firestoreNoUserID))
            return
        }
        
        let docRef = firestore.document("\(collection)/\(FirestoreManager.document)")
        docRef.getDocument { snapshot, error in
            guard let data = snapshot?.data() as? [String: Double] else {
                completion(.failure(.fireStoreDataDownloadFailed))
                return
            }
            if error != nil {
                completion(.failure(.firesStoreError))
                return
            }
            FirestoreManager.dataBase = data
            completion(.success( () ))
        }
    }
    
    func getVideoPlaybackTime(id: Int) -> Double? {
        let idStr = String(id)
        if FirestoreManager.dataBase?.keys.contains(idStr) != nil {
            return FirestoreManager.dataBase![idStr]
        }
        return nil
    }
    
    func getData()->[String : Double]? {
        return FirestoreManager.dataBase
    }
    
    func updateDataFromUserDefaults() {
        FirestoreManager.dataBase = ContinueWatchingData.getData()
        let docRef = firestore.document("\(collection)/\(FirestoreManager.document)")
        
        guard let keys = FirestoreManager.dataBase?.keys else { return }
        for id in keys {
            docRef.setData(["\(id)" : FirestoreManager.dataBase![id]! ], merge: true)
        }
    }
    
    
    func removeDocument() {
        firestore.document("\(collection)/\(FirestoreManager.document)").delete()
    }
    
    
    // End Class
}
