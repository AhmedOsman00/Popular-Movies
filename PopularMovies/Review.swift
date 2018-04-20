//
//  Review.swift
//  PopularMovies
//
//  Created by Sayed Abdo on 4/6/18.
//  Copyright © 2018 Ahmed Osman. All rights reserved.
//

import Foundation
import RealmSwift

class Review:Object{
    @objc dynamic var author = ""
    @objc dynamic var content = ""      
}
