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

    let disposeBag = DisposeBag()
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
        bindBackgrounds(backgroundView: contentView, textView: textView)
        bindTextColors(labels: [titleLabel], textView: textView)
        bindButtonsColors(buttons: [activateButton])
        Settings.shared.isInDarkMode.subscribe(onNext: { [weak self] isOn in
            DispatchQueue.main.async {
                self?.activateButton.setTitle(isOn ? "Deactivate" : "Activate", for: .normal)
                self?.textView.text = Settings.shared.getText(isOn)
            }
        }).disposed(by: disposeBag)
    }
}
