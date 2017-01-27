//
//  FirstViewController.swift
//  Sharery
//
//  Created by 海野恵凜那 on 2017/01/11.
//  Copyright © 2017年 erina.umino. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import SVProgressHUD
import CoreBluetooth

class DiaryViewController: UIViewController, UITableViewDataSource, UITableViewDelegate{
    var tableView: UITableView!
    @IBOutlet weak var contentView: UIView!
    var calemdarView:UIView!
    var calenderView:UICollectionView!
    
    var postArray: [PostData] = []
    // FIRDatabaseのobserveEventの登録状態を表す
    var observing = false
    
    var contentArray: [FIRDataSnapshot] = [] //Fetchしたデータを入れておく配列、この配列をTableViewで表示
    var ref:FIRDatabaseReference!
    
    var snap: FIRDataSnapshot!
    
    
    //var item: Dictionary<String, String> = [:]
    var TITLE: String = ""
    var DIARY: String = ""
    var TIME: String = ""
    //var NAME: String = ""
    var IMAGE: String = ""
    
    @IBAction func SegmentedControl(_ sender: UISegmentedControl) {
        //セグメント番号で条件分岐させる
        let views = contentView.subviews
        for view in views{
            view.removeFromSuperview()
        }
        
        switch sender.selectedSegmentIndex {
        case 1:
            
            contentView.addSubview(calemdarView)
            break
        

        default:
            contentView.addSubview(tableView)
            break
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.read()
        calemdarView = UIView()
        calemdarView.frame = contentView.bounds
        calemdarView.backgroundColor = UIColor.red
        calenderView = UICollectionView()
        
        tableView = UITableView()
        tableView.frame = contentView.bounds
        
        tableView.delegate = self
        tableView.dataSource = self
        
        // テーブルセルのタップを無効にする
        //tableView.allowsSelection = false
        
        let nib = UINib(nibName: "PostTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "Cell")
        tableView.rowHeight = UITableViewAutomaticDimension
        
        contentView.addSubview(tableView)

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("DEBUG_PRINT: viewWillAppear")
        
        if FIRAuth.auth()?.currentUser != nil {
            if self.observing == false {
                // 要素が追加されたらpostArrayに追加してTableViewを再表示する
                let postsRef = FIRDatabase.database().reference().child(Const.PostPath).child((FIRAuth.auth()?.currentUser?.uid)!)
                postsRef.observe(.childAdded, with: { snapshot in
                    print("DEBUG_PRINT: .childAddedイベントが発生しました。")
                    
                    // PostDataクラスを生成して受け取ったデータを設定する
                    if let uid = FIRAuth.auth()?.currentUser?.uid {
                        let postData = PostData(snapshot: snapshot, myId: uid)
                        self.postArray.insert(postData, at: 0)
                        
                        // TableViewを再表示する
                        self.tableView.reloadData()
                    }
                })
                // 要素が変更されたら該当のデータをpostArrayから一度削除した後に新しいデータを追加してTableViewを再表示する
                postsRef.observe(.childChanged, with: { snapshot in
                    print("DEBUG_PRINT: .childChangedイベントが発生しました。")
                    
                    if let uid = FIRAuth.auth()?.currentUser?.uid {
                        // PostDataクラスを生成して受け取ったデータを設定する
                        let postData = PostData(snapshot: snapshot, myId: uid)
                        
                        // 保持している配列からidが同じものを探す
                        var index: Int = 0
                        for post in self.postArray {
                            if post.id == postData.id {
                                index = self.postArray.index(of: post)!
                                break
                            }
                        }
                        
                        // 差し替えるため一度削除する
                        self.postArray.remove(at: index)
                        
                        // 削除したところに更新済みのでデータを追加する
                        self.postArray.insert(postData, at: index)
                        
                        // TableViewの現在表示されているセルを更新する
                        self.tableView.reloadData()
                    }
                })
                
                // FIRDatabaseのobserveEventが上記コードにより登録されたため
                // trueとする
                observing = true
            }
        } else {
            if observing == true {
                // ログアウトを検出したら、一旦テーブルをクリアしてオブザーバーを削除する。
                // テーブルをクリアする
                postArray = []
                tableView.reloadData()
                // オブザーバーを削除する
                FIRDatabase.database().reference().removeAllObservers()
                
                // FIRDatabaseのobserveEventが上記コードにより解除されたため
                // falseとする
                observing = false
            }
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // currentUserがnilならログインしていない
        if FIRAuth.auth()?.currentUser == nil{
            // ログインしていなければログインの画面を表示する
            // viewDidAppear内でpresent()を呼び出しても表示されないためメソッドが終了してから呼ばれるようにする
            DispatchQueue.main.async {
                let loginViewController = self.storyboard?.instantiateViewController(withIdentifier: "Login")
                self.present(loginViewController!, animated: true, completion: nil)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        // セルの背景色はなし
        return postArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // セルを取得してデータを設定する
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath as IndexPath) as! PostTableViewCell
        cell.setPostData(postData: postArray[indexPath.row])
        
        // セル内のボタンのアクションをソースコードで設定する
        //cell.likeButton.addTarget(self, action:#selector(handleButton(sender:event:)), for:  UIControlEvents.touchUpInside)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        // Auto Layoutを使ってセルの高さを動的に変更する
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        // 配列からタップされたインデックスのデータを取り出す
        let postData = postArray[indexPath.row]
        
        let nextViewController: DiaryEditViewController = self.storyboard?.instantiateViewController(withIdentifier: "DiaryEdit") as! DiaryEditViewController
        nextViewController.post =  postData
        self.navigationController?.pushViewController(nextViewController, animated: true)
        
        self.tableView.reloadData()
        
    }
    
    
    
    
    func read()  {
        ref = FIRDatabase.database().reference()
        //FIRDataEventTypeを.Valueにすることにより、なにかしらの変化があった時に、実行
        //今回は、childでユーザーIDを指定することで、ユーザーが投稿したデータの一つ上のchildまで指定することになる
        ref.child(Const.PostPath).child((FIRAuth.auth()?.currentUser?.uid)!).observe(.value, with: {(snapShots) in
            if snapShots.children.allObjects is [FIRDataSnapshot] {
                print("snapShots.children...\(snapShots.childrenCount)") //いくつのデータがあるかプリント
                
                print("snapShot...\(snapShots)") //読み込んだデータをプリント
                
                self.snap = snapShots
                
            }
            self.reload(snap: self.snap)
        })
    }
    
    //読み込んだデータは最初すべてのデータが一つにまとまっているので、それらを分割して、配列に入れる
    func reload(snap: FIRDataSnapshot) {
        if snap.exists() {
            print(snap)
            //FIRDataSnapshotが存在するか確認
            contentArray.removeAll()
            //1つになっているFIRDataSnapshotを分割し、配列に入れる
            for item in snap.children {
                contentArray.append(item as! FIRDataSnapshot)
            }
            // ローカルのデータベースを更新
            ref = FIRDatabase.database().reference()
            ref.child(Const.PostPath).child((FIRAuth.auth()?.currentUser?.uid)!).keepSynced(true)
            //テーブルビューをリロード
            let item = contentArray[contentArray.count - 1].value as! Dictionary<String, AnyObject>
            //            TITLE = item["title"] as! String!
            //            DIARY = item["diary"] as! String!
            //            TIME = item["time"] as! String!
            //            IMAGE = item["image"] as! String!
            //guard let IMAGE = IMAGE else { return }
            //image = UIImage(data: NSData(base64Encoded: imageString, options: .ignoreUnknownCharacters)! as Data)
            
        }
        self.Bluetooth()
    }
    
    func Bluetooth() {
        P2PConnectivity.manager.start(
            serviceType: "MIKE-SIMPLE-P2P",
            displayName: UIDevice.current.name,
            stateChangeHandler: { state in
                //                        P2PConnectivity.manager.send(message: self.TITLE)
                //                        P2PConnectivity.manager.send(message: self.DIARY)
                //                        P2PConnectivity.manager.send(message: self.TIME)
                //                        P2PConnectivity.manager.send(message: self.IMAGE)
                //P2PConnectivity.manager.send(message: self.item)
                
        }, recieveHandler: { data in
            
            //let array = data.componentsSeparatedByString(",")
            var postData = ["title": data]
            postData["diary"] = data
            postData["time"] = data
            print("AAAAAAAAAAAA\(postData)")
            //写真は一度Stringにしてデータを渡してから、受け取った先でimageに変換して辞書に保存
            
        }
        )
        
    }
    
}
