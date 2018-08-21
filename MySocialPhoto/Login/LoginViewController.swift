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
    let alert = Alert()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        checkToken()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        navigationController?.isNavigationBarHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        navigationController?.isNavigationBarHidden = false
    }
    
    private func setUpLoginButton() {
        let loginBtn = FBSDKLoginButton()
        loginBtn.delegate = self
        loginBtn.readPermissions = constants.permissions
        loginBtn.center = self.view.center
        self.view.addSubview(loginBtn)
    }
    
    private func moveToProfilePhotos() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "photoCollection") as! ProfilePhotosViewController
        navigationController?.pushViewController(vc, animated: true)
    }
    
    private func checkToken() {
        if (FBSDKAccessToken.current() != nil) {
            moveToProfilePhotos()
        } else {
            setUpLoginButton()
        }
    }
    
}


extension LoginViewController: FBSDKLoginButtonDelegate {
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
        if error != nil {
            print(error.localizedDescription)
        } else if result.isCancelled {
            self.present(alert.showAlert(title: "Error", message: "In order to use MySocialPhoto, please sign in with Facebook"), animated: true, completion: nil)
            
            print("User cancelled")
        } else {
            moveToProfilePhotos()
        }
    }
    
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
    }
}

