//
//  ViewController.swift
//  MySocialPhoto
//
//  Created by Admin on 18.08.18.
//  Copyright © 2018 SlavaLeschenko. All rights reserved.
//

import UIKit
import FBSDKLoginKit

class LoginViewController: UIViewController {

    let constants = Constants()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if (FBSDKAccessToken.current() != nil) {
            self.moveToProfilePhotos()
        } else {
            self.setUpLoginButton()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.isNavigationBarHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        self.navigationController?.isNavigationBarHidden = false
    }
    
    private func setUpLoginButton() {
        let loginBtn = FBSDKLoginButton()
        loginBtn.delegate = self
        loginBtn.readPermissions = constants.permissions
        loginBtn.center = self.view.center
        self.view.addSubview(loginBtn)
    }
    
    func moveToProfilePhotos() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "photoCollection") as! ProfilePhotosViewController
        navigationController?.pushViewController(vc, animated: true)
    }
    
}


extension LoginViewController: FBSDKLoginButtonDelegate {
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
        if error != nil {
            print(error.localizedDescription)
        } else if result.isCancelled {
            print("User cancelled")
        } else {
            moveToProfilePhotos()
        }
    }
    
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
    }
}

