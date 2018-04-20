//
//  MovieDao.swift
//  PopularMovies
//
//  Created by Ahmed Osman on 4/13/18.
//  Copyright © 2018 Ahmed Osman. All rights reserved.
//

import UIKit
import RealmSwift

class MovieDao: NSObject {
    
    let realm = try! Realm()
    static var movieDao:MovieDao?
    
    static func getMovieDao() -> MovieDao{
        if movieDao == nil {
            movieDao = MovieDao()
        }
        return movieDao!
    }
    
    override init() {
        // Get our Realm file's parent directory
        let folderPath = realm.configuration.fileURL!.deletingLastPathComponent().path
        print(folderPath)
        // Disable file protection for this directory
        try! FileManager.default.setAttributes([FileAttributeKey(rawValue: "NSFileProtectionKey"): FileProtectionType.none],
                                               ofItemAtPath: folderPath)
    }
    
    func isAvilable(movieId:String) -> Bool{
        print("isAvilable")
        let result = realm.objects(Movie.self).filter("id == %@", movieId)
        if !result.isEmpty{
            return true
        }
        return false
    }
    
    func unfavorite(movie:Movie){
        print("unfavorite")
        try! realm.write {
            movie.fav = false
            realm.add(movie, update: true)
        }
    }
    
    func favorite(movie:Movie){
        print("favorite")
        try! realm.write {
            movie.fav = true
            realm.add(movie, update: true)
        }
    }
    
    func isFavorited(movieId:String) -> String{
        print("isFavorited")
        let result = realm.objects(Movie.self).filter("id == %@", movieId)
        if result.isEmpty {
            return "empty"
        }else{
            let favRes = result.filter("fav == true")
            if !favRes.isEmpty {
                return "fav"
            }else{
                return "notfav"
            }
        }
    }
    
    func getAllFavMovies() -> Array<Movie>{
        print("getAllFavMovies")
        let movies = realm.objects(Movie.self).filter("fav == true")
        return Array<Movie>(movies)
    }
    
    func getAllMovies() -> Array<Movie>{
        print("getAllMovies")
        let movies = realm.objects(Movie.self)
        return Array<Movie>(movies)
    }
    
    func insertMovie(movie:Movie){
        try! realm.write {
            realm.add(movie)
        }
        print("insertMovie")
    }
}
