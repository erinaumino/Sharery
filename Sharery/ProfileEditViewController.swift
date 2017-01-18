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

class ProfileEditViewController: UIViewController {

    @IBOutlet weak var profileLabel: UILabel!
    @IBOutlet weak var profileTextView: UITextView!
    
    //var postArray: [PostData] = []
    var post:ProfileData? = nil


    @IBAction func editButton(_ sender: Any) {
        if let uid = FIRAuth.auth()?.currentUser?.uid {
            //post.comment.append(uid)
            let userid = FIRAuth.auth()?.currentUser?.uid
            
            // 増えたcommentとuserをFirebaseに保存する
            let postRef = FIRDatabase.database().reference().child(Const.PostPath)//.child(post!.id!)
            //let profile_value = (post?.profile!)! + profileTextView.text!
            //let profile = ["caption": profile_value]; postRef.updateChildValues(profile)
            let postData = ["userid": userid!,"profile": profileTextView.text!]
            //postRef.updateChildValues(profile)
            postRef.childByAutoId().setValue(postData)
            
            
        }

        
        // 辞書を作成してFirebaseに保存する
        //let postRef = FIRDatabase.database().reference().child(Const.PostPath)
        //let postData = ["profile": profileTextView.text!]
        //postRef.childByAutoId().setValue(postData)

        // HUDで完了を知らせる
        SVProgressHUD.showSuccess(withStatus: "プロフィールを変更しました")

        
        let storyboard: UIStoryboard = self.storyboard!
        let nextView = storyboard.instantiateViewController(withIdentifier: "Setting") as! SettingViewController
        self.present(nextView, animated: true, completion: nil)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //プロフィールを取得してTextFieldに設定する
        let user = FIRAuth.auth()?.currentUser
        if let user = user {
            if ((post?.userid = user.uid) != nil){
            profileTextView.text = post?.profile
            }
        }

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //func setProfileData(profileData: ProfileData) {
        //self.profileTextView.text = profileData.profile
    //}
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
