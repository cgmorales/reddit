//
//  PostDetailViewController.swift
//  Reddit
//
//  Created by Cristian Morales on 11/6/17.
//  Copyright © 2017 Cristian Morales. All rights reserved.
//

import UIKit

class PostDetailViewController: UIViewController {
    var urlString : String?
    var titleString : String?
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.loadImage()
        
        self.title = titleString
        self.saveButton.isEnabled = true
        
    }
    
    fileprivate func loadImage(){
        if let urlString = self.urlString {
            UIImage.downloadedFrom(link: urlString, completionHandler: { [weak self] (image) in
                self?.imageView.image = image
            })
        }
    }
    
    @IBAction private func onSaveButton(_ sender: Any) {
        
        if let image = self.imageView.image {
            
            UIImageWriteToSavedPhotosAlbum(image, self, #selector(resultSaveImage(_:didFinishSavingWithError:contextInfo:)), nil)
            
            self.saveButton.isEnabled = false
        }
    }
    
    func resultSaveImage(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        if let error = error {
            // we got back an error!
            let ac = UIAlertController(title: "Save error", message: error.localizedDescription, preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
        } else {
            let ac = UIAlertController(title: "Saved!", message: "Image saved to Gallery", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
        }
    }
}

//MARK: state restoration/preservation

extension PostDetailViewController {
    enum PropertyKey : String {
        case urlString
        case titleString
    }
    
    override func encodeRestorableState(with coder: NSCoder) {
        coder.encode(self.urlString, forKey: PropertyKey.urlString.rawValue)
        coder.encode(self.titleString, forKey: PropertyKey.titleString.rawValue)
        super.encodeRestorableState(with: coder)
    }
    
    override func decodeRestorableState(with coder: NSCoder) {
        super.decodeRestorableState(with: coder)
        if let savedTitle = coder.decodeObject(forKey: PropertyKey.titleString.rawValue) as? String {
            self.titleString = savedTitle
            self.title = self.titleString
            
        }
        if let savedUrl = coder.decodeObject(forKey: PropertyKey.urlString.rawValue) as? String {
            self.urlString = savedUrl
            self.loadImage()
        }
        
    }
}
