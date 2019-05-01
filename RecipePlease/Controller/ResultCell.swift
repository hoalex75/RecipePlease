//
//  ResultCell.swift
//  RecipePlease
//
//  Created by Alex on 01/05/2019.
//  Copyright © 2019 Alexandre Holet. All rights reserved.
//

import UIKit

class ResultCell: UITableViewCell {
    @IBOutlet weak var recipeNameLabel: UILabel!
    @IBOutlet weak var ingredientsLabel: UILabel!
    @IBOutlet weak var recipeImageView: UIImageView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var imageUrl: URL? {
        didSet {
            if let imageUrl = imageUrl {
                imageViewSetup(url: imageUrl)
            }
        }
    }
    
    private func imageViewSetup(url: URL) {
        let search = SearchServices(storage: Storage())
        search.getImage(imageURL: url) { [weak self] (success, data) in
            if success, let data = data {
                self?.setImage(data: data)
            } else {
                print("échec")
                self?.activityIndicator.isHidden = true
            }
        }
    }
    
    private func setImage(data: Data) {
        recipeImageView.image = UIImage(data: data)
        activityIndicator.isHidden = true
        recipeImageView.isHidden = false
    }
}
