//
//  ViewController.swift
//  Reddit
//
//  Created by Cristian Morales on 10/6/17.
//  Copyright © 2017 Cristian Morales. All rights reserved.
//

import UIKit

class PostsViewController: UITableViewController {
    
    var interfaceAdapter = PostViewInterfaceAdapter()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.tableView.dataSource = interfaceAdapter
        self.tableView.delegate = interfaceAdapter
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 140

        
        self.tableView.reloadData()
    }
    
    // MARK: - State preservation / restoration
    
    enum PropertyKey :String {
        case offset
    }
    
    override func encodeRestorableState(with coder: NSCoder) {
        self.interfaceAdapter.encode(with: coder)
        coder.encode(self.tableView.contentOffset, forKey: PropertyKey.offset.rawValue)

        super.encodeRestorableState(with: coder)
    }
    
    override func decodeRestorableState(with coder: NSCoder) {
        super.decodeRestorableState(with: coder)
        
        if let adapter = PostViewInterfaceAdapter.init(coder: coder) {
            self.interfaceAdapter = adapter
            self.tableView.dataSource = adapter
            self.tableView.delegate = adapter
        }
        
        self.tableView.reloadData()

        if let savedOffset = coder.decodeObject(forKey: PropertyKey.offset.rawValue) as? String {
            let offset = CGPointFromString(savedOffset)
            self.tableView.setContentOffset(offset, animated: false)
        }
    }
}


