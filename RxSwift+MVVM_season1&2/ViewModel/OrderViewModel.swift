//
//  OrderViewModel.swift
//  RxSwift+MVVM_season1&2
//
//  Created by jc.kim on 2/25/21.
//

import Foundation
import RxSwift
import RxRelay

class OrderViewModel {
    
    var orderObservable = BehaviorRelay<[Menu]>(value: [])
    
    init() {
        orderObservable
            .debug()
            .take(1)
            .subscribe(onNext: {
                print($0)
            })
            
    }

}
