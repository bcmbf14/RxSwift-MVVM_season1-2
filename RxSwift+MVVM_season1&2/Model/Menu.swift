//
//  Menu.swift
//  RxSwift+MVVM_season1&2
//
//  Created by jc.kim on 2/25/21.
//

import Foundation

struct Menu {
    var id: Int
    var name: String
    var price: Int
    var count: Int
}


extension Menu {
    static func fromMenuItems(id: Int, item: MenuItem) -> Menu {
        return Menu(id: id, name: item.name, price: item.price, count: 0)
    }
}
