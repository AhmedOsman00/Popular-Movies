//
//  Movie.swift
//  PopularMovies
//
//  Created by Sayed Abdo on 4/6/18.
//  Copyright © 2018 Ahmed Osman. All rights reserved.
//

import Foundation
import RealmSwift

class Movie:Object{
    @objc dynamic var image = ""
    @objc dynamic var title = ""
    @objc dynamic var overview = ""
    @objc dynamic var year = ""
    @objc dynamic var rating : Double = 0.0
    @objc dynamic var id = ""
    @objc dynamic var length = ""
    let reviews = List<Review>()
    let trailers = List<String>()
    @objc dynamic var fav = false
    override static func primaryKey() -> String? {
        return "id"
    }
}
