//
//  BaseVC.swift
//  UniqloApp
//
//  Created by AnhNTV3 on 08/04/2024.
//

import UIKit

class BaseVC: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        let newBackButton = UIBarButtonItem(image: UIImage(named: "ic_back"),
                                            style: .plain,
                                            target: self,
                                            action: #selector(backButtonTapped))
        newBackButton.tintColor = .black
        newBackButton.imageInsets = UIEdgeInsets(top: 0,
                                                 left: -12,
                                                 bottom: 0,
                                                 right: 12)
        self.navigationItem.leftBarButtonItem = newBackButton
    }
    
    @objc func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
}
