//
//  RedditPost.swift
//  Reddit
//
//  Created by Cristian Morales on 10/6/17.
//  Copyright © 2017 Cristian Morales. All rights reserved.
//

import Foundation

class RedditPost: NSObject {
    var title : String?
    var author : String?
    var comments : Int?
    var created : TimeInterval?
    var thumbUrl : String?
    var imgUrl : String?
    
    enum JsonKey:String {
        case author
        case title
        case url
        case domain
        case thumbnail
        case numComments = "num_comments"
        case createdUTC = "created_utc"
    }
    
    override init() {
        super.init()
    }
    
    convenience init(json:[String:Any]) {
        self.init()
        
        let post = self
        
        post.author = json[JsonKey.author.rawValue] as? String
        post.title =  json[JsonKey.title.rawValue] as? String
        post.comments = json[JsonKey.numComments.rawValue] as? Int
        post.thumbUrl = json[JsonKey.thumbnail.rawValue] as? String
        
        let domain = json[JsonKey.domain.rawValue] as? String
        if let urlString = json[JsonKey.url.rawValue] as? String {
            if domain?.range(of: "i.imgur.com") != nil && urlString.hasSuffix(".jpg"){
                post.imgUrl = urlString
            }
        }
        if let dateNumber = json[JsonKey.createdUTC.rawValue] as? TimeInterval {
            post.created = dateNumber
        }
    }
}
