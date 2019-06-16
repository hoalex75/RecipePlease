//
//  FavoritesViewController.swift
//  RecipePlease
//
//  Created by Alex on 02/06/2019.
//  Copyright © 2019 Alexandre Holet. All rights reserved.
//

import UIKit
import RxSwift

final class FavoritesViewController: UIViewController, DisplayAlertsInterface {
    var recipes: [RecipeCD] = RecipeCD.all()
    var recipeCD: RecipeCD?
    var search = SearchServices(storage: Storage())
    let disposeBag = DisposeBag()

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        recipes = RecipeCD.all()
        tableView.reloadData()
    }

    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        bindView()
        registerTableViewCells()
        // Do any additional setup after loading the view.
    }

    private func registerTableViewCells() {
        let resultCell = UINib(nibName: "ResultCell", bundle: nil)
        tableView.register(resultCell, forCellReuseIdentifier: "ResultCell")
    }

}

extension FavoritesViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        recipeCD = recipes[indexPath.row]
        self.showRecipe()
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recipes.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ResultCell", for: indexPath) as? ResultCell else {
            return UITableViewCell()
        }

        cellInitialize(cell, recipe: recipes[indexPath.row])
        return cell
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    private func cellInitialize(_ cell: ResultCell, recipe: RecipeCD) {
        cell.recipeNameLabel.text = recipe.name

        var ingredientsLabel = ""

        if let toIngredients = recipe.toIngredients {
            for element in toIngredients {
                if let ingredient = element as? IngredientsCD,let name = ingredient.name {
                    ingredientsLabel += name
                    ingredientsLabel += ", "
                }
            }
        }

        cell.ingredientsLabel.text = ingredientsLabel
        cell.ratingView.ratingLabel.text = String(recipe.rating)
        cell.ratingView.totalTimeLabel.text = recipe.totalTime
        cell.search = search

        if let image = recipe.toImages?.smallImageURL {
            cell.imageUrl = URL(string: image)
        }
    }
}

extension FavoritesViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if  segue.identifier == "segueCDtoRecipe",
            let segueVC = segue.destination as? RecipeViewController,
            let recipeCD = recipeCD,
            let recipe = recipeCD.convertToRecipe() {
            segueVC.search = search
            segueVC.recipe = recipe
        }
    }

    func showRecipe() {
        performSegue(withIdentifier: "segueCDtoRecipe", sender: nil)
    }
}

extension FavoritesViewController: ViewBinder {
    func bindView() {
        bindBackgrounds(tableView: tableView)
    }
}
