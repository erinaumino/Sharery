//
//  PassWordEditViewController.swift
//  Sharery
//
//  Created by 海野恵凜那 on 2017/01/16.
//  Copyright © 2017年 erina.umino. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import SVProgressHUD

class PassWordEditViewController: UIViewController {
    @IBOutlet weak var mailaddressTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var newpasswordTextField: UITextField!
    
    @IBAction func editButton(_ sender: Any) {
        if let mailAddress = mailaddressTextField.text, let passWord = passwordTextField.text, let newpassWord = newpasswordTextField.text{
            
            // 入力されていない項目がある場合はHUDを出して何もしない
            if mailAddress.characters.isEmpty || passWord.characters.isEmpty || newpassWord.characters.isEmpty {
                SVProgressHUD.showError(withStatus: "何かが空文字です")
                return
            }
            
            // 認証してメールアドレスを変更する
            FIRAuth.auth()?.signIn(withEmail: mailAddress, password: passWord) { user, error in
                if let error = error {
                    print("DEBUG_PRINT: " + error.localizedDescription)
                    SVProgressHUD.showError(withStatus: "サインインに失敗しました。")
                    return
                } else {
                    print("DEBUG_PRINT: ログインに成功しました。")
                    user?.updatePassword(newpassWord) { error in
                        if let error = error {
                            print("DEBUG_PRINT: " + error.localizedDescription)
                        } else {
                            print("DEBUG_PRINT: passwordの設定に成功しました。")
                            
                            // HUDで完了を知らせる
                            SVProgressHUD.showSuccess(withStatus: "パスワードを変更しました")
                            
                            let storyboard: UIStoryboard = self.storyboard!
                            let nextView = storyboard.instantiateViewController(withIdentifier: "Setting") as! SettingViewController
                            self.navigationController?.popViewController(animated: true)
//                            self.present(nextView, animated: true, completion: nil)
                        }
                    }
                }
            }
        }
        // キーボードを閉じる
        self.view.endEditing(true)

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
