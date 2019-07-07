//
//  SearchViewController.swift
//  RecipePlease
//
//  Created by Alex on 01/05/2019.
//  Copyright © 2019 Alexandre Holet. All rights reserved.
//

import UIKit
import RxSwift

class SearchViewController: UIViewController, DisplayAlertsInterface {
    
    @IBOutlet weak var clearButton: UIButton!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var fridgeLabel: UILabel!
    @IBOutlet weak var ingredientsLabel: UILabel!
    @IBOutlet weak var billboardView: UIView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var searchField: UITextField!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var searchButton: UIButton!
    
    private var storage = Storage()
    private var searchService: SearchServices?
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        storage.ingredients = []
        searchService = SearchServices(storage: storage)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        bindTabBar()
        bindNavBar()
        bindStatusBar()
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
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

    private func setupView() {
        let paddingView: UIView = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: 20))
        searchField.leftView = paddingView
        searchField.leftViewMode = .always
        billboardView.layer.cornerRadius = 8.0
        searchField.layer.cornerRadius = 4.0
        bindView()
    }

    private func fixTableViewInsets() {
        let zContentInsets = UIEdgeInsets.zero
        tableView.contentInset = zContentInsets
        tableView.scrollIndicatorInsets = zContentInsets
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        fixTableViewInsets()
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
        }
    }
    
    private func searchWithIngredients(_ ingredients: [String]) {
        guard let search = searchService else { return }
        
        toggleActivityIndicator(shown: false)
        search.getResultsWithIngredients(ingredients: ingredients) { [weak self] (success, _) in
            if success {
                self?.showResults()
            } else {
                self?.createAndDisplayErrorMessage(message: "An error occured during the loading of your search's results.")
            }
            self?.toggleActivityIndicator(shown: true)
        }
    }
    
    private func addIngredientToList() {
        guard let text = searchField.text else { return }
        
        if text.count > 0 {
            storage.ingredients?.append(text)
            reloadTableView()
            searchField.text = ""
        }
    }
    
    private func clearIngredientList() {
        storage.ingredients = []
        reloadTableView()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueToResults", let segueVC = segue.destination as? ResultsViewController {
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
        addIngredientToList()
        textField.resignFirstResponder()
        
        return true
    }
}

extension SearchViewController: ViewBinder {
    func bindView() {
        bindBackgrounds(backgroundView: contentView)
        bindTextColors(labels: [ingredientsLabel, fridgeLabel])
        bindButtonsColors(buttons: [searchButton, addButton, clearButton])
    }
}
