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
                let search = SearchServices()
                search.getImage(imageURL: imageUrl) { [weak self] (success, data) in
                    if success, let data = data {
                        self?.recipeImageView.image = UIImage(data: data)
                        self?.activityIndicator.isHidden = true
                        self?.recipeImageView.isHidden = false
                    } else {
                        print("echec")
                        self?.activityIndicator.isHidden = true
                    }
                }
            }
        }
    }
}
