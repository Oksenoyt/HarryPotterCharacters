//
//  AlertController.swift
//  HarryPotterСharacters
//
//  Created by Oksenoyt on 24.10.2023.
//

import Foundation

import UIKit

 struct AlertController {

     static func simpleAlert(title: String?, message: String?, buttonTitle: String, buttonAction: (() -> Void)? = nil) -> UIAlertController {
         let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
         let okAction = UIAlertAction(title: buttonTitle, style: .default) { _ in
             buttonAction?()
         }
         alert.addAction(okAction)
         return alert
     }
}
