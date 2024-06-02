//
//  HomeVC.swift
//  UniqloApp
//
//  Created by AnhNTV3 on 26/03/2024.
//

import UIKit

class HomeVC: BaseVC {
    @IBOutlet weak var nameLb: UILabel!
    @IBOutlet weak var emailLb: UILabel!
    @IBOutlet weak var birthdayLb: UILabel!
    @IBOutlet weak var genderLb: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.nameLb.text = SharedData.userName
        self.birthdayLb.text = SharedData.birthday
        self.genderLb.text = SharedData.gender
        self.emailLb.text = SharedData.email
        // Do any additional setup after loading the view.
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
