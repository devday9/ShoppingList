//
//  ShoppingList+Convenience.swift
//  ShoppingListTest
//
//  Created by Deven Day on 9/18/20.
//  Copyright © 2020 Deven Day. All rights reserved.
//

import Foundation
import CoreData

extension ShoppingList {
    
    convenience init(listItem: String, isComplete: Bool, context: NSManagedObjectContext = CoreDataStack.context) {
        self.init(context: context)
        self.listItem = listItem
        self.isComplete = isComplete
    }
}//END OF CLASS
