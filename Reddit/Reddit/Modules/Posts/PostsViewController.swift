//
//  ViewController.swift
//  Reddit
//
//  Created by Cristian Morales on 10/6/17.
//  Copyright © 2017 Cristian Morales. All rights reserved.
//

import UIKit

class PostsViewController: UITableViewController {
    
    let interfaceAdapter = PostViewInterfaceAdapter()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.tableView.dataSource = interfaceAdapter
        self.tableView.delegate = interfaceAdapter
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 140

        
        self.tableView.reloadData()
    }
}


