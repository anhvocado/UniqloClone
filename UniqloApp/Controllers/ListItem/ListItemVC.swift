//
//  ListItemVC.swift
//  UniqloApp
//

import UIKit

class ListItemVC: BaseVC {
    @IBOutlet weak var itemCollectionView: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
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
        return 20
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
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = ItemDetailVC()
        self.push(to: vc)
    }
}
