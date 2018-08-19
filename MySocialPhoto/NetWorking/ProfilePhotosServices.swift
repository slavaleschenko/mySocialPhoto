//
//  ProfilePhotosServices.swift
//  MySocialPhoto
//
//  Created by Admin on 18.08.18.
//  Copyright © 2018 SlavaLeschenko. All rights reserved.
//

import Foundation
import FBSDKCoreKit

class ProfilePhotoServices {

    typealias JSONDictionary = [String: Any]
    
    let defaultSession = URLSession(configuration: .default)
    var dataTask: URLSessionDataTask?
    
    var photoList = [ProfilePhotosModel]()
    
    func fetchPhotos(completion: @escaping ([ProfilePhotosModel]) -> ()) {
        guard (FBSDKAccessToken.current() != nil),
            let token = FBSDKAccessToken.current().tokenString,
            let url = URL(string: "https://graph.facebook.com/me/photos?type=uploaded&fields=source&access_token=\(token)") else { return }
        dataTask = defaultSession.dataTask(with: url) { [weak self] (data, response, error) in
            if let error = error {
                print("DataTask error: " + error.localizedDescription)
            } else if let data = data {
                self?.updatePhotoList(data)
                DispatchQueue.main.async {
                    completion(self?.photoList ?? [])
                }
            } else {
                print("ERROR: Problem with response, data, error")
            }
        }
        dataTask?.resume()
        
        return
    }
    
    fileprivate func updatePhotoList(_ data: Data) {
        var response: JSONDictionary?
        
        do {
            response = try JSONSerialization.jsonObject(with: data, options: []) as? JSONDictionary
        } catch let parseError as NSError {
            print("JSONSerialization error: \(parseError.localizedDescription)\n")
            return
        }
        
        guard let array = response?["data"] as? NSArray else {
            print("Dictionary does not contain data key\n")
            return
        }
        for photo in array {
            if let photo = photo as? JSONDictionary{
                guard let imageURL = photo["source"] as? String else {
                    print("Image URL is nil")
                    return
                }
                photoList.append(ProfilePhotosModel(url: imageURL))
            } else {
                print("Problem parsing params")
            }
        }
    }
}

