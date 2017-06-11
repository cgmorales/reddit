//
//  PostViewInterfaceAdapter.swift
//  Reddit
//
//  Created by Cristian Morales on 10/6/17.
//  Copyright © 2017 Cristian Morales. All rights reserved.
//

import UIKit

class PostViewInterfaceAdapter: NSObject, NSCoding {
    fileprivate var dataManager = PostViewDataManager()
    
    fileprivate var tableView : UITableView?
    
    fileprivate func loadMore() {
        let loading = self.dataManager.loadMore {
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            self.tableView?.reloadData()
        }
        
        if loading {
            UIApplication.shared.isNetworkActivityIndicatorVisible = true
        }
    }
    
    override init() {
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        if let dataManager = PostViewDataManager(coder: aDecoder) {
            self.dataManager = dataManager
        }
    }
    
    func encode(with aCoder: NSCoder) {
        self.dataManager.encode(with: aCoder)
    }
}

extension PostViewInterfaceAdapter : UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.tableView = tableView
        
        let result = self.dataManager.numberOfPosts()
        
        if result == 0 {
            
            self.loadMore()
        }
        
        return result
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "PostTableViewCell", for: indexPath) as? PostTableViewCell else { return UITableViewCell()}
        
        if indexPath.row > self.dataManager.numberOfPosts() - 5 {
            self.loadMore()
        }
        
        if let post = self.dataManager.postAtIndex(indexPath.row) {
            cell.setupWithPost(post)
        }
        return cell
    }
}

extension PostViewInterfaceAdapter : UITableViewDelegate {

}

