//
//  MovieDetailsViewController.swift
//  PopularMovies
//
//  Created by Sayed Abdo on 4/5/18.
//  Copyright © 2018 Ahmed Osman. All rights reserved.
//

import UIKit
import Cosmos
import ExpandableCell
import YouTubePlayer
import RealmSwift

private let reuseIdentifier = "trailerCell"

class MovieDetailsViewController: UIViewController {
    private var movieDao = MovieDao.getMovieDao()
    @IBOutlet weak var scrollHeight: NSLayoutConstraint!
    @IBOutlet weak var reviewsTableHeight: NSLayoutConstraint!
    @IBOutlet weak var trailerTableHeight: NSLayoutConstraint!
    @IBOutlet weak var trailersTable: UITableView!
    @IBOutlet weak var movieImageView: UIImageView!
    @IBOutlet weak var yearLbl: UILabel!
    @IBOutlet weak var lengthLbl: UILabel!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var dismissVideoView: UIStackView!
    var movie:Movie?
    @IBOutlet weak var popVideoViewConstrian: NSLayoutConstraint!
    @IBOutlet weak var stars: CosmosView!
    @IBOutlet weak var reviewsExp: ExpandableTableView!
    @IBOutlet weak var favoriteBtn: UIButton!
    @IBOutlet weak var overviewTxt: UILabel!    
    @IBOutlet weak var popView: YouTubePlayerView!
    private var overviewHeight:CGFloat?
    @IBAction func dismiss(_ sender: Any) {
        // popVideoViewConstrian.constant = 400
        popView.stop()
        UIView.animate(withDuration: 0.3, animations: {
            //self.view.layoutIfNeeded()
            self.popupVideoStackCont.alpha = 0
            self.dismissVideoView.alpha = 0
        })
    }
    @IBAction func favorite(_ sender: Any) {
        switch movieDao.isFavorited(movieId: movie!.id) {
        case "fav":
            movieDao.unfavorite(movie: movie!)
            favoriteBtn.setTitle("Favorite", for: .normal)
        case "notfav":
            movieDao.favorite(movie: movie!)
            favoriteBtn.setTitle("Unfavorite", for: .normal)
        default:
            print("wait")
        }
    }
    @IBOutlet weak var popupVideoStackCont: UIStackView!
    override func viewDidLoad() {
        super.viewDidLoad()
        //Do any additional setup after loading the view.
        let movieService:MoviesService = MoviesService()
        movieService.viewController = self
        if (movie?.trailers.isEmpty)! {
            movieService.getTrailersAndReviews(movieId: (movie?.id)!)
        }
        movieImageView.sd_setImage(with: URL(string: (movie?.image)!), completed: nil)
        lengthLbl.text = (movie?.length)! + " min"
        titleLbl.text = (movie?.title)!
        overviewTxt.text = (movie?.overview)!
        stars.rating = (movie?.rating)!
        yearLbl.text = (movie?.year)!
        reviewsExp.expandableDelegate = self
        reviewsExp.animation = .automatic
        reviewsExp.register(UINib(nibName: "ExpandedCell", bundle: nil), forCellReuseIdentifier: ExpandedCell.ID)
        reviewsExp.register(UINib(nibName: "ExpandableCell", bundle: nil), forCellReuseIdentifier: ExpandableCell2.ID)
        trailersTable.delegate = self
        trailersTable.dataSource = self
        popView.layer.masksToBounds = true
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)        
        switch movieDao.isFavorited(movieId: movie!.id) {
        case "fav":
            favoriteBtn.setTitle("Unfavorite", for: .normal)
        case "notfav":
            favoriteBtn.setTitle("Favorite", for: .normal)
        default:
            favoriteBtn.setTitle("Favorite", for: .normal)
        }
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        updateHeight(false)
    }
}
extension MovieDetailsViewController:DetailsDelegate{
    func updateMovie(reviews: Array<Review>, videos: Array<String>) {
        movie?.reviews.append(objectsIn: reviews)
        movie?.trailers.append(objectsIn: videos)
        updateHeight(true)
        reviewsExp.reloadData()
        trailersTable.reloadData()
        if !movieDao.isAvilable(movieId: (movie?.id)!){
            movieDao.insertMovie(movie: movie!)
        }
    }
    func updateHeight(_ wreviews:Bool){
        let t1 = CGFloat((movie?.trailers)!.count * 44)
        let t2 = CGFloat((movie?.reviews)!.count * 44)+66
        trailerTableHeight.constant = t1
        overviewHeight = overviewTxt.bounds.size.height
        print("label::\(overviewHeight!)")
        reviewsTableHeight.constant = t2
        if wreviews{
            scrollHeight.constant = CGFloat(480-44)+t1+overviewHeight!
        }else{
            scrollHeight.constant = CGFloat(480-44)+t1+t2+overviewHeight!
        }
    }
}
extension MovieDetailsViewController:UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //popVideoViewConstrian.constant = 0
        popView.playerVars =  ["playsinline": "1" as AnyObject,"autoplay":"1" as AnyObject]
        popView.delegate = self
        popView.loadVideoID((movie?.trailers[indexPath.row])!)
        UIView.animate(withDuration: 0.3, animations: {
            //self.view.layoutIfNeeded()
            self.popupVideoStackCont.alpha = 1
            self.dismissVideoView.alpha = 0.5
        })
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (movie?.trailers)!.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! TrailersTableViewCell
        
        // Configure the cell
        cell.trailerStaticImage.image = UIImage(named: "trailer.png")
        cell.trailerNum.text = "Trailer \(indexPath.row+1)"
        return cell
    }
    
}
extension MovieDetailsViewController: ExpandableDelegate {
    func expandableTableView(_ expandableTableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    func expandableTableView(_ expandableTableView: ExpandableTableView, expandedCellsForRowAt indexPath: IndexPath) -> [UITableViewCell]? {
        var cells:[UITableViewCell] = [UITableViewCell]()
        for cellInfo in (movie?.reviews)! {
            print("in expanded")
            let cell = reviewsExp.dequeueReusableCell(withIdentifier: ExpandedCell.ID) as! ExpandedCell
            cell.titleLabel.text = cellInfo.author
            cells.append(cell)
        }
        print(cells.count)
        return cells
    }
    
    func expandableTableView(_ expandableTableView: ExpandableTableView, heightsForExpandedRowAt indexPath: IndexPath) -> [CGFloat]? {
        var cellsHeight:[CGFloat] = [CGFloat]()
        for _ in (movie?.reviews)! {
            cellsHeight.append(44)
        }
        return cellsHeight
    }
    
    
    func expandableTableView(_ expandableTableView: ExpandableTableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func expandableTableView(_ expandableTableView: ExpandableTableView, didSelectRowAt indexPath: IndexPath) {
       updateHeight(false)
    }
    
    func expandableTableView(_ expandableTableView: ExpandableTableView, didSelectExpandedRowAt indexPath: IndexPath) {
        let reviewViewController:ReviewsViewController = self.storyboard?.instantiateViewController(withIdentifier: "reviewController") as! ReviewsViewController
        reviewViewController.review = movie!.reviews[indexPath.row-1]
        self.navigationController?.pushViewController(reviewViewController, animated: true)
    }
    
    func expandableTableView(_ expandableTableView: ExpandableTableView, expandedCell: UITableViewCell, didSelectExpandedRowAt indexPath: IndexPath) {
        if let cell = expandedCell as? ExpandedCell {
            print("\(cell.titleLabel.text ?? "")")
        }
    }
    
    func expandableTableView(_ expandableTableView: ExpandableTableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = expandableTableView.dequeueReusableCell(withIdentifier: ExpandableCell2.ID) else { return UITableViewCell() }
        return cell
        
    }
    
    func expandableTableView(_ expandableTableView: ExpandableTableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 66
    }
}
extension MovieDetailsViewController:YouTubePlayerDelegate{
    func playerReady(videoPlayer: YouTubePlayerView){
        videoPlayer.play()
    }
}

