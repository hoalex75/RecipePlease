//
//  ViewController.swift
//  RecipePlease
//
//  Created by Alex on 21/04/2019.
//  Copyright © 2019 Alexandre Holet. All rights reserved.
//

import UIKit
import RxSwift

class ResultsViewController: UIViewController, DisplayAlertsInterface {
    var search: SearchServices?
    var storage: Storage?
    let disposeBag = DisposeBag()

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindView()
        registerTableViewCells()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationItem.title = "Results"
        bindNavigationItemColor()
        bindStatusBar()
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
        guard let storage = storage else { return 0 }
        guard let result = storage.result else { return 0 }
        
        return result.matches.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let storage = storage else { return UITableViewCell() }
        guard let result = storage.result?.matches[indexPath.row] else {
            return UITableViewCell()
        }
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ResultCell", for: indexPath) as? ResultCell else {
            return UITableViewCell()
        }
        
        cellInitialize(cell, result: result)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let result = storage?.result else { return }
        search?.getRecipe(recipeId: result.matches[indexPath.row].id, completionHandler: { [weak self] success in
            if success {
                self?.showRecipe()
            } else {
                self?.createAndDisplayErrorMessage(message: "An error occured during the loading of the recipe's details.")
            }
        })
    }
    
    private func cellInitialize(_ cell: ResultCell, result: RecipeResult) {
        cell.recipeNameLabel.text = result.recipeName
        cell.ingredientsLabel.text = result.ingredientsToString()
        if let rating = result.rating {
            cell.ratingView.ratingLabel.text = "\(rating)"
        }
        cell.ratingView.totalTimeLabel.text = result.totalTimeInSeconds.secondsToMinutesString()
        cell.search = search
        cell.imageUrl = result.imageUrlsBySize["90"]?.absoluteString
    }
}

extension ResultsViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if  segue.identifier == "segueToRecipe",
            let segueVC = segue.destination as? RecipeViewController,
            let storage = storage{
            segueVC.search = search
            segueVC.recipe = storage.recipe
        }
    }
    
    func showRecipe() {
        performSegue(withIdentifier: "segueToRecipe", sender: nil)
    }
}

extension ResultsViewController: ViewBinder {
    func bindView() {
        bindBackgrounds(tableView: tableView)
    }
}

