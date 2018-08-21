//
//  ProfilePhotosViewController.swift
//  MySocialPhoto
//
//  Created by Admin on 18.08.18.
//  Copyright © 2018 SlavaLeschenko. All rights reserved.
//

import UIKit
import FBSDKLoginKit

class ProfilePhotosViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    @IBOutlet weak var myCollectionView: UICollectionView!
    
    let profilePhotoServices = ProfilePhotoServices()
    let imageServices = ImageServices()
    
    var profilePhotos = [ProfilePhotosModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigationBar()
        imageCellSpacing()
        profilePhotoServices.fetchPhotos() { profilePhotos, error in
            self.profilePhotos = profilePhotos!
            DispatchQueue.main.async {
                self.myCollectionView.reloadData()
            }
        }
    }
    
//MARK: - CollectionViewDataSource
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return profilePhotos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: ProfilePhotosCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "fbPhoto", for: indexPath) as! ProfilePhotosCollectionViewCell
        
        let urlString = self.profilePhotos[indexPath.row].url
        guard let imageUrl = URL(string: urlString) else { return cell }
    
        imageServices.getImage(withURL: imageUrl) { (image) in
            cell.myPhoto.image = image
        }
        return cell
    }
    
//MARK: - CollectionViewDelegate
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let profilePhotoDetails: DetailedPhotoPageViewController = self.storyboard?.instantiateViewController(withIdentifier: "page") as! DetailedPhotoPageViewController
        
        profilePhotoDetails.selectedImage = self.profilePhotos[indexPath.row].url
        profilePhotoDetails.profilePhotos = self.profilePhotos
        self.navigationController?.pushViewController(profilePhotoDetails, animated: true)
    }
    
//MARK: - Navigation
    
    func configureNavigationBar() {
        self.title = "My photos"
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "LogOut", style: .done, target: self, action: #selector (didTapLogOut))
    }
    
    @objc func didTapLogOut() {
        let manager = FBSDKLoginManager()
        manager.logOut()
        moveToLogin()
    }
    
    func moveToLogin() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "loginVC") as! LoginViewController
        navigationController?.pushViewController(vc, animated: true)
    }
    
//MARK: - UICollectionViewCell Layout
    
    func imageCellSpacing() {
        let itemSize = UIScreen.main.bounds.width/2 - 3
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsetsMake(20, 0, 10, 0)
        layout.itemSize = CGSize(width: itemSize, height: itemSize)
        layout.minimumInteritemSpacing = 3
        layout.minimumLineSpacing = 3
        
        myCollectionView.collectionViewLayout = layout
    }


}
