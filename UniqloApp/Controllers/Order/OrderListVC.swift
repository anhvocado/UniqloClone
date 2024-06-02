//
//  OrderListVC.swift
//  UniqloApp
//
//  Created by Vanh's Mac on 02/06/2024.
//

import UIKit
import SwiftyJSON

class OrderListVC: UIViewController {
    @IBOutlet weak var orderTableView: UITableView!
    var orders: [OrderItem] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupTableView()
        self.getOrderList()
       
        // Do any additional setup after loading the view.
    }

    func getOrderList() {
        OrderListAPI().execute(success: { response in
            self.orders = response.data
            self.orderTableView.reloadData()
        }, failure: { error in
            print(error)
        })
    }

    func setupTableView() {
        orderTableView.delegate = self
        orderTableView.dataSource = self
        orderTableView.register(UINib(nibName: String(describing: OrderCell.self), bundle: nil),
                           forCellReuseIdentifier: String(describing: OrderCell.self))
    }

}

extension OrderListVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        orders.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: OrderCell.self), for: indexPath) as? OrderCell else {
            return UITableViewCell()
        }
        cell.setup(order: orders[indexPath.row])
        return cell
    }
}
