//
//  ShoppingListController.swift
//  ShoppingListTest
//
//  Created by Deven Day on 9/18/20.
//  Copyright © 2020 Deven Day. All rights reserved.
//

import Foundation
import CoreData

class ShoppingListController {
    
    //MARK: - Properties
    static let sharedInstance = ShoppingListController()
    
    let fetchResultsController: NSFetchedResultsController<ShoppingList> = {
        let fetchRequest: NSFetchRequest<ShoppingList> = ShoppingList.fetchRequest()
        let veiledSort = NSSortDescriptor(key: "isComplete", ascending: false)
        
        fetchRequest.sortDescriptors = [veiledSort]
        
        return NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: CoreDataStack.context, sectionNameKeyPath: "isComplete", cacheName: nil)
    }()
    
    init() {
        do {
            try fetchResultsController.performFetch()
        } catch {
            print("Error in \(#function) : \(error.localizedDescription) \n---\n \(error)")
        }
    }
    
    //MARK: - CRUD Functions
    func addItem(listItem: String) {
        _ = ShoppingList(listItem: listItem, isComplete: false)
        
        saveToPersistentStore()
    }
    
    func updateItem(shoppingList: ShoppingList, listItem: String) {
        shoppingList.listItem = listItem
        
        saveToPersistentStore()
    }
    
    func updateComplete(shoppingList: ShoppingList ) {
        shoppingList.isComplete = !shoppingList.isComplete
        
        saveToPersistentStore()
    }
    
    func removeItem(shoppingList: ShoppingList) {
        let moc = CoreDataStack.context
        moc.delete(shoppingList)
        
        saveToPersistentStore()
    }
    
    //MARK: - Persistence
    func saveToPersistentStore() {
        do {
            try CoreDataStack.context.save()
        } catch {
            print("Error in \(#function) : \(error.localizedDescription) \n---\n \(error)")
        }
    }
}//END OF CLASS
