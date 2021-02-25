//
//  ViewController.swift
//  RxSwift+MVVM_season1&2
//
//  Created by jc.kim on 2/25/21.
//

import UIKit
import RxSwift
import RxCocoa

class MenuViewController: UIViewController {
    
    let viewModel = MenuListViewModel()
    var disposeBag = DisposeBag()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.menuObservable
            .observe(on: MainScheduler.instance)
            .bind(to: tableView.rx.items(cellIdentifier: MenuItemTableViewCell.reuseIdentifier, cellType: MenuItemTableViewCell.self)) { index, item, cell in
                
                cell.title.text = item.name
                cell.price.text = "\(item.price)"
                cell.count.text = "\(item.count)"
                
                cell.onChange = { [weak self] change in
                    self?.viewModel.changeCount(item: item, change: change)
                }
            }
            .disposed(by: disposeBag)
        
        viewModel.itemCount
            .map { "\($0)" }
            .asDriver(onErrorJustReturn: "")
            .drive(itemCountLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.totalPrice
            .map{ $0.currencyKR() }
            .asDriver(onErrorJustReturn: "")
            .drive(totalPrice.rx.text)
            .disposed(by: disposeBag)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let orderVC = segue.destination as? OrderViewController {
            _ = viewModel.menuObservable
                .take(1)
                .subscribe(onNext: { menus in
                    orderVC.orders = menus
                })
        }
    }
    //
    //    func showAlert(_ title: String, _ message: String) {
    //        let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
    //        alertVC.addAction(UIAlertAction(title: "OK", style: .default))
    //        present(alertVC, animated: true, completion: nil)
    //    }
    
    // MARK: - InterfaceBuilder Links
    
    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    @IBOutlet var tableView: UITableView!
    @IBOutlet var itemCountLabel: UILabel!
    @IBOutlet var totalPrice: UILabel!
    
    @IBAction func onClear() {
        viewModel.clearAllItemSelections()
    }
    
    
}
