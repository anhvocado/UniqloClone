//
//  ProfileVC.swift
//  UniqloApp
//
//  Created by AnhNTV3 on 26/03/2024.
//

import UIKit

class ProfileVC: UIViewController {
    weak var delegate: MainTabbarShowHideDelegate?
    @IBOutlet weak var similarItemCollectionView: UICollectionView!
    var fullItems: [UniqloProduct] = []
    var itemsMightLike: [UniqloProduct] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "PROFILE"
        self.setupCollectionView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.getListItem()
    }

    func setupCollectionView() {
        similarItemCollectionView.delegate = self
        similarItemCollectionView.dataSource = self
        similarItemCollectionView.register(UINib(nibName: "UniqloItemCell", bundle: nil), forCellWithReuseIdentifier:  "UniqloItemCell")
        self.similarItemCollectionView.reloadData()
    }
    
    @IBAction func onProfileDetail(_ sender: Any) {
        let vc = HomeVC()
        vc.title = "User Information"
        self.push(to: vc)
    }
    
    @IBAction func onOrderList(_ sender: Any) {
        let vc = OrderListVC()
        vc.title = "Orders"
        self.push(to: vc)
    }
    
    @IBAction func onWishlist(_ sender: Any) {
        let vc = ListItemVC()
        vc.title = "Wishlist"
        self.push(to: vc)
    }
    
    @IBAction func onLogout(_ sender: Any) {
        SharedData.accessToken = nil
        SharedData.userId = nil
        SharedData.password = nil
        SharedData.email = nil
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.changeRoot(LoginVC())
    }
    
    func getListItem() {
        ProductListAPI().execute(success: {[weak self] response in
            self?.fullItems = response.products
            self?.getItemYouMightLike()
        }, failure: { error in
            print(error)
        })
    }
    
    func getItemYouMightLike() {
        ProfileRecommendItemsAPI(userId: SharedData.userId ?? 0).execute(success: { [weak self] response in
            let productIDs = response.data.compactMap { $0.productId }
            let similarItems: [UniqloProduct] = productIDs.compactMap { productId in
                self?.fullItems.first(where: { $0.id == productId })
            }
            self?.itemsMightLike = similarItems
            self?.similarItemCollectionView.reloadData()
        }, failure: { error in
            print(error)
        })
    }
    
    func moveToDetail(item: UniqloProduct) {
        DetailRecommendItemsProductAPI(id: item.id ?? 0).execute(success: { [weak self] response in
            let productIDs = response.data.compactMap { $0.productId }
            let similarItems: [UniqloProduct] = productIDs.compactMap { productId in
                self?.fullItems.first(where: { $0.id == productId })
            }
            DispatchQueue.main.async {
                let vc = ItemDetailVC()
                vc.item = item
                vc.similarItems = similarItems
                vc.totalItems = self?.fullItems ?? []
                self?.push(to: vc)
            }
        }, failure: { error in
            print(error)
        })
    }
}
 
extension ProfileVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.itemsMightLike.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemHeight = collectionView.frame.height
        let itemWidth = itemHeight / 1.5
        return CGSize(width: itemWidth, height: itemHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = similarItemCollectionView.dequeueReusableCell(withReuseIdentifier: "UniqloItemCell", for: indexPath) as? UniqloItemCell else {
           return UICollectionViewCell()
        }
        cell.setupData(item: itemsMightLike[indexPath.item])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.moveToDetail(item: self.itemsMightLike[indexPath.item])
    }
}
