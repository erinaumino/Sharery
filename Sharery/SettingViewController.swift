//
//  SettingViewController.swift
//  Sharery
//
//  Created by 海野恵凜那 on 2017/01/11.
//  Copyright © 2017年 erina.umino. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class SettingViewController: UIViewController {
    @IBOutlet weak var profilephoto: UIImageView!
    @IBOutlet weak var mailaddressLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    
    @IBAction func logoutButton(_ sender: Any) {
        // ログアウトする
        try! FIRAuth.auth()?.signOut()
        
        // ログイン画面を表示する
        let loginViewController = self.storyboard?.instantiateViewController(withIdentifier: "Login")
        self.present(loginViewController!, animated: true, completion: nil)
        
        // ログイン画面から戻ってきた時のためにホーム画面（index = 0）を選択している状態にしておく
        let storyboard: UIStoryboard = self.storyboard!
        let nextView = storyboard.instantiateViewController(withIdentifier: "Diary") as! DiaryViewController
        self.present(nextView, animated: true, completion: nil)

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // 表示名を取得してTextFieldに設定する
        let user = FIRAuth.auth()?.currentUser
        if let user = user {
            mailaddressLabel.text = user.email
            usernameLabel.text = user.displayName
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
