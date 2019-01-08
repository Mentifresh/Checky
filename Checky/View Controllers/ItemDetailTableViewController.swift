//
//  itemDetailTableViewController.swift
//  Checky
//
//  Created by Daniel Kilders Díaz on 28/09/2018.
//  Copyright © 2018 dankil. All rights reserved.
//

import UIKit

// limit protocol inheritance to class-only
protocol ItemDetailTableViewControllerDelegate: class {
    func itemDetailTableViewControllerDidCancel( _ controller: ItemDetailTableViewController)
    func itemDetailTableViewController( _ controller: ItemDetailTableViewController, didFinishAdding item: ChecklistItem)
    func itemDetailTableViewController ( _ controller: ItemDetailTableViewController, didFinishEditing item: ChecklistItem)
}

class ItemDetailTableViewController: UITableViewController, UITextFieldDelegate {

    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var doneButton: UIBarButtonItem!
//    @IBOutlet weak var shouldRemindSwitch: UISwitch!
//    @IBOutlet weak var dueDateLabel: UILabel!
    
    var itemToEdit: ChecklistItem?
    var dueDate = Date()
    
    weak var delegate: ItemDetailTableViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Remove large title on this screen
        navigationItem.largeTitleDisplayMode = .never
        
        if let item = itemToEdit {
            title = "Edit Item"
            textField.text = item.text
            doneButton.isEnabled = true
//            shouldRemindSwitch.isOn = item.shouldRemind
//            dueDate = item.dueDate
        }
        
//        updateDueDateLabel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Makes sure the keyboard pops up when the view is loaded
        textField.becomeFirstResponder()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    // MARK: - Table View Delegates
    
    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        // Cancel all default system actions when tapping a row
        // We don't want the menu cell item to get marked in gray
        return nil
    }
    
    // MARK: - Actions
    
    @IBAction func cancel() {
        delegate?.itemDetailTableViewControllerDidCancel(self)
    }
    
    @IBAction func done() {
        if let item = itemToEdit {
            item.text = textField.text!
            
//            item.shouldRemind = shouldRemindSwitch.isOn
//            item.dueDate = dueDate
            
            delegate?.itemDetailTableViewController(self, didFinishEditing: item)
        } else {
            let item = ChecklistItem(text: textField.text!, active: false)
            
//            item.shouldRemind = shouldRemindSwitch.isOn
//            item.dueDate = dueDate
            
            delegate?.itemDetailTableViewController(self, didFinishAdding: item)
        }
    }
    
    // MARK: - Helper Methods
    
    func updateDueDateLabel() {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
//        dueDateLabel.text = formatter.string(from: dueDate)
    }

    // MARK: - Textview Delegate
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let oldText = textField.text!
        
        let stringRange = Range(range, in: oldText)!
        let newText = oldText.replacingCharacters(in: stringRange, with: string)
        
        doneButton.isEnabled = !newText.isEmpty
        
        return true
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        doneButton.isEnabled = false
        return true
    }
}
