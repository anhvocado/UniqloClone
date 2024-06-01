//
//  ItemDetailVC.swift
//  UniqloApp
//

import UIKit
import SDWebImage
import IQKeyboardManagerSwift

class ItemDetailVC: BaseVC {
    @IBOutlet weak var nameItemLb: UILabel!
    @IBOutlet weak var desItemLb: UILabel!
    @IBOutlet weak var numberOfRatingLb: UILabel!
    @IBOutlet weak var ratingStackView: UIStackView!
    @IBOutlet weak var priceItemLb: UILabel!
    @IBOutlet weak var commentTextView: UITextView!
    @IBOutlet weak var itemImageCollectionView: UICollectionView!
    @IBOutlet weak var similarItemCollectionView: UICollectionView!
    @IBOutlet weak var reviewCollectionView: UICollectionView!
    var item: UniqloProduct!
    var itemImages: [String] = []
    var similarItems: [UniqloProduct] = []
    var currentRatingSelection: Int = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = ""
        self.itemImages = item.images.map({$0.path ?? ""})
        itemImages.append(item.defImg ?? "")
        self.nameItemLb.text = item.name
        self.priceItemLb.text = item.getPriceString()
        self.desItemLb.text = item.des
        self.setupReview()
        self.setupCollectionView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        IQKeyboardManager.shared.shouldResignOnTouchOutside = true
        IQKeyboardManager.shared.enable = true
    }
    
    func setupReview() {
        self.numberOfRatingLb.text = "(\(item.numberOfRating ?? 0))"
        self.updateStarImages(for: item.rating ?? "0.0")
    }

    func setupCollectionView() {
        reviewCollectionView.delegate = self
        reviewCollectionView.dataSource = self
        reviewCollectionView.register(UINib(nibName: "VariationCell", bundle: nil), forCellWithReuseIdentifier:  "VariationCell")
        self.reviewCollectionView.reloadData()
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
    
    @IBAction func submit(_ sender: UIButton) {
        let comment = self.commentTextView.text
        SendReviewAPI().sendReview(accountId: SharedData.userId ?? 0, productId: self.item.id ?? 0, star: self.currentRatingSelection, content: comment ?? "") { [weak self] error in
            if let _ = error {
                self?.handleReviewResult(failed: true)
            } else {
                self?.handleReviewResult(failed: false)
            }
        }
    }
    
    func handleReviewResult(failed: Bool) {
        var message = failed == true ? "Failed to post review!" : "Review posted!"
        let alertVC = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .cancel, handler: { _ in
            if !failed {
                ProductDetailAPI(id: self.item.id ?? 0).execute(success: { [weak self] response in
                    if let item = response.product {
                        self?.item = item
                        self?.setupReview()
                    }
                }, failure: { error in
                    print(error)
                })
            }
        }))
        alertVC.modalPresentationStyle = .overFullScreen
        DispatchQueue.main.async {
            self.present(alertVC, animated: true)
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
        } else if collectionView == reviewCollectionView {
            return 5
        } else {
            return self.similarItems.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemHeight = collectionView.frame.height
        let itemWidth = itemHeight / 1.5
        if collectionView == itemImageCollectionView {
            return CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.width)
        } else if collectionView == reviewCollectionView {
            return CGSize(width: 25, height: 25)
        } else {
            return CGSize(width: itemWidth, height: itemHeight)
        }
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
        } else if collectionView == reviewCollectionView {
            guard let cell = reviewCollectionView.dequeueReusableCell(withReuseIdentifier: "VariationCell", for: indexPath) as? VariationCell else {
               return UICollectionViewCell()
            }
            cell.setUpReview(isPicked: (indexPath.item + 1) <= self.currentRatingSelection)
            return cell
        } else {
            guard let cell = similarItemCollectionView.dequeueReusableCell(withReuseIdentifier: "UniqloItemCell", for: indexPath) as? UniqloItemCell else {
               return UICollectionViewCell()
            }
            cell.setupData(item: similarItems[indexPath.item])
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == reviewCollectionView {
            self.currentRatingSelection = indexPath.item + 1
            self.reviewCollectionView.reloadData()
        }
    }
}

