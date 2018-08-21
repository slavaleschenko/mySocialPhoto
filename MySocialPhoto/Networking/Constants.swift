//
//  Constants.swift
//  MySocialPhoto
//
//  Created by Admin on 21.08.18.
//  Copyright © 2018 SlavaLeschenko. All rights reserved.
//

import Foundation
import FBSDKCoreKit

struct Constants {
    let baseURL = "https://graph.facebook.com/me/"
    let edge = "photos"
    let edgeType = "uploaded"
    let fields = "source"
    let permissions = ["public_profile", "email", "user_photos"]
}
