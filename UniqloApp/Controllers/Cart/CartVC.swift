//
//  CartVC.swift
//  UniqloApp
//
//  Created by AnhNTV3 on 26/03/2024.
//

import UIKit

class CartVC: UIViewController {
    @IBOutlet weak var cartItemTableView: UITableView!
    @IBOutlet weak var emptyView: UIView!
    @IBOutlet weak var dataView: UIView!
    @IBOutlet weak var totalPrice: UILabel!
    weak var delegate: MainTabbarShowHideDelegate?
    var cartItem: [CartItemInfo] = [] {
        didSet {
            self.setupView()
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "SHOPPING CART"
        self.setupTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getCartList(id: SharedData.userId ?? 0)
        self.totalPrice.text = getTotalPrice()
    }

    func setupTableView() {
        cartItemTableView.delegate = self
        cartItemTableView.dataSource = self
        cartItemTableView.register(UINib(nibName: String(describing: CheckOutItemCell.self), bundle: nil),
                           forCellReuseIdentifier: String(describing: CheckOutItemCell.self))
    }
    
    func setupView() {
        self.totalPrice.text = CartManager.shared.getTotalPrice()
        self.emptyView.isHidden = !cartItem.isEmpty
        self.dataView.isHidden = cartItem.isEmpty
        self.cartItemTableView.reloadData()
    }
    
    func getCartList(id: Int) {
        GetCartItemAPI(id: SharedData.userId ?? 0).execute(success: {[weak self] response in
            self?.cartItem = response.data
            self?.cartItemTableView.reloadData()
        }, failure: { error in
            print(error)
        })
    }
    
    func getTotalPrice() -> String {
        var totalPrice: Double = 0
        for item in cartItem {
            if let price = item.variation?.price, let quantity = item.quantity {
                let totalItemPrice = (Double(price) ?? 0) * Double(quantity)
                totalPrice += totalItemPrice
            }
        }
        return "\(totalPrice)" + "$"
    }
}

extension CartVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        cartItem.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: CheckOutItemCell.self), for: indexPath) as? CheckOutItemCell else {
            return UITableViewCell()
        }
        cell.setupData(cartItem: cartItem[indexPath.row])
//        cell.setupQuantityButton()
//        cell.didRemoveItem = { [weak self] id in
//            CartManager.shared.removeItem(withId: id)
//            self?.cartItem = CartManager.shared.cartData
//        }
//        cell.didUpdateItem = { [weak self] item, aCell in
//            guard let self = self else { return }
//            if let _ = tableView.indexPath(for: aCell) {
//                CartManager.shared.updateItem(item: item)
//                self.cartItem = CartManager.shared.cartData
//            }
//        }
        return cell
    }
}
