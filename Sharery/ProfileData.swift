//
//  ProfileData.swift
//  Sharery
//
//  Created by 海野恵凜那 on 2017/01/18.
//  Copyright © 2017年 erina.umino. All rights reserved.
//

import Foundation
import Firebase
import FirebaseDatabase

class ProfileData: NSObject {
    var id: String?
    var image: UIImage?
    var imageString: String?

    var profile: String?

    
    init(snapshot: FIRDataSnapshot, myId: String) {
        if let user = FIRAuth.auth()?.currentUser{
            self.id = user.uid
        }
        
        let valueDictionary = user.value as! [String: AnyObject]
        
        imageString = valueDictionary["image"] as? String
        image = UIImage(data: NSData(base64Encoded: imageString!, options: .ignoreUnknownCharacters)! as Data)
        
        self.profile = valueDictionary["profile"] as? String
        
    }
}
