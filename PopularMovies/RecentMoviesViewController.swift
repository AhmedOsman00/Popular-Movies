//
//  RecentMoviesCollectionController.swift
//  PopularMovies
//
//  Created by Sayed Abdo on 4/2/18.
//  Copyright © 2018 Ahmed Osman. All rights reserved.
//

import UIKit
import SDWebImage
import Dropdowns

private let reuseIdentifier = "recentCell"
private var movies:Array<Movie> = Array<Movie>()
private let sectionInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: 0.0, right: 0.0)
private let numberOfItemsPerRow : CGFloat = 2
let options = ["POPULARITY", "TOP RATED"]

class RecentMoviesCollectionController: UICollectionViewController {
    let movieDao = MovieDao.getMovieDao()
    let movieService:MoviesService = MoviesService()
    var titleView:TitleView?
    override func viewDidLoad() {
        super.viewDidLoad()
        titleView = TitleView(navigationController: navigationController!, title: "POPULARITY", items: options)
        movieService.viewController = self
        navigationItem.titleView = titleView
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Register cell classes
        // self.collectionView!.register(UICollectionViewCell.self,forCellWithReuseIdentifier: reuseIdentifier)
        
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if movieService.isConnectedToInternet(){
            if movies.isEmpty{
                movieService.getMovies(sortType: .POPULARITY)
            }
            titleView?.action = { index in
                switch index {
                case 0:
                    movies.removeAll()
                    self.movieService.getMovies(sortType: .POPULARITY)
                case 1:
                    movies.removeAll()
                    self.movieService.getMovies(sortType: .TOPRATED)
                default:
                    movies.removeAll()
                    self.movieService.getMovies(sortType: .POPULARITY)
                }
            }
        }else{
            movies.removeAll()
            movies.append(contentsOf: movieDao.getAllMovies())
            self.collectionView?.reloadData()
        }
    }
}

extension RecentMoviesCollectionController{
    // MARK: UICollectionViewDataSource
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return movies.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! RecentMovieCollectionCell
        
        // Configure the cell
        cell.recentCellImageView.sd_setImage(with: URL(string:movies[indexPath.row].image), placeholderImage: nil)
        cell.backgroundColor = UIColor.black   
        return cell
    }
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let movieDetailsViewController:MovieDetailsViewController = self.storyboard?.instantiateViewController(withIdentifier: "movieDetails") as! MovieDetailsViewController
        movieDetailsViewController.movie = movies[indexPath.row]
        self.navigationController?.pushViewController(movieDetailsViewController, animated: true)
    }
    
}

extension RecentMoviesCollectionController:RecentDelegate{
    func loadMovies(moviesArray:Array<Movie>){
        movies.append(contentsOf: moviesArray)
        DispatchQueue.main.async {
            self.collectionView?.reloadData()
        }
    }
    
}
extension RecentMoviesCollectionController : UICollectionViewDelegateFlowLayout {
    //1
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        //2
        let paddingSpace = sectionInsets.left * (numberOfItemsPerRow)
        let availableWidth = view.frame.width - paddingSpace
        let widthPerItem = availableWidth / numberOfItemsPerRow
        
        return CGSize(width: widthPerItem, height: widthPerItem)
    }
    
    //3
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInsets
    }
    
    // 4
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return sectionInsets.left
    }
}
