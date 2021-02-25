//
//  MenuItemTableViewCell.swift
//  RxSwift+MVVM_season1&2
//
//  Created by jc.kim on 2/25/21.
//

import UIKit

class MenuItemTableViewCell: UITableViewCell {
    
    static let reuseIdentifier = "MenuItemTableViewCell"
    
    @IBOutlet var title: UILabel!
    @IBOutlet var count: UILabel!
    @IBOutlet var price: UILabel!
    
    var onChange: ((Int) -> Void)?

    @IBAction func onIncreaseCount() {
        onChange?(+1)
    }

    @IBAction func onDecreaseCount() {
        onChange?(-1)
    }
}
