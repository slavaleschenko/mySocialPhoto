//
//  Alert.swift
//  MySocialPhoto
//
//  Created by Admin on 21.08.18.
//  Copyright © 2018 SlavaLeschenko. All rights reserved.
//

import Foundation
import UIKit

class Alert {
    func showAlert(title: String, message: String) -> UIAlertController {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Got it!", style: UIAlertActionStyle.default, handler: nil))
        return alert
    }
}
