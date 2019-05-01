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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Storage.shared.ingredients = []
    }

    @IBAction func add() {
        addIngredientToList()
    }
    
    @IBAction func clear() {
        clearIngredientList()
    }
    
    @IBAction func search() {
    }
    
    private func addIngredientToList() {
        guard let text = searchField.text else { return }
        if text.count > 0 {
            Storage.shared.ingredients?.append(text)
            reloadTableView()
        }
    }
    
    private func clearIngredientList() {
        Storage.shared.ingredients = []
        reloadTableView()
    }
    
}

extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let ingredients = Storage.shared.ingredients else { return 0 }
        return ingredients.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let ingredients = Storage.shared.ingredients else { return UITableViewCell() }
        let cell = tableView.dequeueReusableCell(withIdentifier: "IngredientCell", for: indexPath)
        cell.textLabel?.text = ingredients[indexPath.row]
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
