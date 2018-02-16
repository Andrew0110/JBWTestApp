//
//  RoundedShadowButton.swift
//  ItemRecognizer
//
//  Created by Andrew on 11.01.18.
//  Copyright © 2018 AR. All rights reserved.
//

import UIKit

class RoundedShadowButton: UIButton {

    override func awakeFromNib() {
        self.layer.shadowColor = UIColor.darkGray.cgColor
        self.layer.shadowRadius = 10
        self.layer.shadowOpacity = 0.75
        self.layer.cornerRadius = self.bounds.height / 2
    }

}
