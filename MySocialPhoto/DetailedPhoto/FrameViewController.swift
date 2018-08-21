//
//  DetailedPhotoViewController.swift
//  MySocialPhoto
//
//  Created by Admin on 18.08.18.
//  Copyright © 2018 SlavaLeschenko. All rights reserved.
//

import UIKit

class FrameViewController: UIViewController {
    
    let imageServices = ImageServices()

    var imageName: String? {
        didSet {
            guard
                let imageName = imageName,
                let imageUrl = URL(string: imageName)
            else {
                return
            }
            imageServices.getImage(withURL: imageUrl) { (image) in
                self.imageView.image = image
            }
        }
    }
    
    let imageView: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFit
        image.backgroundColor = UIColor.white
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setView()
    }
    
    func setView() {
        
        view.backgroundColor = UIColor.white
        
        view.addSubview(imageView)
        
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0" : imageView]))
        
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0" : imageView]))
    }
}
