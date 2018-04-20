//
//  ReviewsViewController.swift
//  PopularMovies
//
//  Created by Sayed Abdo on 4/5/18.
//  Copyright © 2018 Ahmed Osman. All rights reserved.
//

import UIKit

class ReviewsViewController: UIViewController {
    var review:Review?
    @IBOutlet weak var contentTxt: UITextView!
    @IBOutlet weak var autherLbl: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        autherLbl.text = review!.author
        contentTxt.text = review!.content
    }
}
