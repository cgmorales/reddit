//
//  UIImage+URL.swift
//  Reddit
//
//  Created by Cristian Morales on 10/6/17.
//  Copyright © 2017 Cristian Morales. All rights reserved.
//

import UIKit

extension UIImage {
    static func downloadedFrom(link: String, completionHandler : @escaping (UIImage?) -> () ) {
        guard let url = URL(string: link) else { return }
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil
                else { return }
            DispatchQueue.main.async() {
                completionHandler( UIImage(data: data) )
            }
            
            }.resume()
    }
}

