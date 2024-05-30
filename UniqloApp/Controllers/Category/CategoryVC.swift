//
//  CategoryVC.swift
//  UniqloApp
//
//  Created by ThinhND3 on 02/04/2024.
//

import UIKit

class CategoryVC: UIViewController {
    @IBOutlet var sectionButton: [UIButton]!
    @IBOutlet var sectionDividerView: [UIView]!
    @IBOutlet weak var categoryCollectionView: UICollectionView!
    weak var delegate: MainTabbarShowHideDelegate?
       weak var owner: MainVC?
       var sections: [CategoryInfo] = []
       var currentTag: Int = 0 {
           didSet {
               self.configSectionUI()
           }
       }
       override func viewDidLoad() {
           super.viewDidLoad()
           setupCollectionView()
           self.getCategoriesAndBrands()
       }
       
       func getCategoriesAndBrands() {
           CategoryListAPI().execute(success: { response in
               self.sections = response.data
               self.categoryCollectionView.reloadData()
           }, failure: { error in
               print(error)
           })
       }
       
       override func viewWillAppear(_ animated: Bool) {
           super.viewWillAppear(animated)
           self.navigationController?.isNavigationBarHidden = true
       }
       
       override func viewWillDisappear(_ animated: Bool) {
           super.viewWillDisappear(animated)
           self.navigationController?.isNavigationBarHidden = false
       }
       
       func setupCollectionView() {
           categoryCollectionView.delegate = self
           categoryCollectionView.dataSource = self
           categoryCollectionView.register(UINib(nibName: "CategoryCollectionViewCell", bundle: nil), forCellWithReuseIdentifier:  "CategoryCollectionViewCell")
           self.categoryCollectionView.reloadData()
       }
       
       func configSectionUI() {
           sectionButton.forEach { [weak self] button in
               if button.tag == self?.currentTag {
                   button.setTitleColor(.black, for: .normal)
               } else {
                   button.setTitleColor(.lightGray, for: .normal)
               }
           }
           sectionDividerView.forEach { [weak self] view in
               view.isHidden = view.tag != self?.currentTag
           }
       }
       
       @IBAction func onTapSection(_ sender: UIButton) {
           self.categoryCollectionView.scrollToItem(at: IndexPath(item: sender.tag, section: 0), at: .left, animated: true)
           self.currentTag = sender.tag
       }
   }

   extension CategoryVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
       func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
           return 4
       }
       
       func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
           return CGSize(width: UIScreen.main.bounds.width, height: collectionView.frame.height)
       }
       
       func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
           guard let cell = categoryCollectionView.dequeueReusableCell(withReuseIdentifier: "CategoryCollectionViewCell", for: indexPath) as? CategoryCollectionViewCell else {
              return UICollectionViewCell()
           }
//           cell.categoryItem = self.sections.first?.brands ?? []
           cell.setupData(brands: self.sections.first?.brands ?? [])
           cell.didSelectCategory = { [weak self] cat in
               let vc = ListItemVC()
               vc.title = cat.name
               vc.brandId = cat.id
               self?.push(to: vc)
           }
           return cell
       }
       
       public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
           let pageIndex = Int(scrollView.contentOffset.x) / Int(scrollView.frame.width)
           self.currentTag = pageIndex
       }
   }
