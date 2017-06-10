//
//  PostTableViewCell.swift
//  Reddit
//
//  Created by Cristian Morales on 10/6/17.
//  Copyright © 2017 Cristian Morales. All rights reserved.
//

import UIKit

class PostTableViewCell : UITableViewCell {
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var postedByTimeAgoLabel: UILabel!
    @IBOutlet private weak var commentsNumberLabel: UILabel!
    @IBOutlet private weak var thumbImageView: UIImageView!
    
    var post:RedditPost?
    
    func setupWithPost(_ post:RedditPost){
        self.post = post
        
        self.thumbImageView.image = UIImage(named: "PlaceHolder")
        self.titleLabel.text = post.title
        
        var timeAgo = ""
        if let created = post.created {
            let date = Date(timeIntervalSince1970: created)
            
            let formatter = DateFormatter()
            timeAgo = formatter.timeSince(from: (date as NSDate))
        }
        
        let postedBy = post.author ?? ""
        
        if (timeAgo != "") || (postedBy != "" ) {
            self.postedByTimeAgoLabel.text = String.init(format: "%@%@", timeAgo, postedBy=="" ? "" : String.init(format: " by %@", postedBy))
        }
        
        let nc = post.comments ?? 0
        self.commentsNumberLabel.text = String.init(format: "%@ comments", nc>0 ? String(nc) : "no" )
        
        if let thumbUrl = post.thumbUrl {
            UIImage.downloadedFrom(link: thumbUrl, completionHandler:{ image in
                
                if self.post == post {
                    self.thumbImageView.image = image
                }
            })
        }
        
        let hasImage = post.imgUrl != nil && post.imgUrl != ""
        self.accessoryType = hasImage ? .disclosureIndicator : .none
        self.isUserInteractionEnabled = hasImage
        self.selectionStyle = .none
    }
}
