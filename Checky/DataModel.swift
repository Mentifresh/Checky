//
//  DataModel.swift
//  Checky
//
//  Created by Daniel Kilders Díaz on 11/10/2018.
//  Copyright © 2018 dankil. All rights reserved.
//

import Foundation


class DataModel {
    
    let checklistIndexUD = "ChecklistIndex"
    let checklistFirstTimeUD = "FirstTime"
    
    var lists = [Checklist]()
    var indexOfSelectedChecklist: Int {
        get {
            return UserDefaults.standard.integer(forKey: checklistIndexUD)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: checklistIndexUD)
        }
    }
    
    init() {
        loadChecklists()
        registerDefaults()
        handleFirstTime()
    }
    
    func documentDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    // Path until our save file
    func dataFilePath() -> URL {
        return documentDirectory().appendingPathComponent("Checklists.plist")
    }
    
    public func saveChecklists() {
        let encoder = PropertyListEncoder()
        do {
            // Enconde lists
            let data = try encoder.encode(lists)
            try data.write(to: dataFilePath(), options: Data.WritingOptions.atomic)
            
        } catch {
            print("Error enconding list array: \(error.localizedDescription)")
        }
    }
    
    public func loadChecklists() {
        let path = dataFilePath()
        if let data = try? Data(contentsOf: path) {
            let decoder = PropertyListDecoder()
            do {
                // Decode to an object of [Checklist] type to lists
                lists = try decoder.decode([Checklist].self, from: data)
                sortChecklists()
            } catch {
                print("Error deconding list array: \(error.localizedDescription)")
            }
        }
    }
    
    func sortChecklists() {
        // Sort lists aphabetically in ascending order
        lists.sort(by: { list1, list2 in
            // localized compare, compares the two words considerint the rules of the current locale
            return list1.name.localizedStandardCompare(list2.name) == .orderedAscending
        })
    }
    
    func registerDefaults() {
        // Make sure User Defaults has a default value to use on first statup
        let dictionary = [checklistIndexUD: -1, checklistFirstTimeUD: true] as [String: Any]
        UserDefaults.standard.register(defaults: dictionary)
    }
    
    func handleFirstTime() {
        let userDefaults = UserDefaults.standard
        let firstTime = userDefaults.bool(forKey: checklistFirstTimeUD)
        
        if firstTime {
            let checklist = Checklist(name: "List")
            lists.append(checklist)
            
            indexOfSelectedChecklist = 0
            userDefaults.set(false, forKey: checklistFirstTimeUD)
            userDefaults.synchronize()
        }
    }
    
    // class: Allows me to call the method without having a reference to an instance
    // Method will return a new unique ID for each checklistitem
    class public func nextChecklistItemID() -> Int {
        let userDefaults = UserDefaults.standard
        // If the value doesn't exist (like in the first time it runs) it will return 0
        let itemID = userDefaults.integer(forKey: "ChecklistItemID")
        userDefaults.set(itemID + 1 , forKey: "ChecklistItemID")
        userDefaults.synchronize()
        
        return itemID
    }
}
