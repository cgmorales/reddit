//
//  PostViewRouter.swift
//  Reddit
//
//  Created by Cristian Morales on 11/6/17.
//  Copyright © 2017 Cristian Morales. All rights reserved.
//

import UIKit

class PostViewRouter: NSObject {
    func prepare(for segue: UIStoryboardSegue, sender: Any?, post:RedditPost) {
        guard let destViewController = segue.destination as? PostDetailViewController else { return }
        
        destViewController.urlString = post.imgUrl
        destViewController.titleString = post.title
    }
}
