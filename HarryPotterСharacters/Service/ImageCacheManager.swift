//
//  ImageCacheManager.swift
//  HarryPotterСharacters
//
//  Created by Oksenoyt on 08.09.2023.
//

import UIKit

final class ImageCacheManager {
    static let shared = NSCache<NSString, UIImage>()

    private init() {}
}
