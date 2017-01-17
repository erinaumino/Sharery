//
//  PostData.swift
//  Sharery
//
//  Created by 海野恵凜那 on 2017/01/17.
//  Copyright © 2017年 erina.umino. All rights reserved.
//

import Foundation
import Firebase
import FirebaseDatabase

class PostData: NSObject {
    var id: String?
    //var image: UIImage?
    //var imageString: String?
    var name: String?
    var title: String?
    var diary: String?
    //var date: NSDate?
    
    init(snapshot: FIRDataSnapshot, myId: String) {
        self.id = snapshot.key
        
        let valueDictionary = snapshot.value as! [String: AnyObject]
        
        //imageString = valueDictionary["image"] as? String
        //image = UIImage(data: NSData(base64Encoded: imageString!, options: .ignoreUnknownCharacters)! as Data)
        
        self.name = valueDictionary["name"] as? String
        
        self.title = valueDictionary["title"] as? String
        
        self.diary = valueDictionary["diary"] as? String
        
        //let date = valueDictionary["time"] as? String
        //self.date = NSDate(timeIntervalSinceReferenceDate: TimeInterval(time!)!)
        
    }
}
