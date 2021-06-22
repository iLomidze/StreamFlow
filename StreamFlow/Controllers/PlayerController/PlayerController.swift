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
        let secondaryStoryboard = UIStoryboard(name: "Secondary", bundle: nil)
        guard let toRet = secondaryStoryboard.instantiateViewController(identifier: "PlayerController") as? Self else {
            return nil
        }
        toRet.movieData = data
        toRet.dataFetcher = dataFetcher
        return toRet
    }
    
    
    // MARK: - Outlets
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var movieCoverImage: UIImageView!
    @IBOutlet weak var movieTitleLabel: UILabel!
    @IBOutlet weak var plotLabel: UILabel!
    @IBOutlet weak var directorLabel: UILabel!
    @IBOutlet weak var genreLabel: UILabel!
    @IBOutlet weak var actorsCollection: UICollectionView!
    @IBOutlet weak var relatedMoviesCollection: UICollectionView!
    
    @IBOutlet weak var imdbRatingLabel: UILabel!
    @IBOutlet weak var yearLabel: UILabel!
    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    
    @IBOutlet weak var playBtn: UIButton!
    
    internal var seasonsCollectionView: UICollectionView!
    internal var episodesTableView: UITableView!
    
    internal var closeEpBtn: UIButton!
    
    
    // MARK: - DelegateProperties and related properties
    
    weak var seasonDelegate: SeasonChangeDelegate?
    var seasonPicked = 0 {
        didSet {
            changeSeasonData()
//            isVideoUrlFetchingFinished = false
        }
    }
    
    // MARK: - Properties
    
    private var videoID: Int?
    
    internal var dataFetcher: DataFetcherType?
    
    private var avPlayerViewController = AVPlayerViewController()
    private var avPlayerView = AVPlayer()
    
    internal var videoUrlDataArr: VideoUrlDataArr?
