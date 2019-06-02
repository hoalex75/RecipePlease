//
//  RecipeViewController.swift
//  RecipePlease
//
//  Created by Alex on 25/05/2019.
//  Copyright © 2019 Alexandre Holet. All rights reserved.
//

import UIKit

class RecipeViewController: UIViewController {
   
    @IBOutlet weak var ratingView: RatingView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var recipeImageVIew: UIImageView!
    @IBOutlet weak var recipeNameLabel: UILabel!
    
    var search: SearchServices?
    var recipe: Recipe?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
    }

    @IBAction func getDirections() {
        addToFavorites()
        guard let url = recipe?.source.sourceRecipeUrl else { return } 
        if UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }

    private func addToFavorites() {
        guard let recipe = recipe else { return }

        let recipeCD = RecipeCD(context: AppDelegate.viewContext)
        recipeCD.saveARecipe(recipe: recipe)
    }
}

private extension RecipeViewController {
    func setupView() {
        guard let recipe = recipe else { return }
        setImage(with: recipe)
        setTitle(with: recipe)
        setRatings(with: recipe)
    }
    
    func setImage(with recipe: Recipe) {
        guard let search = search, let url = urlImage(with: recipe) else {
            //TODO
            return
        }
        search.getImage(imageURL: url) { [weak self] success, data in
            if success {
                if let data = data {
                    self?.recipeImageVIew.image = UIImage(data: data)
                }
            } else {
                //TODO
                self?.recipeImageVIew.image = UIImage(named: "Clock")
            }
        }
    }
    
    func urlImage(with recipe: Recipe) -> URL? {
        if let url = recipe.images[0].hostedLargeUrl {
            return url
        }
        
        if let url = recipe.images[0].hostedMediumUrl {
            return url
        }
        
        if let url = recipe.images[0].hostedSmallUrl {
            return url
        }
        
        if let tab = recipe.images[0].imageUrlsBySize, let url = tab["360"] {
            return url
        }
        
        if let tab = recipe.images[0].imageUrlsBySize, let url = tab["90"] {
            return url
        }
        
        return nil
    }
    
    func setTitle(with recipe: Recipe) {
        recipeNameLabel.text = recipe.name
    }
    
    func setRatings(with recipe: Recipe) {
        let ratingVote: String
        let totalTime: String
        
        if let rating = recipe.rating {
            ratingVote = String(rating)
        } else {
            ratingVote = "N/A"
        }
        
        if let time = recipe.totalTime {
            totalTime = time
        } else {
            totalTime = "N/A"
        }
        
        ratingView.totalTimeLabel.text = totalTime
        ratingView.ratingLabel.text = ratingVote
    }
}

extension RecipeViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let recipe = recipe else { return 0 }
        return recipe.ingredientLines.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let recipe = recipe else { return UITableViewCell() }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "IngredientCell", for: indexPath)
        let ingredientString = recipe.ingredientLines[indexPath.row]
        cell.textLabel?.text = String(format: "- %@", ingredientString.capitalized)
        
        return cell
    }
}
