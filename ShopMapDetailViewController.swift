//
//  ShopMapDetailViewController.swift
//  GourmetSearch3
//
//  Created by 曽和寛貴 on 2017/09/23.
//  Copyright © 2017年 曽和寛貴. All rights reserved.
//

import UIKit
import MapKit


class ShopMapDetailViewController: UIViewController {

    @IBOutlet weak var map: MKMapView!
    @IBOutlet weak var showHereButton: UIBarButtonItem!
    
    
    
    
    let ls = LocationService()
    let nc = NotificationCenter.default
    var observers = [NSObjectProtocol]()
    var shop: Shop = Shop()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

//        店舗所在地を地図に反映
        if let lat = shop.lat {
            if let lon = shop.lon{
                
//                地図の表示範囲を指定
                let cllc = CLLocationCoordinate2D(latitude: lat, longitude: lon)
                _ = MKCoordinateRegionMakeWithDistance(cllc, 500, 500)
                
//                ピンを設定
                let pin = MKPointAnnotation()
                pin.coordinate = cllc
                pin.title = shop.name
                map.addAnnotation(pin)
            }
        }
        self.navigationItem.title = shop.name
        
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        
        observers.append(
            nc.addObserver(forName: .authDenied, object: nil, queue: nil, using: {
                notification in
                
                
                self.present(self.ls.locationServiceDisabledAlert,
                             animated: true,
                             completion: nil)
                
                self.showHereButton.isEnabled = false
            })
        )
        
        
        observers.append(
            nc.addObserver(forName: .authRestricted, object: nil, queue: nil, using: {
                notification in
                
                
                self.present(self.ls.locationServiceRestrictedAlert,
                             animated: true,
                             completion: nil)
                
                self.showHereButton.isEnabled = false
            })
        )

        
        
        observers.append(
            nc.addObserver(forName: .didFailLocation, object: nil, queue: nil, using: {
                notification in
                
                
                self.present(self.ls.locationServiceDidFailAlert,
                             animated: true,
                             completion: nil)
                
                self.showHereButton.isEnabled = false
            })
        )
        
        
        observers.append(
            nc.addObserver(forName: .didUpdateLocation, object: nil, queue: nil, using: {
                notification in
                
                self.showHereButton.isEnabled = false
                
                
                guard let userInfo = notification.userInfo as? [String: CLLocation] else {
                    return
                }
                
                guard let clloc = userInfo["location"] else {
                    return
                }
                
                guard let lat = self.shop.lon else {
                    return
                }
                
                guard let lon  = self.shop.lon else {
                    return
                }
                
                
                let center = CLLocationCoordinate2D(
                    latitude: (lat + clloc.coordinate.latitude) / 2,
                    longitude: (lon + clloc.coordinate.longitude) / 2)
                
                let diff = (
                    lat: abs(clloc.coordinate.latitude - lat),
                    lon: abs(clloc.coordinate.longitude - lon))
                
                let mkcs = MKCoordinateSpanMake(diff.lat * 1.4, diff.lon * 1.4)
                let mkcr = MKCoordinateRegionMake(center, mkcs)
                self.map.setRegion(mkcr, animated: true)
            
            })
        )
        
        observers.append(
            nc.addObserver(forName: .authorized, object: nil, queue: nil, using: {
                notification in
                
                self.showHereButton.isEnabled = true
            })
        )
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        for observer in observers {
            
            nc.removeObserver(observer)
        }
        
        observers = []
    }
    
    @IBAction func showHereButtonTapped(_ sender: UIBarButtonItem) {

        ls.startUpdatingLocation()
    }
    
}
