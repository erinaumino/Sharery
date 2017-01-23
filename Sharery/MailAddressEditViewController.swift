//
//  MailAddressEditViewController.swift
//  Sharery
//
//  Created by 海野恵凜那 on 2017/01/16.
//  Copyright © 2017年 erina.umino. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import SVProgressHUD

class MailAddressEditViewController: UIViewController {
    @IBOutlet weak var mailaddressTextField: UITextField!
    @IBOutlet weak var newmailaddressTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBAction func editButton(_ sender: Any) {
        if let newmailAddress = newmailaddressTextField.text, let passWord = passwordTextField.text, let mailAddress = mailaddressTextField.text{
            
            // 入力されていない項目がある場合はHUDを出して何もしない
            if newmailAddress.characters.isEmpty || passWord.characters.isEmpty || mailAddress.characters.isEmpty {
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
                    user?.updateEmail(newmailAddress) { error in
                        if let error = error {
                            print("DEBUG_PRINT: " + error.localizedDescription)
                        } else {
                            print("DEBUG_PRINT: [email = \(user?.email)]の設定に成功しました。")
                            
                            // HUDで完了を知らせる
                            SVProgressHUD.showSuccess(withStatus: "メールアドレスを変更しました")
                        
                            self.navigationController?.popViewController(animated: true)                        }
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
