//
//  SecondViewController.swift
//  Sharery
//
//  Created by 海野恵凜那 on 2017/01/11.
//  Copyright © 2017年 erina.umino. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import SVProgressHUD

class WriteDiaryViewController: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate,AdobeUXImageEditorViewControllerDelegate {
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var diaryTextview: UITextView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var datepicker: UIDatePicker!
    
    @IBAction func editButton(_ sender: Any) {
        // ImageViewから画像を取得する
        let imageData = UIImageJPEGRepresentation(imageView.image!, 0.5)
        let imageString = imageData!.base64EncodedString(options: .lineLength64Characters)
        
        // postDataに必要な情報を取得しておく
        let time = datepicker.date

        //let time = NSDate.timeIntervalSinceReferenceDate
        let name = FIRAuth.auth()?.currentUser?.displayName
        
        // 辞書を作成してFirebaseに保存する
        let postRef = FIRDatabase.database().reference().child(Const.PostPath)
        let postData = ["title": titleTextField.text!, "diary": diaryTextview.text!, "image": imageString, "time": String(describing: time), "name": name!] as [String : Any]
        postRef.childByAutoId().setValue(postData)
        
        // HUDで投稿完了を表示する
        SVProgressHUD.showSuccess(withStatus: "投稿しました")
        
        // 全てのモーダルを閉じる
        //UIApplication.shared.keyWindow?.rootViewController?.dismiss(animated: true, completion: nil)
        let storyboard: UIStoryboard = self.storyboard!
        let nextView = storyboard.instantiateViewController(withIdentifier: "Diary") as! DiaryViewController
        self.present(nextView, animated: true, completion: nil)

    }
    
    @IBAction func camera(_ sender: Any) {
        // アラートを作成
        let alert = UIAlertController(
            title: "写真を選択",
            message: "ライブラリまたは写真を撮るから選択",
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
        
        // 投稿の画面を開く
        //let postViewController = self.storyboard?.instantiateViewController(withIdentifier: "Post") as! PostViewController
        //postViewController.image = image
        //present(postViewController, animated: true, completion: nil)
        // 受け取った画像をImageViewに設定する
        imageView.image = image
    }
    
    // AdobeImageEditorで加工をキャンセルしたときに呼ばれる
    func photoEditorCanceled(_ editor: AdobeUXImageEditorViewController) {
        // 加工画面を閉じる
        editor.dismiss(animated: true, completion: nil)
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

