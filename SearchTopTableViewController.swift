//
//  SearchTopTableViewController.swift
//  GourmetSearch3
//
//  Created by 曽和寛貴 on 2017/09/12.
//  Copyright © 2017年 曽和寛貴. All rights reserved.
//

import UIKit
import CoreLocation

class SearchTopTableViewController: UITableViewController, UITextFieldDelegate, UIGestureRecognizerDelegate{
    
    
    var freeword: UITextField? = nil
    
    
//    LOcationServiceの利用設定
    let ls = LocationService()
    let nc = NotificationCenter.default
    var observers = [NSObjectProtocol]()
    var here: (lat: Double, lon: Double)? = nil

    override func viewDidLoad() {
        super.viewDidLoad()
        
        

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 44
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        
        switch section {
        case 0:
            return 2
        default:
            return 0
        }
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            
            switch indexPath.row {
                
            case 0:
        let cell = tableView.dequeueReusableCell(withIdentifier: "Freeword") as! FreewordTableViewCell

        freeword = cell.freeword
            
        cell.freeword.delegate = self
        cell.selectionStyle = .none

        return cell
                
            case 1:
                let cell = UITableViewCell()
                cell.textLabel?.text = "現在地から検索"
                cell.accessoryType = .disclosureIndicator
                
                return cell
            default:
                return UITableViewCell()
    }
    }
        return UITableViewCell()
        
        
    }
        
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        performSegue(withIdentifier: "PushShopList", sender: self)
        
        return true
    }
    
    @IBAction func onTap(_ sender: UITapGestureRecognizer) {
        freeword?.resignFirstResponder()
    }
    
    
    
       func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        
        if let ifr = freeword?.isFirstResponder {
            
            return ifr
        }
        
        return false
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        //        位置情報の取得を禁止している場合
        observers.append(
            nc.addObserver(forName: .authDenied, object: nil, queue: nil, using: {
                notification in
                
                //                位置情報がonになっていないダイアログ表示
                self.present(self.ls.locationServiceDisabledAlert,
                             animated: true,
                             completion: nil)
                //                現在地を表示を非アクティブにする
            })
        )
        
        //        位置情報取得を制限している場合
        observers.append(
            nc.addObserver(forName: .authRestricted, object: nil, queue: nil, using: {
                notification in
                
                //                位置情報が制限されているダアイログ表示
                self.present(self.ls.locationServiceRestrictedAlert,
                             animated: true,
                             completion: nil)
                
                       })
        )
        
        
        //        位置情報取得に失敗した場合
        observers.append(
            nc.addObserver(forName: .didFailLocation, object: nil, queue: nil, using: {
                notification in
                
                //                位置情報取得に失敗したダイアログ
                self.present(self.ls.locationServiceDidFailAlert,
                             animated: true,
                             completion: nil)
                
            })
        )
        
        //        位置情報を取得した場合
        observers.append(
            nc.addObserver(forName: .didUpdateLocation, object: nil, queue: nil, using: {
                notification in
                
                //                位置情報が渡されていなければ早期離脱
                guard let userInfo = notification.userInfo as? [String: CLLocation] else {
                    return
                }
                
                //                userInfoがキーlocationを持っていなければ早期離脱
                guard let clloc = userInfo["location"] else {
                    return
                }
               
                self.here = (
                
                    lat: clloc.coordinate.latitude,
                    lon: clloc.coordinate.longitude
                )
                
                self.performSegue(withIdentifier: "PushShopListFromHere", sender: self)
            })
        )
    }
    
    
    //    Notificationの待受けを解除する
    override func viewWillDisappear(_ animated: Bool) {
        
        for observer in observers {
            
            nc.removeObserver(observer)
        }
        
        observers = []
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.section == 0 && indexPath.row == 1 {
            
            ls.startUpdatingLocation()
            tableView.deselectRow(at: indexPath, animated: true)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "PushShopList" {
            let vc = segue.destination as! ShopViewController
            vc.yls.condition.query = freeword?.text
        }
        
        if segue.identifier == "PushShopListFromHere" {
            
            let vc = segue.destination as! ShopViewController
            vc.yls.condition.lat = self.here?.lat
            vc.yls.condition.lon = self.here?.lon
        }
    }
    


    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
