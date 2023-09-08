//
//  ActivityIndicator.swift
//  HarryPotterСharacters
//
//  Created by Oksenoyt on 08.09.2023.
//

import UIKit

final class ActivityIndicator {

    private var activityIndicator: UIActivityIndicatorView?

    func showSpinner(in view: UIView) -> UIActivityIndicatorView {
        let activityIndicator = UIActivityIndicatorView(style: .medium)
        activityIndicator.color = .white
        activityIndicator.startAnimating()
        activityIndicator.center = view.center
        activityIndicator.hidesWhenStopped = true
        view.addSubview(activityIndicator)
        return activityIndicator
    }
}
