//
//  RedditPost.swift
//  Reddit
//
//  Created by Cristian Morales on 10/6/17.
//  Copyright © 2017 Cristian Morales. All rights reserved.
//

import Foundation

class RedditPost: NSObject, NSCoding {
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

    //MARK: Encoding for state preservation/restoration
    enum PropertyKey : String {
        case title
        case author
        case comments
        case created
        case thumbUrl
        case imgUrl
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(self.title, forKey: PropertyKey.title.rawValue)
        aCoder.encode(self.author, forKey: PropertyKey.author.rawValue)
        aCoder.encode(self.comments, forKey: PropertyKey.comments.rawValue)
        aCoder.encode(self.created, forKey: PropertyKey.created.rawValue)
        aCoder.encode(self.thumbUrl, forKey: PropertyKey.thumbUrl.rawValue)
        aCoder.encode(self.imgUrl, forKey: PropertyKey.imgUrl.rawValue)
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.title = aDecoder.decodeObject(forKey: PropertyKey.title.rawValue) as? String
        self.author = aDecoder.decodeObject(forKey: PropertyKey.author.rawValue) as? String
        self.comments = aDecoder.decodeObject(forKey: PropertyKey.comments.rawValue) as? Int
        self.created = aDecoder.decodeObject(forKey: PropertyKey.created.rawValue) as? TimeInterval
        self.thumbUrl = aDecoder.decodeObject(forKey: PropertyKey.thumbUrl.rawValue) as? String
        self.imgUrl = aDecoder.decodeObject(forKey: PropertyKey.imgUrl.rawValue) as? String
    }
}
