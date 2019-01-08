//
//  AllListsViewController.swift
//  Checky
//
//  Created by Daniel Kilders Díaz on 05/10/2018.
//  Copyright © 2018 dankil. All rights reserved.
//

import UIKit

class AllListsViewController: UITableViewController, ListDetailViewControllerDelegate, UINavigationControllerDelegate {
    
    let cellIdentifier = "ChecklistCell"
    let showCheckListSegue = "ShowChecklist"
    let addChecklistSegue = "AddChecklist"
    var dataModel: DataModel!

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.prefersLargeTitles = true
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        navigationController?.delegate = self
        
        let index = dataModel.indexOfSelectedChecklist
        
        if index >= 0 && index < dataModel.lists.count {
            let checklist = dataModel.lists[index]
            performSegue(withIdentifier: showCheckListSegue, sender: checklist)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataModel.lists.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Ask the tableview if it already has a cell with the indetifier, so it can be reused
        // Create a cell with the style of .subtitle if there is no other cell available
        let cell: UITableViewCell!
        let checklist = dataModel.lists[indexPath.row]
        
        if let c = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) {
            cell = c
        } else {
            cell = UITableViewCell(style: .subtitle, reuseIdentifier: cellIdentifier)
        }
        
        cell.accessoryType = .detailDisclosureButton
        

        cell.textLabel!.text = checklist.name
        cell.imageView!.image = UIImage(named: checklist.iconName)
        
        // Show number of remaining checklist items
        if checklist.items.count == 0 {
            cell.detailTextLabel!.text = "(No items)"
        } else {
            let count = dataModel.lists[indexPath.row].countUncheckedItems()
            cell.detailTextLabel!.text = count == 0 ? "All Done" : "\(count) Remaining"
        }

        return cell
    }
    
    // MARK: - Table view delegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let checklist = dataModel.lists[indexPath.row]
        
        dataModel.indexOfSelectedChecklist = indexPath.row
        
        performSegue(withIdentifier: showCheckListSegue, sender: checklist)
    }
    
    override func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        // Loading a new controller by hand instead of using a segue to have some variaty
        let controller = storyboard!.instantiateViewController(withIdentifier: "ListDetailViewController") as! ListDetailViewController
        controller.delegate = self
        
        let checklist = dataModel.lists[indexPath.row]
        controller.checklistToEdit = checklist
        
        navigationController?.pushViewController(controller, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        dataModel.lists.remove(at: indexPath.row)
        
        let indexPaths = [indexPath]
        tableView.deleteRows(at: indexPaths, with: .automatic)
    }

    // MARK: - List Detail View Delegates
    
    func listDetailViewControllerDidCancel(_ controller: ListDetailViewController) {
        navigationController?.popViewController(animated: true)
    }
    
    func listDetailViewController(_ controller: ListDetailViewController, didFinishAdding checklist: Checklist) {
        dataModel.lists.append(checklist)
        dataModel.sortChecklists()
        tableView.reloadData()
        navigationController?.popViewController(animated: true)
    }
    
    func listDetailViewController(_ controller: ListDetailViewController, didFinishEditing checklist: Checklist) {
        dataModel.sortChecklists()
        tableView.reloadData()
        navigationController?.popViewController(animated: true)
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == showCheckListSegue {
            let controller = segue.destination as! CheckListViewController
            
            controller.checkList = sender as? Checklist
        } else if segue.identifier == addChecklistSegue {
            let controller = segue.destination as! ListDetailViewController
            controller.delegate = self
        }
    }
    
    // MARK: - Navigation Controller Delegates
    
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        // Was the back button tapped?
            // === is used to check if they're identical. Same object in memory.
            // view controllers are already compared using references, so == would work fine. === is still more correct.
        if viewController === self {
            dataModel.indexOfSelectedChecklist = -1
        }
    }
}
