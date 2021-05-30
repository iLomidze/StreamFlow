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

    
    @IBOutlet weak var movieCoverImage: UIImageView!
    
    @IBOutlet weak var imdbRatingLabel: UILabel!
    @IBOutlet weak var yearLabel: UILabel!
    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    
    
    // MARK: - Properties
    
    private var videoID: Int?
    
    private var videoStringURL: String? //es wesit wasashlelia
    
    private var avPlayerViewController = AVPlayerViewController()
    private var avPlayerView = AVPlayer()
    
    private var videoUrlDataArr: VideoUrlDataArr?
    private var movideDescDataArr: MovieDescrData?
    private var personsData: PersonsData?
    private var relatedMoviesData: RelatedMoviesData?

    
    
    // MARK: - Executive
    
    override func viewDidLoad() {
        super.viewDidLoad()

        guard let videoID = videoID else { return }
        let videoIDStr = String(videoID)
        
//        fetchData(requestType: PlayerNetworkRequest.videoUrl(credentials: (id: videoIDStr, episode: "0")), saveTo: videoUrlDataArr) // TODO: must change episode numb.
//        fetchData(requestType: PlayerNetworkRequest.movieDesc(id: videoIDStr), saveTo: movideDescDataArr)
        
//        fetchData(requestType: PlayerNetworkRequest.persons(id: videoIDStr), saveTo: personsData)
        
        fetchData(requestType: PlayerNetworkRequest.relatedMovies(id: videoIDStr), saveTo: relatedMoviesData)
        
        initVisuals() // TODO: After fetching data asyncronically
    }
    
    
    
    @IBAction func trailerBtnAction(_ sender: Any) {
    }
    
    
    // MARK: - Functions
    
    
    /// Can | Must be used from outside to get Video (Movie) ID
    func prepVC(videoID: Int) {
        self.videoID = videoID
    }
    
    ///
    func fetchData<DataType: Codable>(requestType: PlayerNetworkRequest, saveTo: DataType) {
        DataRequestManager.instance.getData(requestType: requestType) { [weak self] (videoData: Result<DataType, ErrorRequests>) in
            
            switch videoData {
            case .failure(let error):
                print("Error on Video Data JSON fetching. Error - \(error)")
            case .success(let data):
                switch requestType {
                case .videoUrl(_):
                    self?.videoUrlDataArr = (data as! VideoUrlDataArr)
                case .movieDesc(_):
                    self?.movideDescDataArr = (data as! MovieDescrData)
                case .persons(_):
                    self?.personsData = (data as! PersonsData)
                case .relatedMovies(_):
                    self?.relatedMoviesData = (data as! RelatedMoviesData)
                }
                
            }
        }
        
        
    }
    
    
    
    func initVisuals() {

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
