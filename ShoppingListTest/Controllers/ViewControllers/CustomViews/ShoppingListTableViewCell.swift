//
//  ShoppingListTableViewCell.swift
//  ShoppingListTest
//
//  Created by Deven Day on 9/18/20.
//  Copyright © 2020 Deven Day. All rights reserved.
//

import UIKit

//MARK: - Protocols
protocol ShoppingListTableViewCellDelegate: AnyObject {
    func isCompleteButtonTapped(_ sender: ShoppingListTableViewCell)
}

class ShoppingListTableViewCell: UITableViewCell {

    //MARK: - Outlets
    @IBOutlet weak var itemLabel: UILabel!
    @IBOutlet weak var isCompleteButton: UIButton!
    
    //MARK: - Properties
    var item: ShoppingList? {
        didSet {
            updateViews()
        }
    }
    
    weak var delegate: ShoppingListTableViewCellDelegate?

    
    //MARK: - Actions
    @IBAction func isCompleteButtonTapped(_ sender: Any) {
        delegate?.isCompleteButtonTapped(self)
    }
    
    
    //MARK: - Helper Methods
    func updateViews() {
        itemLabel.text = item?.listItem
        
        let imageName = (item?.isComplete ?? false) ? "complete" : "incomplete"
        isCompleteButton.setImage(UIImage(named: imageName), for: .normal)
    }
}//END OF CLASS
