//
//  MainTableViewController.swift
//  ShoppingListTest
//
//  Created by Deven Day on 9/18/20.
//  Copyright © 2020 Deven Day. All rights reserved.
//

import UIKit
import CoreData

class MainTableViewController: UITableViewController {

    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ShoppingListController.sharedInstance.fetchResultsController.delegate = self
    }
    
    //MARK: - Actions
    @IBAction func addButtonTapped(_ sender: Any) {
        presentAlertController()
    }
    
    //MARK: - Helper Methods
    func presentAlertController() {
        let alertController = UIAlertController(title: "Add Item", message: "Please add an item to your shopping list", preferredStyle: .alert)
        
        alertController.addTextField { (textField) in
            textField.placeholder =  ""
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        let addItemAction = UIAlertAction(title: "Add", style: .default) { (_) in
            guard let listItem = alertController.textFields?[0].text, !listItem.isEmpty else {return}
            
            ShoppingListController.sharedInstance.addItem(listItem: listItem)
        }
        
        alertController.addAction(cancelAction)
        alertController.addAction(addItemAction)
        
        present(alertController, animated: true)
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return ShoppingListController.sharedInstance.fetchResultsController.sections?.count ?? 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ShoppingListController.sharedInstance.fetchResultsController.sections?[section].numberOfObjects ?? 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "listCell", for: indexPath) as? ShoppingListTableViewCell else {return UITableViewCell()}

        let item = ShoppingListController.sharedInstance.fetchResultsController.object(at: indexPath)
        
        cell.item = item
        cell.delegate = self

        return cell
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let itemToDelete = ShoppingListController.sharedInstance.fetchResultsController.object(at: indexPath)
            ShoppingListController.sharedInstance.removeItem(shoppingList: itemToDelete)
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return view.frame.height / 12
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return ShoppingListController.sharedInstance.fetchResultsController.sectionIndexTitles[section] == "0" ? "Incomplete" : "Completed"
    }
}//END OF CLASS

//MARK: - Extensions
extension MainTableViewController: ShoppingListTableViewCellDelegate {
    
    func isCompleteButtonTapped(_ sender: ShoppingListTableViewCell) {
        guard let index = tableView.indexPath(for: sender) else {return}
        let item = ShoppingListController.sharedInstance.fetchResultsController.object(at: index)
        ShoppingListController.sharedInstance.updateComplete(shoppingList: item)
        sender.updateViews()
    }
}//END OF EXTENSION

extension MainTableViewController: NSFetchedResultsControllerDelegate {
        
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
            self.tableView.beginUpdates()
        }
        
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
            
        switch type {
        case .insert:
                let indexSet = IndexSet(integer: sectionIndex)
                tableView.insertSections(indexSet, with: .automatic)
                
        case .delete:
            let indexSet = IndexSet(integer: sectionIndex)
                tableView.deleteSections(indexSet, with: .automatic)
                
        default:
            break
        }
    }
        
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
            
        switch type {
        case .delete:
            guard let indexPath = indexPath else {return}
                tableView.deleteRows(at: [indexPath], with: .fade)
        case .insert:
            guard let newIndexPath = newIndexPath else {return}
                tableView.insertRows(at: [newIndexPath], with: .automatic)
        case .move:
            guard let oldIndexPath = indexPath, let newIndexPath = newIndexPath else {return}
                tableView.moveRow(at: oldIndexPath, to: newIndexPath)
        case .update:
            guard let indexPath = indexPath else {return}
                tableView.reloadRows(at: [indexPath], with: .automatic)
            @unknown default:
                fatalError()
            }
        }
        
        func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
            tableView.endUpdates()
        }
    }//End of extension
