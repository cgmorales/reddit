//
//  PostViewProtocols.swift
//  Reddit
//
//  Created by Cristian Morales on 10/6/17.
//  Copyright © 2017 Cristian Morales. All rights reserved.
//

import Foundation

protocol PostViewDataManagerProtocol {
    
    func numberOfPosts() -> Int
    
    func postAtIndex(_ index:Int) -> RedditPost?
    
    func loadMore(_ completionHandler : @escaping ()->() ) -> Bool
    
}
