//
//  File.swift
//  RecipePlease
//
//  Created by Alex on 02/06/2019.
//  Copyright © 2019 Alexandre Holet. All rights reserved.
//

import Foundation
import UIKit

protocol DisplayAlertsInterface: class {
    func createAndDisplayErrorMessage(message: String)
    func createAndDispalyInfoPopin(message : String, action: @escaping (() -> Void))
}

extension DisplayAlertsInterface where Self: UIViewController {
    func createAndDisplayErrorMessage(message : String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
        alert.addAction(action)

        self.present(alert, animated: true, completion: nil)
    }

    func createAndDispalyInfoPopin(message : String, action: @escaping (() -> Void)) {
        let alert = UIAlertController(title: "Info", message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "Ok", style: .default) { _ in
            action()
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(action)
        alert.addAction(cancelAction)

        self.present(alert, animated: true, completion: nil)
    }
}
