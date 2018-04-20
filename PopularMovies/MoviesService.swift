//
//  MoviesService.swift
//  PopularMovies
//
//  Created by Sayed Abdo on 4/6/18.
//  Copyright © 2018 Ahmed Osman. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire

class MoviesService: NSObject {
    
    var viewController:UIViewController?
    var trailers:Array<String>?
    
    func getTrailersAndReviews(movieId id : String){
        Alamofire.request(URLs.PREFIX+id+URLs.VIDEOS, method: .get).validate().responseJSON { response in
            switch response.result {
            case .success(let value):
                var json = JSON(value)
                //print("JSON: \(json)")
                let trailersJsonArray = json["results"].arrayValue
                self.trailers = Array<String>()
                for index in trailersJsonArray {
                    self.trailers?.append(index["key"].stringValue)
                }
                self.getReviews(movieId: id)
            case .failure(let error):
                print(error)
            }
        }
    }

    private func getReviews(movieId id : String){
        Alamofire.request(URLs.PREFIX+id+URLs.REVIEWS, method: .get).validate().responseJSON { response in
            switch response.result {
            case .success(let value):
                var json = JSON(value)
                //print("JSON: \(json)")
                let reviewsJsonArray = json["results"].arrayValue
                var reviews:Array<Review> = Array<Review>()
                for index in reviewsJsonArray {
                    let review = Review()
                    review.author = index["author"].stringValue
                    review.content = index["content"].stringValue
                    reviews.append(review)
                }
                let details:DetailsDelegate = self.viewController as! DetailsDelegate                
                details.updateMovie(reviews: reviews, videos: self.trailers!)
            case .failure(let error):
                print(error)
            }
        }
    }
    
    
    func getMovies(sortType sorted : SortType) {
        var url:String?
        let date = Date()
        let dateFormater = DateFormatter()
        dateFormater.dateFormat = "yyyy"
        let year = dateFormater.string(from: date)
        switch sorted {
        case .POPULARITY:
            url = URLs.POPULARITY+year
        case .TOPRATED:
            url = URLs.TOP_RATED+year+URLs.VOTE_COUNT
        }
        Alamofire.request(url!, method: .get).validate().responseJSON { response in
            switch response.result {
            case .success(let value):
                var json = JSON(value)
                //print("JSON: \(json)")
                let moviesJsonArray = json["results"].arrayValue
                var movies : Array<Movie> = Array<Movie>()
                for index in moviesJsonArray {
                    let movie = Movie()
                    movie.id = index["id"].stringValue
                    movie.image = URLs.PIC_PREFIX+index["poster_path"].stringValue
                    movie.length = "120"
                    movie.rating = Double(round(10*index["vote_average"].doubleValue)/10)/2
                    movie.overview = index["overview"].stringValue
                    movie.title = index["title"].stringValue
                    var year = index["release_date"].stringValue.split(separator: "-")
                    movie.year = String(year[0])                    
                    movies.append(movie)
                }
                let loadMovies:RecentDelegate = self.viewController as! RecentDelegate
                loadMovies.loadMovies(moviesArray: movies)
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func isConnectedToInternet () -> Bool {
        return NetworkReachabilityManager()!.isReachable
    }
    
}
