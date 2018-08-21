//
//  ProfilePhotosServices.swift
//  MySocialPhoto
//
//  Created by Admin on 18.08.18.
//  Copyright © 2018 SlavaLeschenko. All rights reserved.
//

import Foundation
import FBSDKCoreKit

enum ProfilePhotoServiceError: Error {
    case noToken
    case networkError
    case noData
    case parseError
    case responseError
}

class ProfilePhotoServices {
    
    let constants = Constants()

    typealias JSONDictionary = [String: Any]
    typealias ProfilePhotoCompletion = (_ profilePhoto: [ProfilePhotosModel]?, _ error: ProfilePhotoServiceError?) -> ()
    
    let defaultSession = URLSession(configuration: .default)
    var dataTask: URLSessionDataTask?
    
    func fetchPhotos(completion: @escaping ProfilePhotoCompletion) {
        guard
            FBSDKAccessToken.current() != nil,
            let token = FBSDKAccessToken.current().tokenString,
            let url = URL(string: "\(constants.baseURL)" + "\(constants.edge)" + "?" + "type=\(constants.edgeType)" + "&" + "fields=\(constants.fields)" + "&" + "access_token=\(token)")
        else {
            completion(nil, .noToken)
            return
        }
        
        dataTask = defaultSession.dataTask(with: url) { [weak self] (data, response, error) in
            if error != nil {
                completion(nil, .networkError)
            } else if let data = data {
                self?.updatePhotoList(data, completion: completion)
            } else {
                completion(nil, .noData)
            }
        }
        dataTask?.resume()
    }
    
    fileprivate func updatePhotoList(_ data: Data, completion: ProfilePhotoCompletion) {
        var response: JSONDictionary?
        
        do {
            response = try JSONSerialization.jsonObject(with: data, options: []) as? JSONDictionary
        } catch let parseError as NSError {
            print("JSONSerialization error: \(parseError.localizedDescription)\n")
            return
        }
        
        guard let array = response?["data"] as? NSArray else {
            completion(nil, .parseError)
            return
        }
        
        var photos: [ProfilePhotosModel] = []
        
        for photo in array {
            if let photo = photo as? JSONDictionary{
                guard let imageURL = photo["source"] as? String else {
                    completion(nil, .parseError)
                    return
                }
                photos.append(ProfilePhotosModel(url: imageURL))
            } else {
                completion(nil, .parseError)
            }
        }
        completion(photos, nil)
    }
}

