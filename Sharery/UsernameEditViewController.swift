//
//  UsernameEditViewController.swift
//  Sharery
//
//  Created by 海野恵凜那 on 2017/01/16.
//  Copyright © 2017年 erina.umino. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import SVProgressHUD

class UsernameEditViewController: UIViewController {
    @IBOutlet weak var newusernameTextField: UITextField!

    @IBAction func editButton(_ sender: Any) {
        if let displayName = newusernameTextField.text {
            
            // 表示名が入力されていない時はHUDを出して何もしない
            if displayName.characters.isEmpty {
                SVProgressHUD.showError(withStatus: "表示名を入力して下さい")
                return
            }
            
            // 表示名を設定する
            let user = FIRAuth.auth()?.currentUser
            if let user = user {
                let changeRequest = user.profileChangeRequest()
                changeRequest.displayName = displayName
                changeRequest.commitChanges { error in
                    if let error = error {
                        print("DEBUG_PRINT: " + error.localizedDescription)
                    }
                    print("DEBUG_PRINT: [displayName = \(user.displayName)]の設定に成功しました。")
                    
                    // HUDで完了を知らせる
                    SVProgressHUD.showSuccess(withStatus: "表示名を変更しました")
                    
                    self.navigationController?.popViewController(animated: true)

                }
            } else {
                print("DEBUG_PRINT: displayNameの設定に失敗しました。")
            }
        }
        // キーボードを閉じる
        self.view.endEditing(true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // 表示名を取得してTextFieldに設定する
        let user = FIRAuth.auth()?.currentUser
        if let user = user {
            newusernameTextField.text = user.displayName
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
