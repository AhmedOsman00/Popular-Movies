//
//  DetailsDelegate.swift
//  PopularMovies
//
//  Created by Ahmed Osman on 4/13/18.
//  Copyright © 2018 Ahmed Osman. All rights reserved.
//

import Foundation

protocol DetailsDelegate {
    func updateMovie(reviews:Array<Review>,videos:Array<String>)
}
