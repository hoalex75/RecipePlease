//
//  File.swift
//  RecipePlease
//
//  Created by Alex on 16/06/2019.
//  Copyright © 2019 Alexandre Holet. All rights reserved.
//

import RxSwift
import RxCocoa

class Settings {
    static var shared: Settings = Settings()
    private let isInDarkMode = BehaviorRelay<Bool>(value: false)
    private let disposeBag = DisposeBag()
    let backgroundColor = BehaviorRelay<UIColor>(value: UIColor.white)

    private init() {
        bindColors()
        if let isDarkModeOn = UserDefaults.standard.object(forKey: "darkMode") as? Bool {
            isInDarkMode.accept(isDarkModeOn)
        }
    }

    func changeDisplayMode() {
        let activeMode = isInDarkMode.value
        UserDefaults.standard.set(!activeMode, forKey: "darkMode")
        isInDarkMode.accept(!activeMode)
    }

    func bindColors() {
        isInDarkMode.map { isOn -> UIColor in
            let color = isOn ? UIColor.black : UIColor.green

            return color
        }.bind(to: backgroundColor).disposed(by: disposeBag)
    }
}
