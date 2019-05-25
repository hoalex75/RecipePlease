//
//  RecipeViewController.swift
//  RecipePlease
//
//  Created by Alex on 25/05/2019.
//  Copyright © 2019 Alexandre Holet. All rights reserved.
//

import UIKit

class RecipeViewController: UIViewController {
    var search: SearchServices?
    
    var recipe: Recipe?
    
    @IBOutlet weak var image: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setImage()
        
        // Do any additional setup after loading the view.
    }

    private func setImage() {
        guard let search = search, let recipe = recipe else { return }
        search.getImage(imageURL: recipe.images[0].hostedLargeUrl!) { success, data in
            if success {
                self.image.image = UIImage(data: data!)!
            } else {
                self.image.image = UIImage(named: "Clock")
            }
        }
    }
}
