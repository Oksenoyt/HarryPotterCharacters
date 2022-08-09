//
//  ViewController.swift
//  HarryPotterСharacters
//
//  Created by Elenka on 09.08.2022.
//

import UIKit

class ViewController: UIViewController {
    
    let link = "http://hp-api.herokuapp.com/api/characters"
    
}

extension ViewController {
    private func fetchCharacters() {
        guard let url = URL(string: link) else { return }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, let response = response else {
                print(error?.localizedDescription ?? "No error description")
                return
            }
            print(response)
            
            do {
                let characters = try JSONDecoder().decode([Character].self, from: data)
                print(characters)
            } catch let error {
                print(error)
            }
            
            
//            guard let image = UIImage(data: data) else { return }
//            DispatchQueue.main.async {
//                self?.imageView.image = image
//            }
        }.resume()
    }
}
