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
    }

    func setupTableView() {
        cartItemTableView.delegate = self
        cartItemTableView.dataSource = self
        cartItemTableView.register(UINib(nibName: String(describing: CheckOutItemCell.self), bundle: nil),
                           forCellReuseIdentifier: String(describing: CheckOutItemCell.self))
    }
    
    func setupView() {
        self.emptyView.isHidden = !cartItem.isEmpty
        self.dataView.isHidden = cartItem.isEmpty
        self.cartItemTableView.reloadData()
    }
    
    func getCartList(id: Int) {
        GetCartItemAPI(id: SharedData.userId ?? 0).execute(success: {[weak self] response in
            self?.cartItem = response.data
            self?.cartItemTableView.reloadData()
            self?.totalPrice.text = self?.getTotalPrice()
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
        return "\(totalPrice)" + "0$"
    }
    
    @IBAction func onCheckOut(_ sender: Any) {
        let vc = ShippingInfoVC()
        self.push(to: vc)
    }
    
    func deleteCartItem(id: Int) {
        DeleteCartItem(id: id).execute(success: {[weak self] response in
            self?.getCartList(id: SharedData.userId ?? 0)
        }, failure: { error in
            print(error)
        })
    }
    
    func updateCartItem(id: Int, quantity: Int) {
        let apiURL = URL(string: "\(APIMainEnviroment().baseUrl)/carts/update-quantity")!
        let requestBody: [String: Any] = [
            "id": id,
            "status": quantity
        ]
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: requestBody, options: [])

            var request = URLRequest(url: apiURL)
            request.httpMethod = "PUT"
            request.httpBody = jsonData
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")

            let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
                if let error = error {
                    print("Lỗi khi gọi API: \(error)")
                    return
                }

                if let data = data {
                    do {
                        let cartResponse = try JSONDecoder().decode(NoneResponse.self, from: data)
                        print("Phản hồi từ API:")
                        print("Status code: \(cartResponse.statusCode)")
                        print("Message: \(cartResponse.message)")
                        DispatchQueue.main.async {
                            self.getCartList(id: SharedData.userId ?? 0)
                        }
                    } catch {
                        print("Lỗi khi parse phản hồi từ API: \(error)")
                    }
                }
            }

            task.resume()
        } catch {
            print("Lỗi khi chuyển dữ liệu body thành JSON: \(error)")
        }
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
        cell.setupQuantityButton()
        cell.didRemoveItem = { [weak self] id in
            self?.deleteCartItem(id: id)
        }
        cell.didUpdateItem = { [weak self] item, aCell in
            guard let self = self else { return }
            if let _ = tableView.indexPath(for: aCell) {
                self.updateCartItem(id: item.id ?? 0, quantity: item.quantity ?? 0)
            }
        }
        return cell
    }
}
