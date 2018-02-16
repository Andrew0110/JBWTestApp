//
//  OccuranceCell.swift
//  JBWTestApp
//
//  Created by Andrew on 15.02.18.
//  Copyright © 2018 AR. All rights reserved.
//

import UIKit

class OccuranceCell: UITableViewCell {

    @IBOutlet weak private var characterLabel: UILabel?
    
    func configure(_ text:String) {
        self.characterLabel?.text = text
    }
}
