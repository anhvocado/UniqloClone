//
//  BottomSheetVC.swift
//  UniqloApp
//
//  Created by Am dau's Mac on 30/05/2024.
//

import UIKit

class BottomSheetVC: UIViewController {
    @IBOutlet weak var variationImage: UIImageView!
    @IBOutlet weak var variationStock: UILabel!
    @IBOutlet weak var variationPrice: UILabel!
    @IBOutlet weak var variationCollectionView: UICollectionView!
    var variations: [Variation] = []
    var selectedItem: Int = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupCollectionView()
        self.setupView()
    }

    func setupView() {
        if let url = URL(string: variations[selectedItem].image ?? "") {
            self.variationImage.sd_setImage(with: url)
        }
        self.variationStock.text = "\(variations[selectedItem].stock ?? 0)"
        self.variationPrice.text = "\(variations[selectedItem].price ?? "")$"
    }
    
    func setupCollectionView() {
        variationCollectionView.delegate = self
        variationCollectionView.dataSource = self
        variationCollectionView.register(UINib(nibName: "VariationCell", bundle: nil), forCellWithReuseIdentifier:  "VariationCell")
        self.variationCollectionView.reloadData()
    }

    @IBAction func addToCart(_ sender: UIButton) {
        let alertVC = UIAlertController(title: nil, message: "Add to cart?", preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .cancel, handler: { _ in
            //let cartItem = CartItem(item: self.item, count: 1)
            //CartManager.shared.addToCart(item: cartItem)
            AddItemToCartAPI().addItemToCartAPI(accountId: SharedData.userId ?? 0, variationId: self.variations[self.selectedItem].id ?? 0, quantity: 1)
        }))
        alertVC.modalPresentationStyle = .overFullScreen
        self.present(alertVC, animated: true)
    }


}

extension BottomSheetVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return variations.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemHeight = collectionView.frame.height
        let itemWidth = itemHeight
        return CGSize(width: itemWidth, height: itemHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = variationCollectionView.dequeueReusableCell(withReuseIdentifier: "VariationCell", for: indexPath) as? VariationCell else {
           return UICollectionViewCell()
        }
        cell.setupCell(item: variations[indexPath.item], isPicked: selectedItem == indexPath.item)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.selectedItem = indexPath.item
        self.variationCollectionView.reloadData()
        self.setupView()
    }
}
