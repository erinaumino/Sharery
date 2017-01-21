//
//  DiaryEditViewController.swift
//  Sharery
//
//  Created by 海野恵凜那 on 2017/01/21.
//  Copyright © 2017年 erina.umino. All rights reserved.
//

import UIKit

class DiaryEditViewController: UIViewController {

    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var DiaryTextView: UITextView!
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var datePicker: UIDatePicker!
    
    var post:PostData? = nil
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleTextField.text = post?.title
        DiaryTextView.text = post?.diary
        photoImageView.image = post?.image
        datePicker.date = (post?.date)!
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
