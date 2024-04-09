//
//  ItemDetailVC.swift
//  UniqloApp
//

import UIKit

class ItemDetailVC: BaseVC {
    @IBOutlet weak var nameItemLb: UILabel!
    @IBOutlet weak var desItemLb: UILabel!
    @IBOutlet weak var priceItemLb: UILabel!
    @IBOutlet weak var itemImageCollectionView: UICollectionView!
    @IBOutlet weak var similarItemCollectionView: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = ""
        self.setupCollectionView()
    }

    func setupCollectionView() {
        itemImageCollectionView.delegate = self
        itemImageCollectionView.dataSource = self
        itemImageCollectionView.register(UINib(nibName: "ItemImageCell", bundle: nil), forCellWithReuseIdentifier:  "ItemImageCell")
        self.itemImageCollectionView.reloadData()
        similarItemCollectionView.delegate = self
        similarItemCollectionView.dataSource = self
        similarItemCollectionView.register(UINib(nibName: "UniqloItemCell", bundle: nil), forCellWithReuseIdentifier:  "UniqloItemCell")
        self.similarItemCollectionView.reloadData()
    }
}

extension ItemDetailVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == itemImageCollectionView {
            return 3
        } else {
            return 10
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemHeight = collectionView.frame.height
        let itemWidth = itemHeight / 1.5
        if collectionView == itemImageCollectionView {
            return CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.width)
        }
        return CGSize(width: itemWidth, height: itemHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == itemImageCollectionView {
            guard let cell = itemImageCollectionView.dequeueReusableCell(withReuseIdentifier: "ItemImageCell", for: indexPath) as? ItemImageCell else {
               return UICollectionViewCell()
            }
            return cell
        } else {
            guard let cell = similarItemCollectionView.dequeueReusableCell(withReuseIdentifier: "UniqloItemCell", for: indexPath) as? UniqloItemCell else {
               return UICollectionViewCell()
            }
            return cell
        }
    }
}

