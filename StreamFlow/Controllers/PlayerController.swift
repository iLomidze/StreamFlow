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

    var videoID: Int?
    var videoStringURL: String?
    
    var avPlayerViewController = AVPlayerViewController()
    var avPlayerView = AVPlayer()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setMovieURL()
    }
    
    
    //-
    func setMovieID(videoID: Int) {
        self.videoID = videoID
    }
    
    //-
    func setMovieURL() {
        guard let videoID = videoID else { return }
            
        let jsonURLStart = "https://api.imovies.cc/api/v1/movies/"
        let jsonURLFinish = "/files/1478845?rd=0"
        
        let jsonURL = jsonURLStart + String(videoID) + jsonURLFinish
        
        DataRequestManager.instance.getData(urlString: jsonURL) { [weak self] (videoData: VideoUrlData?) in
            self?.videoStringURL = videoData?.url
            self?.playVideo()
        }
    }
    
    //-
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
