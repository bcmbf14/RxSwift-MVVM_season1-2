//
//  MenuViewModel.swift
//  RxSwift+MVVM_season1&2
//
//  Created by jc.kim on 2/25/21.
//

import Foundation
import RxSwift
import RxRelay

class MenuListViewModel {
    
    var menuObservable = BehaviorRelay<[Menu]>(value: [])

    
    lazy var itemCount = menuObservable.map {
        $0.map { $0.count }.reduce(0, +)
    }
    
    lazy var totalPrice = menuObservable.map {
        $0.map { $0.price * $0.count }.reduce(0, +)
    }
    
    init() {
        _ = APIService.fetchAllMenusRx()
            .map { data -> [MenuItem] in
                struct Response: Decodable {
                    let menus: [MenuItem]
                }
                let response = try! JSONDecoder().decode(Response.self, from: data)
                return response.menus
            }
            .map { menuItems -> [Menu] in
                menuItems.enumerated().map { index, item in
                    return Menu.fromMenuItems(id: index, item: item)
                }
            }
            .take(1)
            .bind(to: menuObservable)
    }
    
    var disposeBag = DisposeBag()
    
    func clearAllItemSelections() {
        _ = menuObservable
            .map { menus in
                menus.map { menu in
                    Menu(id: menu.id, name: menu.name, price: menu.price, count: 0)
                }
            }
            .take(1)
            .subscribe(onNext: {
                self.menuObservable.accept($0)
            }, onCompleted: {
                print("com")
            }, onDisposed: {
                print("dis")
            })
    }
    
    func changeCount(item: Menu, change: Int) {
        _ = menuObservable
            .subscribe(on: ConcurrentDispatchQueueScheduler(qos: .default))
            .map { menus in
                menus.map { menu in
                    if menu.id == item.id {
                        return Menu(id: menu.id,
                                    name: menu.name,
                                    price: menu.price,
                                    count: max(menu.count + change, 0))
                    } else {
                        return Menu(id: menu.id,
                                    name: menu.name,
                                    price: menu.price,
                                    count: menu.count)
                    }
                }
            }
            .take(1)
            .catchAndReturn([])
            .observe(on: MainScheduler.instance)
            .bind(to: menuObservable)
    }
    

}
