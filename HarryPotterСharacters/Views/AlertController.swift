//
//  AlertController.swift
//  HarryPotterСharacters
//
//  Created by Oksenoyt on 24.10.2023.
//

import Foundation

import UIKit

struct AlertController {

    static func simpleAlert(retry: Int, error: String?, buttonAction: (() -> Void)? = nil) -> UIAlertController {
        var message = retry < 3
        ? String(localized: "Try downloading again...")
        : String(localized: "Please try again later")

        if let errorText = error {
            message += "\n\n\(errorText)"
        }

        let buttonTitle = retry < 3
        ? String(localized: "Try again")
        : String(localized: "OK")

        let alert = UIAlertController(
            title: String(localized: "Ops! Something went wrong"),
            message: message,
            preferredStyle: .alert
        )
        let okAction = UIAlertAction(title: buttonTitle, style: .default) { _ in
            buttonAction?()
        }
        alert.addAction(okAction)
        return alert
    }
}
