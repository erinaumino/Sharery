//
//  CalendarViewController.swift
//  Sharery
//
//  Created by 海野恵凜那 on 2017/01/21.
//  Copyright © 2017年 erina.umino. All rights reserved.
//

import UIKit

class CalendarViewController: UIViewController {

    @IBOutlet weak var headerNextBtn: UIBarButtonItem!
    @IBOutlet weak var headerPrevBtn: UIBarButtonItem!
    @IBOutlet weak var calenderCollectionView: UICollectionView!
  
    @IBAction func PrevBtn(_ sender: Any) {
    }
    @IBAction func NextBtn(_ sender: Any) {
    }
    
    var textLabel: UILabel!
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        
//        // UILabelを生成
//        textLabel = UILabel(frame: CGRectMake(0, 0, self.frame.width, self.frame.height))
//        textLabel.font = UIFont(name: "HiraKakuProN-W3", size: 12)
//        textLabel.textAlignment = NSTextAlignment.center
//        // Cellに追加
//        self.addSubview(textLabel!)
//    }
//    
//    override init(frame: CGRect) {
//        super.init(coder: frame)
//        
    }


    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
