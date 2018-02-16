//
//  RoundedShadowView.swift
//  ItemRecognizer
//
//  Created by Andrew on 11.01.18.
//  Copyright © 2018 AR. All rights reserved.
//

import UIKit

class RoundedShadowView: UIView {

    override func awakeFromNib() {
        self.layer.shadowColor = UIColor.darkGray.cgColor
        self.layer.shadowRadius = 3
        self.layer.shadowOpacity = 0.75
        self.layer.cornerRadius = self.bounds.height / 2
    }

}
