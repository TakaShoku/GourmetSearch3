//
//  LocationService.swift
//  GourmetSearch3
//
//  Created by 曽和寛貴 on 2017/09/23.
//  Copyright © 2017年 曽和寛貴. All rights reserved.
//

import Foundation
import CoreLocation

public extension Notification.Name {
//    位置情報使用拒否
    public static let authDenied = Notification.Name("AuthDenied")
//    位置情報使用制限
    public static let authRestricted = Notification.Name("AuthRestricted")
//    位置情報使用可能
    public static let authorized = Notification.Name("Authorized")
//    位置情報取得完了
    public static let didUpdateLocation = Notification.Name("DidUpdateLocation")
//    位置情報取得失敗
    public static let didFailLocation = Notification.Name("DidFailLocation")
    
}

public class LocationService: NSObject, CLLocationManagerDelegate {
    
    private let cllm = CLLocationManager()
    private let nc = NotificationCenter.default
    
    //位置情報がONになっていないダアイアログ
    public var locationServiceDisabledAlert: UIAlertController {
        get {
            
            let alert = UIAlertController(title: "位置情報が取得できません。",
                                          message: "位置情報画面を開いてGurmetSearchの位置情報の強化を「このAppの使用中のみ許可と設定してくだい",
                                          preferredStyle: .alert)
            
            alert.addAction(
                UIAlertAction(title: "閉じる", style: .cancel, handler: nil)
            )
            return alert
        }
}
//    位置情報が制限されているダイアログ
    public var locationServiceRestrictedAlert: UIAlertController {
        get {
            
            let alert = UIAlertController(title: "位置情報が取得できません。",
                                          message: "設定から一般→機能制限画面を開いてGourmetSearchが位置情報を使用できるようにしてください",
                                          preferredStyle: .alert)
            
            alert.addAction(
                UIAlertAction(title: "閉じる", style: .cancel, handler: nil)
            )
            return alert
        }
    }
//位置情報の取得に失敗したダイアログ
    public var locationServiceDidFailAlert: UIAlertController {
        get {
            
            let alertView = UIAlertController(title: nil,
                                          message: "位置情報の取得に失敗しました。",
                                          preferredStyle: .alert)
            
            alertView.addAction(
                UIAlertAction(title: "OK", style: .default, handler: nil)
            )
            return alertView
        }
    }

//    イニシャライザ
    public override init() {
        super.init()
        cllm.delegate = self
    }
    
    
//    位置情報の使用許可状態が変化した時に実行される
    public func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        
        
        switch status {
            
        case .notDetermined:
//            まだ意思表示を示していない
            cllm.requestWhenInUseAuthorization()
            
        case .restricted:
//            制限している
            nc.post(name: .authRestricted, object: nil)
            
        case .denied:
//            禁止している
            nc.post(name: .authDenied, object: nil)
        
        case .authorizedWhenInUse:
//            利用可能
            break;
        default:
//            それ以外
            break;
        }
    }
    
//    位置情報を取得した時に実行される
    public func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
//        位置情報の取得を停止
        cllm.stopUpdatingLocation()
//        locationは配列なので最後の一つを使用する
        if let location = locations.last {
//            位置情報を乗せてNotificationを送信する
            nc.post(name: .didUpdateLocation,
                    object: self,
                    userInfo: ["location": location])
        }
        
    }
//    位置情報の取得に失敗したときに実行される
    public func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        
//        失敗Notificationを送信する
        nc.post(name: .didFailLocation, object: nil)
    }
    
//    位置情報の取得を開始する
    public func startUpdatingLocation(){
        
        cllm.startUpdatingLocation()
    }
    
    
}
