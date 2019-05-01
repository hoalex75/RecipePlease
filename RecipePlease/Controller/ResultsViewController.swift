//
//  ViewController.swift
//  RecipePlease
//
//  Created by Alex on 21/04/2019.
//  Copyright © 2019 Alexandre Holet. All rights reserved.
//

import UIKit

class ResultsViewController: UIViewController {
    private var search = SearchServices()
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerTableViewCells()
        getResults()
    }
    
    private func getResults() {
        let ingredients = ["garlic","cognac"]
        search.getResultsWithIngredients(ingredients: ingredients) { [weak self] (success, results) in
            if success, let results = results {
                print("ok")
                self?.tableView.reloadData()
            } else {
                print("nonOk")
            }
        }
    }
    
    private func registerTableViewCells() {
        let resultCell = UINib(nibName: "ResultCell", bundle: nil)
        tableView.register(resultCell, forCellReuseIdentifier: "ResultCell")
    }
}

extension ResultsViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let result = Storage.shared.result else { return 0 }
        return result.matches.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let result = Storage.shared.result?.matches[indexPath.row] else {
            return UITableViewCell()
        }
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ResultCell", for: indexPath) as? ResultCell else {
            return UITableViewCell()
        }
        cell.recipeNameLabel.text = result.recipeName
        cell.ingredientsLabel.text = result.ingredientsToString()
        cell.imageUrl = result.imageUrlsBySize["90"]
        return cell
    }
    
    
}



