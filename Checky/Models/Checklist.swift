//
//  Checklist.swift
//  Checky
//
//  Created by Daniel Kilders Díaz on 09/10/2018.
//  Copyright © 2018 dankil. All rights reserved.
//

import UIKit

class Checklist: NSObject, Codable {
    var name = ""
    var iconName = ""
    var items = [ChecklistItem]()
    
    required init(name: String, iconName: String = "No Icon") {
        self.name = name
        self.iconName = iconName
        
        super.init()
    }
    
    func countUncheckedItems() -> Int {
        var count = 0
        
        for item in items where !item.checked {
            count += 1
        }
        
        return count
    }
}
