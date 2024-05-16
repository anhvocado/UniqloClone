//
//  ListItemVC.swift
//  UniqloApp
//

import UIKit

class ListItemVC: BaseVC {
    @IBOutlet weak var itemCollectionView: UICollectionView!
    var mockItems: [UniqloItem] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        mockItems.append(UniqloItem(id: 1, name: "MacBook Air 16-inch with M2 chip", des: "It is Apple's best product", price: 1399, imageName: "13inch_macair_2"))
        mockItems.append(UniqloItem(id: 2, name: "MacBook Air 13-inch with M2 chip", des: "It is Apple's best product", price: 999, imageName: "13inch_macair_1"))
        mockItems.append(UniqloItem(id: 3, name: "MacBook Air 15-inch with M2 chip", des: "It is Apple's best product", price: 1199, imageName: "13inch_sideway"))
        mockItems.append(UniqloItem(id: 4, name: "MacBook Air 16-inch with M1 chip", des: "It is Apple's best product", price: 1399, imageName: "13inch_macair"))
        mockItems.append(UniqloItem(id: 5, name: "MacBook Air 15-inch with M1 chip", des: "It is Apple's best product", price: 1199, imageName: "person_macair"))
        mockItems.append(UniqloItem(id: 6, name: "MacBook Air 13-inch with M1 chip", des: "It is Apple's best product", price: 999, imageName: "side_way2"))
        self.setupCollectionView()
    }
    
    func setupCollectionView() {
        itemCollectionView.delegate = self
        itemCollectionView.dataSource = self
        itemCollectionView.register(UINib(nibName: "UniqloItemCell", bundle: nil), forCellWithReuseIdentifier:  "UniqloItemCell")
        self.itemCollectionView.reloadData()
    }

}

extension ListItemVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return mockItems.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemWidth = UIScreen.main.bounds.width / 2
        let itemHeight = itemWidth * 1.5
        return CGSize(width: itemWidth, height: itemHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = itemCollectionView.dequeueReusableCell(withReuseIdentifier: "UniqloItemCell", for: indexPath) as? UniqloItemCell else {
           return UICollectionViewCell()
        }
        cell.setupData(item: mockItems[indexPath.item])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = ItemDetailVC()
        let item = mockItems[indexPath.item]
        vc.item = item
        vc.similarItems = mockItems.filter({ $0.id != item.id })
        self.push(to: vc)
    }
}
