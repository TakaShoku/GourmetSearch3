//
//  ViewController.swift
//  GourmetSearch3
//
//  Created by 曽和寛貴 on 2017/09/09.
//  Copyright © 2017年 曽和寛貴. All rights reserved.
//

import UIKit

class ShopViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableview: UITableView!
    
    var yls: YahooLocalSearch = YahooLocalSearch()
    var loadDataObserver: NSObjectProtocol?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        var qc = QueryCondition()
        qc.query = "ハンバーガー"
        yls = YahooLocalSearch(condition: qc)
        
        loadDataObserver = NotificationCenter.default.addObserver(forName: .apiLoadComplete, object: nil, queue: nil, using:{ (notification) in
            
//            print("APIリクエスト完了")
            
            if  notification.userInfo != nil {
                if let userInfo = notification.userInfo as? [String: String] {
                    if userInfo["error"] != nil {
                        let alertView = UIAlertController(title: "通信エラー", message: "通信エラーが発生しました。", preferredStyle: .alert)
                        alertView.addAction(
                            UIAlertAction(title: "OK", style: .default) {
                            action in return
                        }
                        )
                        self.present(alertView, animated: true, completion: nil)
                    }
                }
            }
        
        }
    )
        
        
        
        yls.loadData(reset: true)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self.loadDataObserver!)
    }
    
    
    
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 100
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection: Int) -> Int {
        
        return 20
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "ShopItem") as!
            ShopItemTableViewCell
            cell.name.text = "\(indexPath.row)"
            return cell
        }
        return UITableViewCell()
      }
   }
