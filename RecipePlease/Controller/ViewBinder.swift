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
    func bindBackgrounds(backgroundView: UIView, tableView: UITableView?, textView: UITextView?, disposeBag: DisposeBag)
}

extension ViewBinder {
    func bindBackgrounds(backgroundView: UIView, tableView: UITableView? = nil, textView: UITextView? = nil, disposeBag: DisposeBag) {
        let backgroundColor = Settings.shared.backgroundColor

        backgroundColor.asDriver().drive(backgroundView.rx.backgroundColor).disposed(by: disposeBag)

        if let tableView = tableView {
            backgroundColor.asDriver().drive(tableView.rx.backgroundColor).disposed(by: disposeBag)
        }

        if let textView = textView {
            backgroundColor.asDriver().drive(textView.rx.backgroundColor).disposed(by: disposeBag)
        }
    }
}
