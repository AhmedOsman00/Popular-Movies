//
//  URL.swift
//  PopularMovies
//
//  Created by Sayed Abdo on 4/3/18.
//  Copyright © 2018 Ahmed Osman. All rights reserved.
//

import Foundation

class URLs{
    //"https://api.themoviedb.org/3/discover/movie?api_key=ea587be910a43964b70a12f219c43331&language=en-US&sort_by=popularity.desc&include_adult=false&include_video=false&page=1&primary_release_date.gte=2017-10-14&primary_release_date.lte=2018-4-14"
    
    //"https://api.themoviedb.org/3/discover/movie?api_key=ea587be910a43964b70a12f219c43331&language=en-US&sort_by=vote_average.desc&include_adult=false&include_video=false&page=1&primary_release_date.gte=2017-10-14&primary_release_date.lte=2018-4-14&vote_count.gte=200"
    static let POPULARITY = "https://api.themoviedb.org/3/discover/movie?api_key=ea587be910a43964b70a12f219c43331&language=en-US&sort_by=popularity.desc&include_adult=false&include_video=false&page=1&primary_release_year="
    static let PREFIX = "https://api.themoviedb.org/3/movie/"
    static let VIDEOS = "/videos?api_key=ea587be910a43964b70a12f219c43331&language=en-US"
    static let YOUTUBE_LINK = "https://www.youtube.com/watch?v="
    static let REVIEWS = "/reviews?api_key=ea587be910a43964b70a12f219c43331&language=en-US&page=1"
    static let TOP_RATED = "https://api.themoviedb.org/3/discover/movie?api_key=ea587be910a43964b70a12f219c43331&language=en-US&sort_by=vote_average.desc&include_adult=false&include_video=false&page=1&primary_release_year="
    static var VOTE_COUNT = "&vote_count.gte=200"
    static let API_KEY = "ea587be910a43964b70a12f219c43331"
    static let PIC_PREFIX = "http://image.tmdb.org/t/p/w185"
}
