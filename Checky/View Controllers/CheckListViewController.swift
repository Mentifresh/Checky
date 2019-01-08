//
//  ViewController.swift
//  Checky
//
//  Created by Daniel Kilders Díaz on 27/09/2018.
//  Copyright © 2018 dankil. All rights reserved.
//

import UIKit

class CheckListViewController: UITableViewController, ItemDetailTableViewControllerDelegate {
    
    
    let cellIdentifier = "ChecklistItem"
    var checkList: Checklist!

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.largeTitleDisplayMode = .never
        
        title = checkList.name
    }
    
    // MARK: - Table View Delegate
    
    // React to a user tapping in a cell
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) {
            let currentItem = checkList.items[indexPath.row]
            
            currentItem.toggleChecked()
            configureCheckmark(for: cell, with: currentItem)
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    // Allows for items to be deleted with swiping
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        // Delete item from data model
        checkList.items.remove(at: indexPath.row)
        
        // Delete item from table view
        let indexPaths = [indexPath]
        tableView.deleteRows(at: indexPaths, with: .automatic)
    }

    // MARK: - Table View Data Source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return checkList.items.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
        let currentItem = checkList.items[indexPath.row]
        
        configureText(for: cell, with: currentItem)
        configureCheckmark(for: cell, with: currentItem)
        
        return cell
    }
    
    // MARK: - Actions
    
    @IBAction func addItem() {
        
    }
    
    // MARK: - itemDetailTableViewController Delegate
    
    func itemDetailTableViewControllerDidCancel(_ controller: ItemDetailTableViewController) {
        navigationController?.popViewController(animated: true)
    }
    
    func itemDetailTableViewController(_ controller: ItemDetailTableViewController, didFinishAdding item: ChecklistItem) {
        let newRowIndex = checkList.items.count
        
        checkList.items.append(item)
        
        let indexPath = IndexPath(row: newRowIndex, section: 0)
        let indexPaths = [indexPath]
        tableView.insertRows(at: indexPaths, with: .automatic)
        
        navigationController?.popViewController(animated: true)
    }
    
    func itemDetailTableViewController(_ controller: ItemDetailTableViewController, didFinishEditing item: ChecklistItem) {
        if let index = checkList.items.index(of: item) {
            let indexPath = IndexPath(row: index, section: 0)
            if let cell = tableView.cellForRow(at: indexPath) {
                configureText(for: cell, with: item)
            }
        }
        
        navigationController?.popViewController(animated: true)
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "AddItem" {
            let controller = segue.destination as! ItemDetailTableViewController
            
            // Set CheckListViewController as delegate of AddItemViewController
            controller.delegate = self
            
        } else if segue.identifier == "EditItem" {
            let controller = segue.destination as! ItemDetailTableViewController
            
            controller.delegate = self
            
            if let indexPath = tableView.indexPath(for: sender as! UITableViewCell) {
                controller.itemToEdit = checkList.items[indexPath.row]
            }
        }
    }
    
    // MARK: - Saving/Reading Data
    
//    func saveChecklistItems() {
//        let encoder = PropertyListEncoder()
//        do {
//            let data = try encoder.encode(itemsArray)
//            try data.write(to: dataFilePath(), options: Data.WritingOptions.atomic)
//        } catch {
//            print("Error enconding item array: \(error.localizedDescription)")
//        }
//    }
//
//    func loadChecklistItems() {
//        let path = dataFilePath()
//
//        // If plist file is not found it will fail silently
//            // Should only happen first time the app oppens
//        if let data = try? Data(contentsOf: path) {
//            let decoder = PropertyListDecoder()
//            do {
//                itemsArray = try decoder.decode([ChecklistItem].self, from: data)
//            } catch {
//                print("Error decoding item array: \(error.localizedDescription)")
//            }
//        }
//    }
    
    // MARK: - Custom functions
    
    // Path until the document directory
    
    private func configureCheckmark(for cell: UITableViewCell, with item: ChecklistItem) {
        
        let label = cell.viewWithTag(1001) as! UILabel
        
        if item.checked {
            label.text = "√"
        } else {
            label.text = ""
        }
    }
    
    private func configureText(for cell: UITableViewCell, with item: ChecklistItem) {
        let label = cell.viewWithTag(1000) as! UILabel
        label.text = item.text
//        label.text = "\(item.itemID): \(item.text)"
    }
}

