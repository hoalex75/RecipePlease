//
//  Rx+Helpers.swift
//  RecipePlease
//
//  Created by Alex on 16/06/2019.
//  Copyright © 2019 Alexandre Holet. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

extension Reactive where Base: UILabel {
    public var textColor : Binder<UIColor> {
        return Binder(self.base) { label, textColor in
            label.textColor = textColor
        }
    }
}


extension Reactive where Base: UITextView {
    public var textColor : Binder<UIColor> {
        return Binder(self.base) { textView, textColor in
            textView.textColor = textColor
        }
    }
}

extension Reactive where Base: UITabBar {
    public var barTintColor : Binder<UIColor> {
        return Binder(self.base) { tabBar, barTintColor in
            tabBar.barTintColor = barTintColor
        }
    }

    public var tintColor : Binder<UIColor> {
        return Binder(self.base) { tabBar, tintColor in
            tabBar.tintColor = tintColor
        }
    }
}

extension Reactive where Base: UINavigationBar {
    public var barTintColor : Binder<UIColor> {
        return Binder(self.base) { navBar, barTintColor in
            navBar.barTintColor = barTintColor
        }
    }

    public var tintColor : Binder<UIColor> {
        return Binder(self.base) { navBar, tintColor in
            navBar.tintColor = tintColor
        }
    }
}

extension Reactive where Base: UIButton {
    public var titleColor : Binder<UIColor> {
        return Binder(self.base) { button, titleColor in
            button.setTitleColor(titleColor, for: [])
        }
    }
}
