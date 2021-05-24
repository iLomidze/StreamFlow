//
//  PlayerController.swift
//  StreamFlow
//
//  Created by ilomidze on 08.05.21.
//

import UIKit
import AVKit
import AVFoundation

class PlayerController: UIViewController {

    // MARK: - Properties
    
    private var videoID: Int?
    private var videoStringURL: String?
    
    private var avPlayerViewController = AVPlayerViewController()
    private var avPlayerView = AVPlayer()
    
    
    // MARK: - Executive
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchData()
    }
    
    
    // MARK: - Functions
    
    
    /// Can be used from outside to get Video (Movie) ID
    func prepVC(videoID: Int) {
        self.videoID = videoID
    }
    
    ///
    func fetchData() {
        guard let videoID = videoID else { return }
            
        let jsonURLStart = "https://api.imovies.cc/api/v1/movies/"
        let jsonURLFinish = "/season-files/0"
        // TODO: last digit must change if it is TV Series - digit represents season
        
        let jsonURL = jsonURLStart + String(videoID) + jsonURLFinish
    
        //TODO: implement fetching data
        print(jsonURL)
//        DataRequestManager.instance.getData(requestType: HomeNetworkRequest.custom(url: jsonURL)) { [weak self] (videoData: Result<VideoUrlData, ErrorRequests>) in
//
//        }
    }
    
    ///
    func playVideo() {
        guard let videoStringURL = videoStringURL else { return }
        
        let videoURL = URL(string: videoStringURL)
        
        let headers: [String: String] = [
           "User-Agent": "imovies"
        ]
        
        DispatchQueue.main.async {
            let asset = AVURLAsset(url: videoURL!, options: ["AVURLAssetHTTPHeaderFieldsKey": headers])
            let playerItem = AVPlayerItem(asset: asset)
            let player = AVPlayer(playerItem: playerItem)
            let playerController = AVPlayerViewController()
            playerController.player = player
            self.present(playerController, animated: true, completion: nil)
        }
    }
    
    //ec
}
