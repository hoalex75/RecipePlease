//
//  ResultCell.swift
//  RecipePlease
//
//  Created by Alex on 01/05/2019.
//  Copyright © 2019 Alexandre Holet. All rights reserved.
//

import UIKit
import RxSwift

class ResultCell: UITableViewCell {
    @IBOutlet weak var backIngredientsView: UIView!

    @IBOutlet weak var ratingView: RatingView!
    @IBOutlet weak var recipeNameLabel: UILabel!
    @IBOutlet weak var ingredientsLabel: UILabel!
    @IBOutlet weak var recipeImageView: UIImageView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    let disposeBag = DisposeBag()

    var search: SearchServices?

    override func awakeFromNib() {
        super.awakeFromNib()
        bindView()
    }
    
    var imageUrl: String? {
        didSet {
            if let imageUrl = imageUrl {
                imageViewSetup(url: URL(string: imageUrl))
            }
        }
    }
    
    private func imageViewSetup(url: URL?) {
        guard let search = search, let url = url else {
            activityIndicator.isHidden = true
            return
        }
        search.getImage(imageURL: url) { [weak self] (success, data) in
            if success, let data = data {
                self?.setImage(data: data)
            } else {
                self?.activityIndicator.isHidden = true
            }
        }
    }
    
    private func setImage(data: Data) {
        recipeImageView.image = UIImage(data: data)
        recipeImageView.contentMode = .scaleAspectFill
        activityIndicator.isHidden = true
        recipeImageView.isHidden = false
    }
}


extension ResultCell: ViewBinder {
    func bindView() {
        bindBackgrounds(backgroundView: backIngredientsView)
        bindTextColors(labels: [ingredientsLabel, recipeNameLabel])
    }
}
