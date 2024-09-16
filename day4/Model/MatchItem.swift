//
//  MatchItem.swift
//  day4
//
//  Created by Doeun Kwon on 2024-09-15.
//

import Foundation
import UIKit

class MatchItem {
    let emoji: String
    let color: UIColor
    var isConcealed: Bool = false
    
    init(emoji: String, color: UIColor) {
        self.emoji = emoji
        self.color = color
    }
    
}
