//
//  PostTableViewCell.swift
//  Sharery
//
//  Created by 海野恵凜那 on 2017/01/17.
//  Copyright © 2017年 erina.umino. All rights reserved.
//

import UIKit

class PostTableViewCell: UITableViewCell {
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var daysLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var diaryLabel: UILabel!
    @IBOutlet weak var dayLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setPostData(postData: PostData) {
        //self.postImageView.image = postData.image
        
        self.titleLabel.text = postData.title
        self.diaryLabel.text = postData.diary
        
        let formatter = DateFormatter()
        formatter.locale = NSLocale(localeIdentifier: "ja_JP") as Locale!
        formatter.dateFormat = "yyyy-MM-dd HH:mm"
        
        //let dateString:String = formatter.string(from: postData.date! as Date)
        //self.dateLabel.text = dateString
        
    }
    
}
