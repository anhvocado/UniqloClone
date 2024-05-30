//
//  ItemDetailVC.swift
//  UniqloApp
//

import UIKit
import SDWebImage

class ItemDetailVC: BaseVC {
    @IBOutlet weak var nameItemLb: UILabel!
    @IBOutlet weak var desItemLb: UILabel!
    @IBOutlet weak var numberOfRatingLb: UILabel!
    @IBOutlet weak var ratingStackView: UIStackView!
    @IBOutlet weak var priceItemLb: UILabel!
    @IBOutlet weak var itemImageCollectionView: UICollectionView!
    @IBOutlet weak var similarItemCollectionView: UICollectionView!
    var item: UniqloProduct!
    var itemImages: [String] = []
    var similarItems: [UniqloProduct] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = ""
        self.itemImages = item.images.map({$0.path ?? ""})
        itemImages.append(item.defImg ?? "")
        self.nameItemLb.text = item.name
        self.priceItemLb.text = item.getPriceString()
        self.desItemLb.text = item.des
        self.numberOfRatingLb.text = "(\(item.numberOfRating ?? 0)"
        self.updateStarImages(for: item.rating ?? "0.0")
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
    
    func updateStarImages(for ratingString: String) {
        // Ensure the stack view is empty before adding new images
        self.ratingStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        
        // Convert the rating string to a float
        guard let rating = Float(ratingString) else {
            return
        }
        
        // Determine the number of filled and empty stars
        let fullStarCount = Int(rating)
        let halfStar = (rating - Float(fullStarCount)) >= 0.5
        let emptyStarCount = 5 - fullStarCount - (halfStar ? 1 : 0)
        
        // Add filled star images
        for _ in 0..<fullStarCount {
            let filledStarImageView = UIImageView(image: UIImage(systemName: "star.fill"))
            filledStarImageView.tintColor = .systemYellow
            ratingStackView.addArrangedSubview(filledStarImageView)
        }
        
        // Add a half star image if needed
        if halfStar {
            let halfStarImageView = UIImageView(image: UIImage(systemName: "star.lefthalf.fill"))
            halfStarImageView.tintColor = .systemYellow
            ratingStackView.addArrangedSubview(halfStarImageView)
        }
        
        // Add empty star images
        for _ in 0..<emptyStarCount {
            let emptyStarImageView = UIImageView(image: UIImage(systemName: "star"))
            emptyStarImageView.tintColor = .lightGray
            ratingStackView.addArrangedSubview(emptyStarImageView)
        }
    }
    
    @IBAction func addToCart(_ sender: UIButton) {
        let vc = BottomSheetVC()
        vc.variations = item.variations
        self.present(vc, animated: true)
    }
}

extension ItemDetailVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == itemImageCollectionView {
            return itemImages.count
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
            if let url = URL(string: self.itemImages[indexPath.item]) {
                cell.imageViewItem.sd_setImage(with: url)
            }
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

