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
    var item: UniqloItem!
    var similarItems: [UniqloItem] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = ""
        self.nameItemLb.text = item.name
        self.priceItemLb.text = item.getPriceString()
        self.desItemLb.text = item.des
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
    
    @IBAction func addToCart(_ sender: UIButton) {
        //MARK: Remove later, dummy data
        let alertVC = UIAlertController(title: nil, message: "Add to cart?", preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .cancel, handler: { _ in
            let cartItem = CartItem(item: self.item, count: 1)
            CartManager.shared.addToCart(item: cartItem)
        }))
        alertVC.modalPresentationStyle = .overFullScreen
        self.present(alertVC, animated: true)
    }
}

extension ItemDetailVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == itemImageCollectionView {
            return 1
        } else {
            return self.similarItems.count
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
            cell.imageViewItem.image = UIImage(named: item.imageName)
            return cell
        } else {
            guard let cell = similarItemCollectionView.dequeueReusableCell(withReuseIdentifier: "UniqloItemCell", for: indexPath) as? UniqloItemCell else {
               return UICollectionViewCell()
            }
            cell.setupData(item: similarItems[indexPath.item])
            return cell
        }
    }
}

