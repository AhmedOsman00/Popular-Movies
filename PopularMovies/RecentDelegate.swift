//
//  RecentDelegate.swift
//  PopularMovies
//
//  Created by Ahmed Osman on 4/10/18.
//  Copyright © 2018 Ahmed Osman. All rights reserved.
//

import Foundation

protocol RecentDelegate {
    func loadMovies(moviesArray:Array<Movie>)
}
