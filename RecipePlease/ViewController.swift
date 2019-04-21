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
        let url = URL(string: "https://lh3.googleusercontent.com/ivgTpXH4akDpObDA2OoYI-_oA6Cue7gO6YKnBEEk7hv1ev5obKOqhpwhQxjDpuQnyO5SGovVRKNNsjX2tCmdxcU=s90")
        search.getImage(imageURL: url!) { [weak self] (success, data) in
            if success {
                guard let data = data else {
                    return
                }
                self?.imageView.image = UIImage(data: data)
            }
        }
    }
    
}

