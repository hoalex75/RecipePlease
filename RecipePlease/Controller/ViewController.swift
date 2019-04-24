//
//  ViewController.swift
//  RecipePlease
//
//  Created by Alex on 21/04/2019.
//  Copyright © 2019 Alexandre Holet. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var imageView: UIImageView!
    private var search = SearchServices()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    @IBAction func getImage() {
        let ingredients = ["cognac","GarlIc"]
        search.getResultsWithIngredients(ingredients: ingredients) { [weak self] (success, results) in
            if success, let results = results {
                self?.search.getImage(imageURL: results[0].smallImageUrls[0], callback: { [weak self] (success, data) in
                    if success, let data = data {
                        self?.imageView.image = UIImage(data: data)
                    }
                })
            }
        }
    }
    
}

