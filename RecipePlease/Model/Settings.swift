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
    let isInDarkMode = BehaviorRelay<Bool>(value: false)
    private let disposeBag = DisposeBag()
    let backgroundColor = BehaviorRelay<UIColor>(value: UIColor.white)
    let textColor = BehaviorRelay<UIColor>(value: UIColor.black)

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
            let color = isOn ? UIColor.darkModeBackground : UIColor.normalModeBackground

            return color
        }.bind(to: backgroundColor).disposed(by: disposeBag)

        isInDarkMode.map { isOn -> UIColor in
            let color = isOn ? UIColor.normalModeBackground : UIColor.darkModeBackground

            return color
        }.bind(to: textColor).disposed(by: disposeBag)
    }

    func getText(_ isOn: Bool) -> String {
        if isOn {
            return "You can deactivate the dark mode when it seems the right moment to you !"
        } else {
            return "You can activate the dark mode at any time in order to rest your eyes from this such aggressive light !"
        }
    }
}
