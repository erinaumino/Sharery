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
        
        guard let date = postData.date else { return }
        
        let formatter = DateFormatter()
        formatter.dateFormat = "dd"
        let day = formatter.string(from: date)
        self.dateLabel.text = day
        formatter.dateFormat = "HH:mm"
        let time = formatter.string(from: date)
        self.timeLabel.text = time
        
        formatter.dateFormat = "yyyy"
        let year = formatter.string(from: date)
        formatter.dateFormat = "MM"
        let months = formatter.string(from: date)
        
        let month: Array  = [nil, "January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"]
        self.dayLabel.text = year + "." + month[Int(months)!]!
        
        formatter.dateFormat = "E"
        let days = formatter.string(from: date)
        self.daysLabel.text = days

        
        //let dateString:String = formatter.string(from: postData.date! as Date)
        //self.dateLabel.text = dateString
        
    }
    
}
