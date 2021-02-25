//
//  LoginViewController.swift
//  RxSwift+MVVM_season1&2
//
//  Created by jc.kim on 2/25/21.
//

import UIKit
import RxSwift
import RxCocoa

class LoginViewController: UIViewController {
    
    let viewModel = LoginViewModel()
    var disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // MARK: input
        
        idField.rx.text.orEmpty
            .asDriver(onErrorJustReturn: "")
            .drive(viewModel.idFieldObservable)
            .disposed(by: disposeBag)
        
        pwField.rx.text.orEmpty
            .asDriver(onErrorJustReturn: "")
            .drive(viewModel.pwFieldObservable)
            .disposed(by: disposeBag)
        
        
        
        // MARK: output
        
        viewModel.idVaildObservable
            .asDriver(onErrorJustReturn: false)
            .drive(self.idValidView.rx.isHidden)
            .disposed(by: disposeBag)
        
        viewModel.pwVaildObservable
            .asDriver(onErrorJustReturn: false)
            .drive(self.pwValidView.rx.isHidden)
            .disposed(by: disposeBag)
        
        Observable.combineLatest(viewModel.idVaildObservable, viewModel.pwVaildObservable, resultSelector: {s1, s2 in s1 && s2})
            .asDriver(onErrorJustReturn: false)
            .drive(self.loginButton.rx.isEnabled)
            .disposed(by: disposeBag)
    }
    
    
    // MARK: IBOutlet
    
    @IBOutlet var idField: UITextField!
    @IBOutlet var pwField: UITextField!
    @IBOutlet var loginButton: UIButton!
    @IBOutlet var idValidView: UIView!
    @IBOutlet var pwValidView: UIView!
    
}


