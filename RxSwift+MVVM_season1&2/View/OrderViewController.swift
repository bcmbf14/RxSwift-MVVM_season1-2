//
//  OrderViewController.swift
//  RxSwift+MVVM_season1&2
//
//  Created by jc.kim on 2/25/21.
//

import UIKit
import RxSwift
import RxCocoa

class OrderViewController: UIViewController {
    
    static let identifier = "OrderViewController"
    
    var orders:[Menu]?
    
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = false
        navigationController?.navigationBar.backgroundColor = .black
        
        configureNavigationBar()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.isNavigationBarHidden = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        updateUI()
        updateTextViewHeight()
    }
    
    // MARK: - UI Logic
    
    private func updateUI(){
        if let orders = self.orders {
            let target = orders.filter { $0.count > 0 }
            ordersList.text = target.map { "\($0.name) \($0.count)개\n"}.joined()
            
            let temp = target.map { $0.count * $0.price }.reduce(0,+)
            itemsPrice.text = temp.currencyKR()
            vatPrice.text = Int(Double(temp) * 0.1).currencyKR()
            totalPrice.text = (temp + Int(Double(temp) * 0.1)).currencyKR()
            
        }
    }
    
    
    private func configureNavigationBar() {
        if #available(iOS 13.0, *) {
            let navBarAppearance = UINavigationBarAppearance()
            navBarAppearance.configureWithOpaqueBackground()
            navBarAppearance.titleTextAttributes = [.foregroundColor: UIColor.white]
            navBarAppearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
            navBarAppearance.backgroundColor = .black
            navigationController?.navigationBar.standardAppearance = navBarAppearance
            navigationController?.navigationBar.scrollEdgeAppearance = navBarAppearance
        } else {
            let statusBar = UIView(frame: (UIApplication.shared.keyWindow?.windowScene?.statusBarManager?.statusBarFrame)!)
            statusBar.backgroundColor = UIColor.black
            UIApplication.shared.keyWindow?.addSubview(statusBar)
        }
    }
    
    
    private func updateTextViewHeight() {
        let text = ordersList.text ?? ""
        let width = ordersList.bounds.width
        let font = ordersList.font ?? UIFont.systemFont(ofSize: 20)
        
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = text.boundingRect(with: constraintRect,
                                            options: [.usesLineFragmentOrigin, .usesFontLeading],
                                            attributes: [NSAttributedString.Key.font: font],
                                            context: nil)
        let height = boundingBox.height
        
        ordersListHeight.constant = height + 40
    }
    
    // MARK: - Interface Builder
    
    @IBOutlet var ordersList: UITextView!
    @IBOutlet var ordersListHeight: NSLayoutConstraint!
    @IBOutlet var itemsPrice: UILabel!
    @IBOutlet var vatPrice: UILabel!
    @IBOutlet var totalPrice: UILabel!
    
    
}
