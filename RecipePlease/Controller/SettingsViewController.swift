//
//  SettingsViewController.swift
//  RecipePlease
//
//  Created by Alex on 16/06/2019.
//  Copyright © 2019 Alexandre Holet. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class SettingsViewController: UIViewController {

    @IBOutlet var contentView: UIView!
    @IBOutlet weak var activateButton: UIButton!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var titleLabel: UILabel!

    private let disposeBag = DisposeBag()
    override func viewDidLoad() {
        super.viewDidLoad()
        bindView()
        // Do any additional setup after loading the view.
    }

    @IBAction func buttonTapped() {
        Settings.shared.changeDisplayMode()
    }


}


extension SettingsViewController: ViewBinder {
    private func bindView() {
        self.bindBackgrounds(backgroundView: contentView, textView: textView, disposeBag: disposeBag)
    }
}
