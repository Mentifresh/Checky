//
//  ChecklistItem.swift
//  Checky
//
//  Created by Daniel Kilders Díaz on 27/09/2018.
//  Copyright © 2018 dankil. All rights reserved.
//

import Foundation


class ChecklistItem: NSObject, Codable {
    var text = ""
    var checked = false
    var dueDate = Date()
    var shouldRemind = false
    var itemID = -1
    
    required init(text: String, active: Bool = false) {
        self.text = text
        self.checked = active
        self.itemID = DataModel.nextChecklistItemID()
        
        super.init()
    }
    
    func toggleChecked() {
        checked = !checked
    }
}
