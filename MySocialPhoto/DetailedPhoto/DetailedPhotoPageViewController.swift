//
//  ViewController.swift
//  MySocialPhoto
//
//  Created by Admin on 19.08.18.
//  Copyright © 2018 SlavaLeschenko. All rights reserved.
//

import UIKit

class DetailedPhotoPageViewController: UIPageViewController, UIPageViewControllerDataSource {

    var profilePhotos = [ProfilePhotosModel]()
    
    var selectedImage: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dataSource = self
        setControllers()
        self.view.backgroundColor = UIColor.white
        navigationController?.hidesBarsOnTap = true
        navigationController?.hidesBarsOnSwipe = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.hidesBarsOnTap = false
        navigationController?.hidesBarsOnSwipe = false
    }
    
    func setControllers() {
        let frameViewController = FrameViewController()
        frameViewController.imageName = selectedImage
        
        let viewControllers = [frameViewController]
        setViewControllers(viewControllers, direction: .forward, animated: true, completion: nil)
    }
    
//MARK: - UIPageViewControllerDataSource
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        let currentImageName = (viewController as! FrameViewController).imageName
        let currentIndex = profilePhotos.index(where: { $0.url == currentImageName})
        
        if currentIndex! < profilePhotos.count - 1 {
            let frameViewController = FrameViewController()
            frameViewController.imageName = profilePhotos[currentIndex! + 1].url
            return frameViewController
        }
        return nil
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        let currentImageName = (viewController as! FrameViewController).imageName
        let currentIndex = profilePhotos.index(where: { $0.url == currentImageName})
        
        if currentIndex! > 0 {
            let frameViewController = FrameViewController()
            frameViewController.imageName = profilePhotos[currentIndex! - 1].url
            return frameViewController
        }
        return nil
    }
}
