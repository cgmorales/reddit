//
//  PostViewDataLoader.swift
//  Reddit
//
//  Created by Cristian Morales on 10/6/17.
//  Copyright © 2017 Cristian Morales. All rights reserved.
//

import Foundation


let topPath = "top.json"

class PostViewDataManager : NSObject, NSCoding {
    fileprivate var posts : [RedditPost] = []
    
    fileprivate var after : String?
    fileprivate var loading = false
    
    enum JsonKey:String {
        case data
        case children
        case after
        case limit
    }
    
    enum PropertyKey :String {
        case posts
        case after
    }
    
    override init() {
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        if let savedAfter = aDecoder.decodeObject(forKey: PropertyKey.after.rawValue) as? String {
            self.after = savedAfter
        }
        
        if let savedPosts = aDecoder.decodeObject(forKey: PropertyKey.posts.rawValue) as? [RedditPost] {
            self.posts = savedPosts
        }
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(self.posts, forKey: PropertyKey.posts.rawValue)
        aCoder.encode(self.after, forKey: PropertyKey.after.rawValue)
    }
}

extension PostViewDataManager: PostViewDataManagerProtocol {

    func numberOfPosts() -> Int {
        return self.posts.count
    }
    
    func postAtIndex(_ index:Int) -> RedditPost? {
        
        if index < self.posts.count {
            return self.posts[index]
        }
        
        return nil
    }
    
    func loadMore(_ completionHandler : @escaping ()->() ) -> Bool {
        
        if self.posts.count > AppDefinitions.MAX_POSTS {
            return false
        }
        
        if self.loading { return false }
        
        self.loading = true
        
        self.loadMorePosts { [weak self] (newPosts) in
            self?.posts.append(contentsOf: newPosts)
            self?.loading = false
            
            DispatchQueue.main.async {
                completionHandler()
            }
        }
        
        return true
    }
    
    private func loadMorePosts(_ completionHandler : @escaping ([RedditPost])->() ) {
        var params : [String : Any] = [:]
        if let mAfter = after {
            params[JsonKey.after.rawValue] = mAfter
        }
        
        params[JsonKey.limit.rawValue] = AppDefinitions.PAGE_LIMIT
        
        let serverUrlStr = AppDefinitions.API_URL
        let urlString = serverUrlStr.stringByAppendingPathComponent(path: topPath)
        
        HTTPClient.shared.GET(url: urlString, params: params, completion: { (json) in
            self.processJson(json, completionHandler: completionHandler)
        }) {
            
        }
    }
    
    private func processJson(_ json:[String:Any], completionHandler: @escaping ([RedditPost])->() ) {
        guard let dataDict = json[JsonKey.data.rawValue] as? [String:Any] else { return }
        
        guard let children = dataDict[JsonKey.children.rawValue] as? [[String:Any]] else { return }
        
        var posts : [RedditPost] = []
        
        if let after = dataDict[JsonKey.after.rawValue] as? String {
            self.after = after
        }
        
        for child in children {
            guard let childData = child[JsonKey.data.rawValue] as? [String:Any] else { continue }
            
            let post = RedditPost(json:childData)
            posts.append(post)
        }
        
        completionHandler(posts)
    }
}
