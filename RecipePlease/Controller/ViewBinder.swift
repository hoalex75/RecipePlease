//
//  viewBinder.swift
//  RecipePlease
//
//  Created by Alex on 16/06/2019.
//  Copyright © 2019 Alexandre Holet. All rights reserved.
//

import RxSwift
import RxCocoa
import UIKit

protocol ViewBinder {
    var disposeBag: DisposeBag { get }

    func bindBackgrounds(backgroundView: UIView?, tableView: UITableView?, textView: UITextView?)
    func bindTextColors(labels: [UILabel], textView: UITextView?)
}

extension ViewBinder {
    func bindBackgrounds(backgroundView: UIView? = nil, tableView: UITableView? = nil, textView: UITextView? = nil) {
        let backgroundColor = Settings.shared.backgroundColor

        if let backgroundView = backgroundView {
            backgroundColor.asDriver().drive(backgroundView.rx.backgroundColor).disposed(by: disposeBag)
        }

        if let tableView = tableView {
            backgroundColor.asDriver().drive(tableView.rx.backgroundColor).disposed(by: disposeBag)
        }

        if let textView = textView {
            backgroundColor.asDriver().drive(textView.rx.backgroundColor).disposed(by: disposeBag)
        }
    }

    func bindTextColors(labels: [UILabel], textView: UITextView? = nil) {
        let textColor = Settings.shared.textColor

        labels.forEach { label in
            textColor.asDriver().drive(label.rx.textColor).disposed(by: disposeBag)
        }

        if let textView = textView {
            textColor.asDriver().drive(textView.rx.textColor).disposed(by: disposeBag)
        }
    }

    func bindButtonsColors(buttons: [UIButton]) {
        let backColor = Settings.shared.backgroundColor
        let titleColor = Settings.shared.textColor

        buttons.forEach { button in
            titleColor.asDriver().drive(button.rx.backgroundColor).disposed(by: disposeBag)
            backColor.asDriver().drive(button.rx.titleColor).disposed(by: disposeBag)
            button.layer.cornerRadius = 8.0
        }
    }
}

extension ViewBinder where Self: UIViewController {
    func bindTabBar() {
        let backgroundColor = Settings.shared.backgroundColor
        let textColor = Settings.shared.textColor
        guard let tabBar = self.tabBarController?.tabBar else { return }

        backgroundColor.asDriver().drive(tabBar.rx.barTintColor).disposed(by: disposeBag)
        textColor.asDriver().drive(tabBar.rx.tintColor).disposed(by: disposeBag)
    }

    func bindNavBar() {
        let backgroundColor = Settings.shared.backgroundColor
        let textColor = Settings.shared.textColor
        guard let navBar = self.navigationController?.navigationBar else { return }

        navBar.isTranslucent = false
        backgroundColor.asDriver().drive(navBar.rx.barTintColor).disposed(by: disposeBag)
        textColor.asDriver().drive(navBar.rx.tintColor).disposed(by: disposeBag)
    }

    func bindNavigationItemColor() {
        let textColor = Settings.shared.textColor

        textColor.subscribe(onNext: { [weak self] color in
            DispatchQueue.main.async {
                let textAttributes = [NSAttributedString.Key.foregroundColor:color]
                self?.navigationController?.navigationBar.titleTextAttributes = textAttributes
            }
        }).disposed(by: disposeBag)
    }

    func bindStatusBar() {
        let backgroundColor = Settings.shared.backgroundColor

        backgroundColor.subscribe(onNext: { color in
            DispatchQueue.main.async {
                UIApplication.statusBarBackgroundColor = color
            }
        }).disposed(by: disposeBag)
    }
}
