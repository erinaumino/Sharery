//
//  DiaryEditViewController.swift
//  Sharery
//
//  Created by 海野恵凜那 on 2017/01/21.
//  Copyright © 2017年 erina.umino. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import SVProgressHUD

class DiaryEditViewController: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate,AdobeUXImageEditorViewControllerDelegate {


    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var DiaryTextView: UITextView!
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var datePicker: UIDatePicker!
    
    var post:PostData? = nil
   
    
    //var selectedSnap: FIRDataSnapshot! //ListViewControllerからのデータの受け取りのための変数
    
    //let ref = FIRDatabase.database().reference() //FirebaseDatabaseのルートを指定
    
    @IBAction func cameraButton(_ sender: Any) {
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
        //imageView.image = image
        
        //        imageData = UIImageJPEGRepresentation(imageView.image!, 0.5)
        //        imageString = imageData!.base64EncodedString(options: .lineLength64Characters)
        
    }
    
    // AdobeImageEditorで加工をキャンセルしたときに呼ばれる
    func photoEditorCanceled(_ editor: AdobeUXImageEditorViewController) {
        // 加工画面を閉じる
        editor.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func editButton(_ sender: Any) {
        let postRef = FIRDatabase.database().reference().child(Const.PostPath).child(post!.id!)

        let postData = ["title": titleTextField.text!, "diary": DiaryTextView.text!] as [String : Any]
        postRef.updateChildValues(postData)
        
        // HUDで完了を知らせる
        SVProgressHUD.showSuccess(withStatus: "日記を編集しました")
    
        self.navigationController?.popViewController(animated: true)

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleTextField.text = post?.title
        DiaryTextView.text = post?.diary
        datePicker.date = (post?.date)!
        guard let image = post?.image else { return }
           photoImageView.image = post?.image
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
