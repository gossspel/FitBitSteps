//
//  UILabelExtensions.swift
//  FitBitSteps
//
//  Created by Sunny Chan on 9/9/17.
//  Copyright © 2017 Mango. All rights reserved.
//

import UIKit

extension UILabel {
    func applyDefaultSetting() {
        self.translatesAutoresizingMaskIntoConstraints = false
        self.adjustsFontSizeToFitWidth = true
        self.minimumScaleFactor = 0.5
        self.numberOfLines = 1
        self.lineBreakMode = .byTruncatingTail
        self.textColor = UIColor.black
        self.font = UIFont.systemFont(ofSize: 14)
    }
}
