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
    
    static func prepare(withData data: MovieData, onStoryboard storyBoard: UIStoryboard, dataFetcher: DataFetcherType?) -> Self? {
        guard let toRet = storyBoard.instantiateViewController(identifier: "TestPlayerController") as? Self else {
            return nil
        }
        toRet.movieData = data
        toRet.dataFetcher = dataFetcher
        return toRet
    }
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var movieCoverImage: UIImageView!
    
    @IBOutlet weak var imdbRatingLabel: UILabel!
    @IBOutlet weak var yearLabel: UILabel!
    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    
    
    // MARK: - Properties
    
    private var videoID: Int?
    private var dataFetcher: DataFetcherType?
    
    private var videoStringURL: String? //es wesit wasashlelia
    
    private var avPlayerViewController = AVPlayerViewController()
    private var avPlayerView = AVPlayer()
    
    private var videoUrlDataArr: VideoUrlDataArr?
    private var movideDescDataArr: MovieDescrData?
    private var personsData: PersonsData?
    private var relatedMoviesData: RelatedMoviesData?
    
    var movieData: MovieData?

    
    
    // MARK: - Executive
    
    override func viewDidLoad() {
        super.viewDidLoad()

        guard let videoID = movieData?.id else { return }
        let videoIDStr = String(videoID)
        
        self.scrollView.contentInset = .init(top: self.movieCoverImage.frame.height, left: 0, bottom: 0, right: 0)
        
        fetchData(requestType: PlayerNetworkRequest.videoUrl(credentials: (id: videoIDStr, episode: "0")), type: VideoUrlDataArr.self) { [weak self] videoArr in
            self?.videoUrlDataArr = videoArr
        } // TODO: must change episode numb.
        
        fetchData(requestType: PlayerNetworkRequest.movieDesc(id: videoIDStr), type: MovieDescrData.self) { [weak self] desc in
            self?.movideDescDataArr = desc
        }
        
//        fetchData(requestType: PlayerNetworkRequest.persons(id: videoIDStr), saveTo: personsData)
        
//        fetchData(requestType: PlayerNetworkRequest.relatedMovies(id: videoIDStr), saveTo: relatedMoviesData)
        
        initVisuals() // TODO: After fetching data asyncronically
        setCoverImage()
    }
    
    private func setCoverImage() {
        guard let urlString = self.movieData?.covers?.data?.maxSize,
              let url = URL(string: urlString) else { return }
              
        self.movieCoverImage.sd_setImage(with: url) { [weak self] image, err, _, _ in
            self?.movieCoverImage.image = image
            if err != nil {
                print(err.debugDescription)
            }
        }
    }
    
    
    
    @IBAction func trailerBtnAction(_ sender: Any) {
    }
    
    
    // MARK: - Functions
    
    
    /// Can | Must be used from outside to get Video (Movie) ID
    func prepVC(videoID: Int) {
        self.videoID = videoID
    }
    
    ///
    func fetchData<DataType: Codable>(requestType: PlayerNetworkRequest, type: DataType.Type, completion: @escaping (DataType) -> Void) {
        dataFetcher?.getData(requestType: requestType) { (videoData: Result<DataType, ErrorRequests>) in
            
            switch videoData {
            case .failure(let error):
                print("Error on Video Data JSON fetching. Error - \(error)")
            case .success(let data):
                completion(data)
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
