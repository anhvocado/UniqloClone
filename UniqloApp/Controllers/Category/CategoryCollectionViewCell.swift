//
//  CategoryCollectionViewCell.swift
//  UniqloApp
//
//  Created by ThinhND3 on 02/04/2024.
//

import UIKit

class CategoryCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var tableView: UITableView!
    var didSelectCategory: ((String) -> Void)?
        var categoryItem: [Brand] = []
        override func awakeFromNib() {
            super.awakeFromNib()
            tableView.delegate = self
            tableView.dataSource = self
            tableView.register(UINib(nibName: String(describing: CategoryCell.self), bundle: nil),
                               forCellReuseIdentifier: String(describing: CategoryCell.self))
        }
    
    func setupData(brands: [Brand]) {
            self.categoryItem = brands
            self.tableView.reloadData()
        }
    }

    extension CategoryCollectionViewCell: UITableViewDelegate, UITableViewDataSource {
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: CategoryCell.self), for: indexPath) as? CategoryCell else {
                return UITableViewCell()
            }
            cell.tagLb.text = categoryItem[indexPath.row].name
            return cell
        }
        
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return categoryItem.count
        }
        
        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            self.didSelectCategory?(String(describing:categoryItem[indexPath.row]))
        }
        
        func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
            return 70
        }
    }
