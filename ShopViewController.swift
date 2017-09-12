//
//  ViewController.swift
//  GourmetSearch3
//
//  Created by 曽和寛貴 on 2017/09/09.
//  Copyright © 2017年 曽和寛貴. All rights reserved.
//

import UIKit

class ShopViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
   
    
    var yls: YahooLocalSearch = YahooLocalSearch()
    var loadDataObserver: NSObjectProtocol?
    var refreshObserver: NSObjectProtocol?
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(ShopViewController.onRefresh(_:)),
        for: .valueChanged); self.tableView.addSubview(refreshControl)
        
        
    }
    
    func onRefresh(_ refreshControl: UIRefreshControl) {
        refreshControl.beginRefreshing ()
        refreshObserver = NotificationCenter.default.addObserver(forName: .apiLoadComplete, object: nil, queue: nil, using: {
            notification in
            NotificationCenter.default.removeObserver(self.refreshObserver!)
            refreshControl.endRefreshing()
        })
        yls.loadData(reset: true)
    }

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        var qc = QueryCondition()
//        qc.query = "ハンバーガー"
//        yls = YahooLocalSearch(condition: qc)
        
        loadDataObserver = NotificationCenter.default.addObserver(forName: .apiLoadComplete, object: nil, queue: nil, using:{ (notification) in
            
            self.tableView.reloadData()
            
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
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) ->
        CGFloat {
        return 100
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 0 {
            return yls.shops.count
        }
        
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            if indexPath.row < yls.shops.count {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "ShopItem") as!
            ShopItemTableViewCell
            cell.shop = yls.shops[indexPath.row]
            
            if yls.shops
                .count < yls.total {
                if yls.shops.count - indexPath.row <= 4 {
                    yls.loadData()
                }
                }
                return cell
        }
        }
        return UITableViewCell()
      }
   }
