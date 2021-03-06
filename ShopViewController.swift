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
        
        if !(self.navigationController is FavoriteNavigationController) {
            
            self.navigationItem.rightBarButtonItem = nil
            
        }
        
        
    }
    
    func onRefresh(_ refreshControl: UIRefreshControl) {
        refreshControl.beginRefreshing ()
        refreshObserver = NotificationCenter.default.addObserver(forName: .apiLoadComplete, object: nil, queue: nil, using: {
            notification in
            NotificationCenter.default.removeObserver(self.refreshObserver!)
            refreshControl.endRefreshing()
        })
        
        if self.navigationController is FavoriteNavigationController {
            
            loadFavorites()
            
        } else {
            
            
        yls.loadData(reset: true)
            
        }
    }

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        loadDataObserver = NotificationCenter.default.addObserver(forName: .apiLoadComplete, object: nil, queue: nil, using:{ (notification) in
            
            
            
            if self.yls.condition.gid != nil {
                
                self.yls.sortByGid()
            }
            
            self.tableView.reloadData()
            
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
        
        if yls.shops.count == 0{
            if self.navigationController is FavoriteNavigationController {
                
                loadFavorites()
                
                self.navigationItem.title = "お気に入り"
            } else {
                
                yls.loadData(reset: true)
                
                self.navigationItem.title = "店舗一覧"
            }
        
        yls.loadData(reset: true)
    }
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        performSegue(withIdentifier: "PushShopDetail", sender: indexPath)
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue .identifier == "PushShopDetail" {
            let vc = segue .destination as! ShopDetailViewController
            if let indexPath = sender as? IndexPath {
                vc.shop = yls.shops[indexPath.row]
            }
        }
    }
    
    func loadFavorites() {
        
        Favorite.load()
        
        if Favorite.favorites.count > 0 {
            
            var condition = QueryCondition()
            
            condition.gid = Favorite.favorites.joined(separator: ",")
            
            yls.condition = condition
            yls.loadData(reset: true)
        } else {
            
            NotificationCenter.default.post(name: .apiLoadComplete, object: nil)
        }
    }
    
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        
        return self.navigationController is FavoriteNavigationController
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            
            guard let gid = yls.shops[indexPath.row].gid else {
                return
            }
            
            Favorite.remove(gid)
            yls.shops.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
      }
    
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        
        return self.navigationController is FavoriteNavigationController
        
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        
        if sourceIndexPath == destinationIndexPath {return}
    
    let source = yls.shops[sourceIndexPath.row]
    yls.shops.remove(at: sourceIndexPath.row)
    yls.shops.insert(source, at: destinationIndexPath.row)
    
    Favorite.move(sourceIndexPath.row, to: destinationIndexPath.row)
    
    }
    
    @IBAction func editButtonTapped(_ sender: UIBarButtonItem) {
        
        if tableView.isEditing {
            
            tableView.setEditing(false, animated: true)
            sender.title = "編集"
        } else {
            
            tableView.setEditing(true, animated: true)
            sender.title = "完了"
        }
    }
    
    }