//    {
//        didSet {
//            if !isVideoUrlFetchingFinished {
//                return
//            }
//            isVideoUrlFetchingFinished = false
//        }
//    }
    
    internal var movieDescDataArr: MovieDescrData? {
        didSet {
            DispatchQueue.main.async { [weak self] in
                self?.initDetailsDesc()
            }
        }
    }
    private var personsData: PersonsData? {
        didSet {
            initDetailsPers()
        }
    }
    var relatedMoviesData: RelatedMoviesData?
    var movieData: MovieData?
    
    var trailerUrlString = ""
    
    var isPersonsFetchingFinished = false {
        didSet {
           updateActorsCollection()
        }
    }
    var castArr: [PersonData] = []
    
    var isRelatedDataFetchingFinished = false {
        didSet {
            initDetailsRelated()
        }
    }
    var isRelatedFetchingFinished = false {
        didSet {
            DispatchQueue.main.async { [weak self] in
                self?.relatedMoviesCollection.reloadData()
            }
        }
    }
    

    
    
    // MARK: - Executive
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        playBtn.layer.cornerRadius = 7

        if movieData?.id != nil{
            videoID = movieData?.id
        } else{
            assert(false, "No videoID")
            return
        }
        let videoIDStr = String(videoID!)
        
        setCoverImage()
        
        seasonDelegate = self
        
        scrollView.contentInset = UIEdgeInsets(top: movieCoverImage.frame.height, left: 0, bottom: 0, right: 0)
        
        actorsCollection.register(UINib(nibName: "ActorsCell", bundle: nil), forCellWithReuseIdentifier: "ActorsCell")
        relatedMoviesCollection.register(UINib(nibName: "MovieListCollectionCell", bundle: nil), forCellWithReuseIdentifier: "MovieListCollectionCell")
        
        fetchData(requestType: PlayerNetworkRequest.videoUrl(credentials: (id: videoIDStr, season: "\(seasonPicked)")), type: VideoUrlDataArr.self) { [weak self] videoArr in
            self?.videoUrlDataArr = videoArr
//            if self?.videoUrlDataArr.
//            self?.updateEpisodesPoster()
        }
        fetchData(requestType: PlayerNetworkRequest.movieDesc(id: videoIDStr), type: MovieDescrData.self) { [weak self] descData in
            self?.movieDescDataArr = descData
        }
        fetchData(requestType: PlayerNetworkRequest.persons(id: videoIDStr), type: PersonsData.self) { [weak self] persData  in
            self?.personsData = persData
        }
        fetchData(requestType: PlayerNetworkRequest.relatedMovies(id: videoIDStr), type: RelatedMoviesData.self) {[weak self] relData in
            self?.relatedMoviesData = relData
            self?.isRelatedDataFetchingFinished = true
        }
    }
    
    
    // MARK: - Functions
    
    // MARK: General Functions
    
    /// Sets image behind the scrollView - the main image users see when entered to the movie details
    private func setCoverImage() {
        if let imageData = movieData?.imageData {
            movieCoverImage.image = UIImage(data: imageData)
            return
        }
        
        guard let urlString = self.movieData?.covers?.data?.maxSize,
              let url = URL(string: urlString) else {
            movieCoverImage.image = UIImage(named: "noMovieCover")
            return
        }
              
        
        self.movieCoverImage.sd_setImage(with: url) { [weak self] image, err, _, _ in
            self?.movieCoverImage.image = image
            if err != nil {
                print(err.debugDescription)
            }
        }
    }
    
    /// updates scrollView's: Movie title';  DescriptionContainer;  Plot, Genre  & Trailer Url
    func initDetailsDesc() {
        movieTitleLabel.text = movieDescDataArr?.data.anyName
        
        imdbRatingLabel.text = String(describing: movieDescDataArr?.data.rating.imdb.score ?? 0)
        yearLabel.text = String(describing: movieDescDataArr?.data.year ?? 0)
        durationLabel.text = String(describing: movieDescDataArr?.data.duration ?? 0) + " min"
        locationLabel.text = movieDescDataArr?.data.countries.data.first?.anyName
        
        plotLabel.text = movieDescDataArr?.data.plot?.data.description
        
        genreLabel.text = ""
        for i in 0..<(movieDescDataArr?.data.genres?.data.count ?? 1) {
            DispatchQueue.main.async { [weak self] in
                if i == 0 {
                    self?.genreLabel.text = self?.movieDescDataArr?.data.genres?.data[i].anyGenre
                } else {
                    self?.genreLabel.text! += "\n" + (self?.movieDescDataArr!.data.genres!.data[i].anyGenre)!
                }
            }
        }
        
        trailerUrlString = movieDescDataArr?.data.trailers.anyTrailer ?? ""
    }
    
    ///
    func initDetailsPers()  {
        guard let personsData = personsData else { return }
        for i in 0..<personsData.data.count {
            
            let person = personsData.data[i]

            if person.personRole.data.role == "director" {
                DispatchQueue.main.async { [weak self] in
                    self?.directorLabel.text = person.originalName
                }
            }

            if person.personRole.data.role == "cast" {
                castArr.append(person)
            }
            
        }
        isPersonsFetchingFinished = true
    }

    
    // MARK: Fetching Functions
    
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
    
    ///
    func fetchImage(imageUrlStr: String, completion: @escaping (Data) -> Void) {
        dataFetcher?.getImage(urlString: imageUrlStr, completion: { result in
            switch result {
            case .failure(let error):
                print(error.localizedDescription)
            case .success(let data):
                completion(data)
            }
        })
    }
    
    ///
    func updateActorsCollection() {
        DispatchQueue.main.async { [weak self] in
            self?.actorsCollection.reloadData()
        }
        
        for i in 0..<(castArr.count) {

            let person = castArr[i]

            if person.poster == "" {
                print("No image for actor #\(i) - \(person.originalName)")
                continue
            }
            fetchImage(imageUrlStr: person.poster) { [weak self] data in
                self?.castArr[i].imageData = data
                DispatchQueue.main.async {
                    let indexPath = IndexPath(item: i, section: 0)
                    let visibleIndexPaths = self?.actorsCollection.indexPathsForVisibleItems
                    
                    guard let visibleCellIndexes = visibleIndexPaths else {
                        print("No visible cells")
                        return
                    }
                    if visibleCellIndexes.contains(indexPath) {
                        self?.actorsCollection.reloadItems(at: [indexPath])
                    }
                }
            }

        }
    }
    
    ///
    func initDetailsRelated() {
        DispatchQueue.main.async { [weak self] in
            self?.relatedMoviesCollection.reloadData()
            self?.downloadRelatedImages()
        }
    }
    
    ///
    func updateEpisodesPoster() {
        guard let videoUrldataArrData = videoUrlDataArr?.data else { return }
        for i in 0..<videoUrldataArrData.count {
            let ep = videoUrldataArrData[i]
            
            if ep.poster == "" {
                continue
            }
            fetchImage(imageUrlStr: ep.poster) { [weak self] imgData in
                self?.videoUrlDataArr?.data[i].imgData = imgData
                
                if self?.episodesTableView == nil {
                    return
                }
                DispatchQueue.main.async {
                    let indexPath = IndexPath(item: i, section: 0)
                    let visibleIndexPaths = self?.episodesTableView.indexPathsForVisibleRows
                    
                    guard let visibleCellIndexes = visibleIndexPaths else {
                        print("No visible cells in episodesTableView")
                        return
                    }
                    if visibleCellIndexes.contains(indexPath) {
                        self?.episodesTableView.reloadRows(at: [indexPath], with: .automatic)
                    }
                }
            }
        }
    }
    
    /// Downloads images for relatedMoviesData
    func downloadRelatedImages() {
        for i in 0..<(relatedMoviesData?.data.count ?? 1) {
            let movieID = "\(relatedMoviesData!.data[i].id)"
            fetchData(requestType: PlayerNetworkRequest.videoUrl(credentials: (id: movieID, season: "0")), type: VideoUrlDataArr.self) { [weak self] videoUrldata in
                if videoUrldata.data.first?.poster == "" || videoUrldata.data.first?.poster == nil {
                    return
                }
                self?.fetchImage(imageUrlStr: (videoUrldata.data.first?.poster)!, completion: { imgData in
                    self?.relatedMoviesData!.data[i].imageData = imgData
                    DispatchQueue.main.async {
                        let indexPath = IndexPath(item: i, section: 0)
                        let visibleIndexPaths = self?.relatedMoviesCollection.indexPathsForVisibleItems
                        
                        guard let visibleCellIndexes = visibleIndexPaths else {
                            print("No visible cells in relatedMoviesCollection")
                            return
                        }
                        if visibleCellIndexes.contains(indexPath) {
                            self?.relatedMoviesCollection.reloadItems(at: [indexPath])
                        }
                    }
                })
            }
        }
        isRelatedFetchingFinished = true
    }
    
    ///
    func changeSeasonData() {
        fetchData(requestType: PlayerNetworkRequest.videoUrl(credentials: (id: String(videoID!), season: String(seasonPicked))), type: VideoUrlDataArr.self) { [weak self] videoArr in
            self?.videoUrlDataArr = videoArr
            DispatchQueue.main.async {
                self?.episodesTableView.reloadData()
            }
            self?.updateEpisodesPoster()
        }
    }
    
    // MARK: VideoPlayer Functions
    
    ///
    func runPlayer(videoStringURL: String) {
        
        if videoStringURL == "" {
            let ac = UIAlertController(title: "ვიდეოს ლინკი ცარიელია", message: nil, preferredStyle: .alert)
            present(ac, animated: true, completion: nil)
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                ac.dismiss(animated: true, completion: nil)
            }
            return
        }
        
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
    
    
    // MARK: New View For TVSeries
    
    ///
    func openEpisodePickView() {
        
        let colViewLayout = UICollectionViewFlowLayout()
        colViewLayout.scrollDirection = .horizontal
        
        let collectionViewHight = CGFloat(50)
        
        seasonsCollectionView = UICollectionView(frame: CGRect(x: 0, y: view.safeAreaInsets.top, width: view.frame.width, height: collectionViewHight), collectionViewLayout: colViewLayout)
        episodesTableView = UITableView(frame: CGRect(x: 0, y: collectionViewHight + view.safeAreaInsets.top, width: view.frame.width, height: view.frame.height - collectionViewHight - view.safeAreaInsets.top))
        
        seasonsCollectionView.backgroundColor = UIColor(named: "backgroundColor")
        episodesTableView.backgroundColor =  UIColor(named: "backgroundColor")
        
        view.addSubview(seasonsCollectionView)
        view.addSubview(episodesTableView)

        seasonsCollectionView.delegate = self
        seasonsCollectionView.dataSource = self
        episodesTableView.delegate = self
        episodesTableView.dataSource = self
        
        seasonsCollectionView.register(UINib(nibName: "SeasonsCollectionCell", bundle: nil), forCellWithReuseIdentifier: "SeasonsCollectionCell")
        episodesTableView.register(UINib(nibName: "EpisodesCell", bundle: nil), forCellReuseIdentifier: "EpisodesCell")
            
        episodesTableView.separatorInset = UIEdgeInsets(top: 5, left: 0, bottom: 5, right: 0)
        
        closeEpBtn = UIButton(frame: CGRect(x: view.frame.width - 50, y: view.safeAreaInsets.top + 55, width: 30, height: 30))
        closeEpBtn.setBackgroundImage(UIImage(named: "closeIcon"), for: .normal)
        closeEpBtn.imageView?.sizeToFit()
        closeEpBtn.addTarget(self, action: #selector(closeEpisodePicker), for: .touchUpInside)
        view.addSubview(closeEpBtn)
    }
    
    ///
    func playVideo(episode: Int = 0) {
        guard let videoUrlFiles = videoUrlDataArr?.data[episode].files else {
            let ac = UIAlertController(title: "ლინკი დაზიანებულია", message: nil, preferredStyle: .alert)
            present(ac, animated: true, completion: nil)
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                ac.dismiss(animated: true, completion: nil)
            }
            return
        }
        
        let ac = UIAlertController(title: "აირჩიეთ ენა", message: nil, preferredStyle: .alert)
        
        for file in videoUrlFiles {
            ac.addAction(UIAlertAction(title: file.lang, style: .default, handler: { [weak self] _ in
                let movieUrlString = file.files.first?.src ?? ""
                self?.runPlayer(videoStringURL: movieUrlString)
            }))
        }
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        present(ac, animated: true)
    }
    
    
    // MARK: - Outlet Actions
    
    ///
    @objc func closeEpisodePicker() {
        seasonsCollectionView.removeFromSuperview()
        episodesTableView.removeFromSuperview()
        closeEpBtn.removeFromSuperview()
    }
    
    /// When trailer button is pushed
    @IBAction func trailerBtnAction(_ sender: Any) {
        if trailerUrlString == "" {
            let ac = UIAlertController(title: "No Trailer Available", message: nil, preferredStyle: .alert)
            present(ac, animated: true, completion: nil)
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                ac.dismiss(animated: true, completion: nil)
            }
            return
        }
        runPlayer(videoStringURL: trailerUrlString)
    }
    
    ///
    @IBAction func playBtnAction(_ sender: Any) {
        if !(movieData?.isTvShow ?? false) {
            playVideo()
        } else {
            seasonPicked = 1
//            updateEpisodesPoster()
            openEpisodePickView()
        }
    }
    //End Class
}
