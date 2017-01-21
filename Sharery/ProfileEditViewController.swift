//
//  ProfileEditViewController.swift
//  Sharery
//
//  Created by 海野恵凜那 on 2017/01/16.
//  Copyright © 2017年 erina.umino. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import SVProgressHUD

class ProfileEditViewController: UIViewController, UITextViewDelegate {
    let ref = FIRDatabase.database().reference() //Firebaseのルートを宣言しておく

    @IBOutlet weak var profileLabel: UILabel!
    @IBOutlet weak var profileTextView: UITextView!
    
    var post: [ProfileData] = []
    //var post:ProfileData? = nil
    var snap: FIRDataSnapshot!
    var contentArray: [FIRDataSnapshot] = [] //Fetchしたデータを入れておく配列、この配列をTableViewで表示


    @IBAction func editButton(_ sender: Any) {
        //投稿のためのメソッド
        create()
        
        // HUDで完了を知らせる
        SVProgressHUD.showSuccess(withStatus: "プロフィールを変更しました")
        
        
        let storyboard: UIStoryboard = self.storyboard!
        let nextView = storyboard.instantiateViewController(withIdentifier: "Setting") as! SettingViewController
        self.navigationController?.popViewController(animated: true)

        }
    
       /*
    //Returnキーを押すと、キーボードを隠す
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

 
     
    }
 */
    
    //データの送信のメソッド
    func create() {
        //textFieldになにも書かれてない場合は、その後の処理をしない
        guard let text = profileTextView.text else { return }
        
        //ロートからログインしているユーザーのIDをchildにしてデータを作成
        //childByAutoId()でユーザーIDの下に、IDを自動生成してその中にデータを入れる
        //setValueでデータを送信する。第一引数に送信したいデータを辞書型で入れる
        //今回は記入内容と一緒にユーザーIDと時間を入れる
        //FIRServerValue.timestamp()で現在時間を取る
        self.ref.child((FIRAuth.auth()?.currentUser?.uid)!).childByAutoId().setValue(["user": (FIRAuth.auth()?.currentUser?.uid)!,"profile": text])
    }
    
    func read()  {
        //FIRDataEventTypeを.Valueにすることにより、なにかしらの変化があった時に、実行
        //今回は、childでユーザーIDを指定することで、ユーザーが投稿したデータの一つ上のchildまで指定することになる
        ref.child((FIRAuth.auth()?.currentUser?.uid)!).observe(.value, with: {(snapShots) in
            if snapShots.children.allObjects is [FIRDataSnapshot] {
                print("snapShots.children...\(snapShots.childrenCount)") //いくつのデータがあるかプリント
                
                print("snapShot...\(snapShots)") //読み込んだデータをプリント
                
                self.snap = snapShots
                
            }
            self.reload(snap: self.snap)
        })
    }
    
    //読み込んだデータは最初すべてのデータが一つにまとまっているので、それらを分割して、配列に入れる
    func reload(snap: FIRDataSnapshot) {
        if snap.exists() {
            print(snap)
            //FIRDataSnapshotが存在するか確認
            contentArray.removeAll()
            //1つになっているFIRDataSnapshotを分割し、配列に入れる
            for item in snap.children {
                contentArray.append(item as! FIRDataSnapshot)
            }
            // ローカルのデータベースを更新
            ref.child((FIRAuth.auth()?.currentUser?.uid)!).keepSynced(true)
            //テーブルビューをリロード
            let item = contentArray[contentArray.count - 1].value as! Dictionary<String, AnyObject>
            profileTextView.text = item["profile"] as! String!
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //データを読み込むためのメソッド
        self.read()
        
        profileTextView.delegate = self //デリゲートをセット
        //profileTextView.detaSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        //画面が消えたときに、Firebaseのデータ読み取りのObserverを削除しておく
        ref.removeAllObservers()
    }

}
