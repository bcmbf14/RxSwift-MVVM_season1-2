//
//  LoginViewModel.swift
//  RxSwift+MVVM_season1&2
//
//  Created by jc.kim on 2/25/21.
//

import Foundation
import RxSwift
import RxRelay

class LoginViewModel {
    
    let idFieldObservable = BehaviorRelay(value: "")
    let pwFieldObservable = BehaviorRelay(value: "")
    
    let idVaildObservable = BehaviorRelay(value: false)
    let pwVaildObservable = BehaviorRelay(value: false)
    
    var disposeBag = DisposeBag()

    
    init() {
        
        idFieldObservable.map(checkEmailVaild)
            .bind(to: idVaildObservable)
            .disposed(by: disposeBag)
        
        pwFieldObservable.map(checkPasswordVaild)
            .bind(to: pwVaildObservable)
            .disposed(by: disposeBag)
        
    }
    
    
    private func checkEmailVaild(_ email:String) -> Bool{
        return email.contains("@") && email.contains(".")
    }
    
    private func checkPasswordVaild(_ password: String) -> Bool{
        return password.count > 5
    }
    
}
