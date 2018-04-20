//
//  FavMoviesCollectionController.swift
//  PopularMovies
//
//  Created by Sayed Abdo on 4/2/18.
//  Copyright © 2018 Ahmed Osman. All rights reserved.
//

import UIKit

private let reuseIdentifier = "favCell"
private let sectionInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: 0.0, right: 0.0)
private let numberOfItemsPerRow : CGFloat = 2

class FavMoviesCollectionController: UICollectionViewController {
    private var movieDao = MovieDao.getMovieDao()
    var favoritedMovies:Array<Movie> = Array<Movie>()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Register cell classes
        //self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        
        // Do any additional setup after loading the view.
        favoritedMovies.removeAll()
        favoritedMovies.append(contentsOf: movieDao.getAllFavMovies())
        self.collectionView?.reloadData()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        favoritedMovies.removeAll()
        favoritedMovies.append(contentsOf: movieDao.getAllFavMovies())
        self.collectionView?.reloadData()
    }
}

extension FavMoviesCollectionController{
    // MARK: UICollectionViewDataSource
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return favoritedMovies.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! FavMovieCollectionCell
        
        // Configure the cell
        cell.backgroundColor = UIColor.black
        cell.favImageView.sd_setImage(with: URL(string:favoritedMovies[indexPath.row].image), placeholderImage: nil)
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let movieDetailsViewController:MovieDetailsViewController = self.storyboard?.instantiateViewController(withIdentifier: "movieDetails") as! MovieDetailsViewController
        movieDetailsViewController.movie = favoritedMovies[indexPath.row]
        self.navigationController?.pushViewController(movieDetailsViewController, animated: true)
    }
}
extension FavMoviesCollectionController : UICollectionViewDelegateFlowLayout {
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
