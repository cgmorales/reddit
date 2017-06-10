//
//  String+pathComponent.swift
//  Reddit
//
//  Created by Cristian Morales on 5/6/17.
//  Copyright © 2017 Cristian Morales. All rights reserved.
//

import Foundation

extension String {
    func stringByAppendingPathComponent(path: String) -> String {
        let nsSt = self as NSString
        return nsSt.appendingPathComponent(path)
    }
}
