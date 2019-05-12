//
//  SearchViewController.swift
//  RecipePlease
//
//  Created by Alex on 01/05/2019.
//  Copyright © 2019 Alexandre Holet. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController {
    @IBOutlet weak var searchField: UITextField!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var searchButton: UIButton!
    
    private var storage = Storage()
    private var searchService: SearchServices?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        storage.ingredients = []
        searchService = SearchServices(storage: storage)
    }

    @IBAction func add() {
        addIngredientToList()
    }
    
    @IBAction func clear() {
        clearIngredientList()
    }
    
    @IBAction func search() {
        searchRecipes()
    }
    
    private func toggleActivityIndicator(shown: Bool) {
        activityIndicator.isHidden = shown
        searchButton.isHidden = !shown
    }
    
    private func searchRecipes() {
        if storage.ingredientHaveChanged == false {
            showResults()
        } else {
            searchIfIngredientsIsNotNil()
        }
    }
    
    private func searchIfIngredientsIsNotNil() {
        guard let ingredients = storage.ingredients else { return }
        
        if ingredients.count > 0 {
            searchWithIngredients(ingredients)
        } else {
            // TODO: ALERT
        }
    }
    
    private func searchWithIngredients(_ ingredients: [String]) {
        guard let search = searchService else { return }
        
        toggleActivityIndicator(shown: false)
        search.getResultsWithIngredients(ingredients: ingredients) { [weak self] (success, _) in
            if success {
                print("ok")
                self?.showResults()
            } else {
                //TODO: ALERT
                print("nonOk")
            }
            self?.toggleActivityIndicator(shown: true)
        }
    }
    
    private func addIngredientToList() {
        guard let text = searchField.text else { return }
        
        if text.count > 0 {
            storage.ingredients?.append(text)
            reloadTableView()
        }
    }
    
    private func clearIngredientList() {
        storage.ingredients = []
        reloadTableView()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueToResults" {
            let segueVC = segue.destination as! ResultsViewController
            segueVC.search = searchService
            segueVC.storage = storage
        }
    }
    
    private func showResults() {
        performSegue(withIdentifier: "segueToResults", sender: nil)
    }
}

extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let ingredients = storage.ingredients else { return 0 }
        
        return ingredients.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let ingredients = storage.ingredients else { return UITableViewCell() }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "IngredientCell", for: indexPath)
        let ingredientString = ingredients[indexPath.row]
        cell.textLabel?.text = "- " + ingredientString.capitalized
        
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    private func reloadTableView() {
        tableView.reloadData()
    }
}

extension SearchViewController: UITextFieldDelegate {
    @IBAction func dismissKeyboard(_ sender: UITapGestureRecognizer) {
        searchField.resignFirstResponder()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        return true
    }
}
