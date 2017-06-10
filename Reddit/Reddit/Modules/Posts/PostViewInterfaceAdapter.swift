//
//  PostViewInterfaceAdapter.swift
//  Reddit
//
//  Created by Cristian Morales on 10/6/17.
//  Copyright © 2017 Cristian Morales. All rights reserved.
//

import UIKit

class PostViewInterfaceAdapter: NSObject {
    let dataManager = PostViewDataManager()

}

extension PostViewInterfaceAdapter : UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "PostTableViewCell", for: indexPath) as? PostTableViewCell else { return UITableViewCell()}
        
        return cell
    }
}

extension PostViewInterfaceAdapter : UITableViewDelegate {

}

