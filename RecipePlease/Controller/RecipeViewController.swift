//
//  RecipeViewController.swift
//  RecipePlease
//
//  Created by Alex on 25/05/2019.
//  Copyright © 2019 Alexandre Holet. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class RecipeViewController: UIViewController, DisplayAlertsInterface {
   
    @IBOutlet weak var ingredientsLabel: UILabel!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var billboardView: UIView!
    @IBOutlet weak var redirectionButton: UIButton!
    @IBOutlet weak var ratingView: RatingView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var recipeImageVIew: UIImageView!
    @IBOutlet weak var recipeNameLabel: UILabel!
    
    var search: SearchServices?
    var recipe: Recipe?
    let disposeBag = DisposeBag()
    let isPresentInDataBase = BehaviorRelay<Bool>(value: false)

    var isInFavorite: Bool? {
        guard let recipe = recipe else { return nil }
        return RecipeCD.isPresentInDataBase(recipe: recipe)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationItem.title = "Recipe"
        bindNavigationItemColor()
        if let isInFavorite = isInFavorite {
            isPresentInDataBase.accept(isInFavorite)
        }
    }

    @IBAction func getDirections() {
        guard let url = recipe?.source.sourceRecipeUrl else { return } 
        if UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }

    private func addToFavorites(recipe: Recipe) {
        let recipeCD = RecipeCD(context: AppDelegate.viewContext)
        recipeCD.saveARecipe(recipe: recipe, completionHandler: { [weak self] in
            self?.isPresentInDataBase.accept(true)
        })
    }

    private func deleteFromFavorites(recipe: Recipe) {
        RecipeCD.deleteRecipe(recipe: recipe, completionHandler: { [weak self] in
                self?.isPresentInDataBase.accept(false)
            },onError: {
                createAndDisplayErrorMessage(message: "An error occured during the delete of your favorite recipe.")
            })

    }

    @objc private func favTapped() {
        guard let isInFavorite = isInFavorite, let recipe = recipe else { return }
        if isInFavorite {
            createAndDispalyInfoPopin(message: "You are about to delete this recipe from your favorite ones. Do you really want it ?", action: { [weak self] in
                self?.deleteFromFavorites(recipe: recipe)
            })
        } else {
            addToFavorites(recipe: recipe)
        }
    }
}

private extension RecipeViewController {
    func setupView() {
        billboardView.layer.cornerRadius = 5.0
        bindView()
        guard let recipe = recipe else { return }

        isPresentInDataBase.subscribe(onNext: { [weak self] isPresent in
            self?.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: isPresent ? .trash : .save, target: self, action: #selector(self?.favTapped))
        }).disposed(by: disposeBag)

        setImage(with: recipe)
        setTitle(with: recipe)
        setRatings(with: recipe)
    }
    
    func setImage(with recipe: Recipe) {
        guard let search = search, let url = urlImage(with: recipe) else {
            //TODO Image par défaut
            return
        }
        search.getImage(imageURL: url) { [weak self] success, data in
            if success {
                if let data = data {
                    self?.recipeImageVIew.image = UIImage(data: data)
                }
            } else {
                self?.createAndDisplayErrorMessage(message: "An error occured during the loading of the image.")
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

extension RecipeViewController: ViewBinder {
    func bindView() {
        bindBackgrounds(backgroundView: contentView)
        bindTextColors(labels: [ingredientsLabel, recipeNameLabel])
        bindButtonsColors(buttons: [redirectionButton])
    }
}
