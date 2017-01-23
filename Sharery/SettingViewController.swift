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
import SVProgressHUD

class SettingViewController: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate,AdobeUXImageEditorViewControllerDelegate{
    
    //let ref = FIRDatabase.database().reference() //Firebaseのルートを宣言しておく
    var ref:FIRDatabaseReference!
    
    @IBOutlet weak var profilephoto: UIImageView!
    @IBOutlet weak var mailaddressLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    
    var post: [ProfileData] = []
    var snap: FIRDataSnapshot!
    var contentArray: [FIRDataSnapshot] = [] //Fetchしたデータを入れておく配列、この配列をTableViewで表示
    var imageData = ""
    var imageString = ""

    
    @IBAction func photoeditButton(_ sender: Any) {
        // アラートを作成
        let alert = UIAlertController(
            title: "",
            message: "",
            preferredStyle: .actionSheet)
        
        // アラートにボタンをつける
        alert.addAction(UIAlertAction(title: "ライブラリ", style: .default, handler: { action in
            // ライブラリ（カメラロール）を指定してピッカーを開く
            if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.photoLibrary) {
                let pickerController = UIImagePickerController()
                pickerController.delegate = self
                pickerController.sourceType = UIImagePickerControllerSourceType.photoLibrary
                self.present(pickerController, animated: true, completion: nil)
            }
        }))
        alert.addAction(UIAlertAction(title: "写真を撮る", style: .default, handler: { action in
            // カメラを指定してピッカーを開く
            if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera) {
                let pickerController = UIImagePickerController()
                pickerController.delegate = self
                pickerController.sourceType = UIImagePickerControllerSourceType.camera
                self.present(pickerController, animated: true, completion: nil)
            }
        }))
        alert.addAction(UIAlertAction(title: "キャンセル", style: .cancel))
        
        // アラート表示
        self.present(alert, animated: true, completion: nil)
    }
    
    // 写真を撮影/選択したときに呼ばれるメソッド
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if info[UIImagePickerControllerOriginalImage] != nil {
            // 撮影/選択された画像を取得する
            let image = info[UIImagePickerControllerOriginalImage] as! UIImage
            
            // あとでAdobeUXImageEditorを起動する
            // AdobeUXImageEditorで、受け取ったimageを加工できる
            // ここでpresentViewControllerを呼び出しても表示されないためメソッドが終了してから呼ばれるようにする
            DispatchQueue.main.async {
                // AdobeImageEditorを起動する
                let adobeViewController = AdobeUXImageEditorViewController(image: image)
                adobeViewController.delegate = self
                self.present(adobeViewController, animated: true, completion:  nil)
            }
            
        }
        
        // 閉じる
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        // 閉じる
        picker.dismiss(animated: true, completion: nil)
    }
    
    // AdobeImageEditorで加工が終わったときに呼ばれるメソッド
    func photoEditor(_ editor: AdobeUXImageEditorViewController, finishedWith image: UIImage?) {
        // 画像加工画面を閉じる
        editor.dismiss(animated: true, completion: nil)
        profilephoto.image = image
    
        //投稿のためのメソッド
        create()
        
        // HUDで完了を知らせる
        SVProgressHUD.showSuccess(withStatus: "プロフィール画像を変更しました")
    }
    
    // AdobeImageEditorで加工をキャンセルしたときに呼ばれる
    func photoEditorCanceled(_ editor: AdobeUXImageEditorViewController) {
        // 加工画面を閉じる
        editor.dismiss(animated: true, completion: nil)
    }

    
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
        //データを読み込むためのメソッド
        self.read()
        
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
    
    //データの送信のメソッド
    func create() {
        //textFieldになにも書かれてない場合は、その後の処理をしない
        guard let image = profilephoto.image else { return }
        
        let imageData = UIImageJPEGRepresentation(profilephoto.image!, 0.5)
        let imageString = imageData!.base64EncodedString(options: .lineLength64Characters)
        
        //ロートからログインしているユーザーのIDをchildにしてデータを作成
        //childByAutoId()でユーザーIDの下に、IDを自動生成してその中にデータを入れる
        //setValueでデータを送信する。第一引数に送信したいデータを辞書型で入れる
        ref = FIRDatabase.database().reference()
        self.ref.child(Const.PhotoPath).child((FIRAuth.auth()?.currentUser?.uid)!).childByAutoId().setValue(["image": imageString])
    }
    
    func read()  {
        ref = FIRDatabase.database().reference()
        //FIRDataEventTypeを.Valueにすることにより、なにかしらの変化があった時に、実行
        //今回は、childでユーザーIDを指定することで、ユーザーが投稿したデータの一つ上のchildまで指定することになる
        ref.child(Const.PhotoPath).child((FIRAuth.auth()?.currentUser?.uid)!).observe(.value, with: {(snapShots) in
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
            ref = FIRDatabase.database().reference()
            ref.child(Const.PhotoPath).child((FIRAuth.auth()?.currentUser?.uid)!).keepSynced(true)
            //テーブルビューをリロード
            let item = contentArray[contentArray.count - 1].value as! Dictionary<String, AnyObject>
            let imageString = item["image"] as? String
            profilephoto.image = UIImage(data: NSData(base64Encoded: imageString!, options: .ignoreUnknownCharacters)! as Data)
        }
    }


}
