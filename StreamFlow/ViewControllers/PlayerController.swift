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

    @IBOutlet weak var thumbnailImageView: UIImageView!
    @IBOutlet weak var playButton: UIButton!

    
    let videoStringURL = "https://api.imovies.cc/api/v1/trailers/12778/files"
    var avPlayerViewController = AVPlayerViewController()
    var avPlayerView = AVPlayer()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.playButton.isHidden = true
        
        let videoURL = URL(string: videoStringURL)
        
        
        let headers: [String: String] = [
           "User-Agent": "imovies"
        ]
        let asset = AVURLAsset(url: videoURL!, options: ["AVURLAssetHTTPHeaderFieldsKey": headers])
        let playerItem = AVPlayerItem(asset: asset)
        let player = AVPlayer(playerItem: playerItem)
        let playerController = AVPlayerViewController()
        playerController.player = player
        present(playerController, animated: true, completion: nil)
        

//        let player = AVPlayer(url: videoURL!)
//        let playerController = AVPlayerViewController()
//        playerController.player = player
//        present(playerController, animated: true, completion: nil)

//        Thumbnail player
//        self.getTumbnailFromImage(url: videoURL!) { (thumbnail) in
//            self.thumbnailImageView.image = thumbnail
//            self.playButton.isHidden = false
//        }
    }
    
    
    @IBAction func playButtonAction(_ sender: Any) {
        // Thumbnail player
//        playVideo()
        
        
    }
    
    
    
    // Thumbnail player
//    func playVideo() {
//        let videoURL = URL(string: videoStringURL)
//        avPlayerView = AVPlayer(url: videoURL!)
//        avPlayerViewController.player = avPlayerView
//
//        self.present(avPlayerViewController, animated: true) {
//            self.avPlayerViewController.player?.play()
//        }
//    }
//
//
//    func getTumbnailFromImage(url: URL, completion: @escaping (_ image: UIImage) -> Void ) {
//        DispatchQueue.global().async {
//            let asset = AVAsset(url: url)
//            let avAssetImageGenerator = AVAssetImageGenerator(asset: asset)
//
//            avAssetImageGenerator.appliesPreferredTrackTransform = true
//            let thumbnailTime = CMTimeMake(value: 7, timescale: 1)
//
//            do {
//                let cgThumbImage = try avAssetImageGenerator.copyCGImage(at: thumbnailTime, actualTime: nil)
//                let thumbImage = UIImage(cgImage: cgThumbImage)
//
//                completion(thumbImage)
//            } catch {
//                print(error.localizedDescription)
//            }
//        }
//    }
    //ec
}
