//
//  PostModel.swift
//  Sharery
//
//  Created by 海野恵凜那 on 2017/01/26.
//  Copyright © 2017年 erina.umino. All rights reserved.
//

import Foundation
import Firebase

class PostModel {
    static let sharedInstance = PostModel()
    private init(){}
    dynamic var posts = [PostData]()
    
    static func create(postData:PostData) {
        let ref:FIRDatabaseReference = FIRDatabase.database().reference()
        
        ref.child(Const.PostPath).child((FIRAuth.auth()?.currentUser?.uid)!).childByAutoId().setValue(postData)
    }
    
}
