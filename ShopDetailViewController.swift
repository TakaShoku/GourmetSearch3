//
//  ShopDetailViewController.swift
//  GourmetSearch3
//
//  Created by 曽和寛貴 on 2017/09/13.
//  Copyright © 2017年 曽和寛貴. All rights reserved.
//

import UIKit
import MapKit

class ShopDetailViewController: UIViewController, UIScrollViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate{

    var shop = Shop()
    
    let ipc = UIImagePickerController()
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var photo: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var nameHeight: NSLayoutConstraint!
    @IBOutlet weak var tel: UILabel!
    @IBOutlet weak var address: UILabel!
    @IBOutlet weak var addressContainerHeight: NSLayoutConstraint!
    @IBOutlet weak var map: MKMapView!
    @IBOutlet weak var favoriteIcon: UIImageView!
    @IBOutlet weak var favoriteLabel: UILabel!
    
    
    @IBAction func telTapped(_ sender: UIButton) {
        print("telTapped")
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "PushMapDetail" {
            let vc = segue.destination as! ShopMapDetailViewController
            vc.shop = shop
        }
    }
   
    
    @IBAction func addressTapped(_ sender: UIButton) {
        performSegue(withIdentifier: "PushMapDetail", sender: nil)
            }
    
    @IBAction func fevoriteTapped(_ sender: UIButton) {
        
        guard let gid = shop.gid else{
            return
        }
        
        Favorite.toggle(gid)
        updateFavoriteButton()
    
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        Delegateの設定
        ipc.delegate = self
        
//        トリミングなどを行う
        ipc.allowsEditing = true
        
//        お気に入り状態をボタンラベルに反映
        updateFavoriteButton()
        
    
        if let url = shop.photoUrl {
            
            photo.sd_setImage(with: URL(string: url),
                              placeholderImage: UIImage(named: "loading"));
        } else {
            
            photo.image = UIImage(named: "loading")
        }
//        店舗名
        name.text = shop.name
//        電話番号
        tel.text = shop.tel
//        住所
        address.text = shop.address
        
        
        if let lat = shop.lat {
            
            if let lon = shop.lon {
                
                let cllc = CLLocationCoordinate2D(latitude: lat, longitude: lon)
                let mkcr = MKCoordinateRegionMakeWithDistance(cllc, 200, 200)
                map.setRegion(mkcr, animated: false)
            
            let pin = MKPointAnnotation()
            pin.coordinate = cllc
                map.addAnnotation(pin)
        }
        }
        
        updateFavoriteButton()
        }
    
    override func viewWillAppear(_ animated: Bool) {
        self.scrollView.delegate = self
        super.viewWillAppear(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.scrollView.delegate = self
        super.viewWillAppear(animated)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        self.scrollView.delegate = nil
        super.viewDidDisappear(animated)
    }
    
    
    override func viewDidLayoutSubviews() {
        let nameFrame = name.sizeThatFits(CGSize(width: name.frame.size.width, height: CGFloat.greatestFiniteMagnitude))
        nameHeight.constant = nameFrame.height
        
        let addressFrame = address.sizeThatFits(
            CGSize(width: address.frame.size.width, height: CGFloat.greatestFiniteMagnitude))
        addressContainerHeight.constant = addressFrame.height
        view.layoutIfNeeded()
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let scrollOffset = scrollView.contentOffset.y + scrollView.contentInset.top
        if scrollOffset <= 0 {
            photo.frame.origin.y = scrollOffset
            photo.frame.size.height = 200 - scrollOffset
        }
    }
    
    func updateFavoriteButton() {
        guard let gid = shop.gid else {
            return
        }
        
        if Favorite.inFavorites(gid) {
            favoriteIcon.image = UIImage(named: "star-on" )
            favoriteLabel.text = "お気に入りからはずす"
        } else {
            favoriteIcon.image = UIImage(named: "star-off")
            favoriteLabel.text = "お気に入りに入れる"
        }
        
        }
    
    @IBAction func addPhotoTapped(_ sender: UIBarButtonItem) {
        
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        
//        カメラが使えるか確認して使えるなら「写真を撮る」選択肢を標示
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            
            alert.addAction(
                UIAlertAction(title: "写真を撮る", style: .default, handler: {
                    
                    action in
                    
//                    ソースはカメラ
                    self.ipc.sourceType = .camera
                    
                    
//                    カメラUIをき起動
                    self.present(self.ipc, animated: true, completion: nil)
                })
            )
        }
        
//        「写真を選択」ボタンはいつでも使える
        alert.addAction(
            UIAlertAction(title: "写真を選択", style: .default, handler: {
                
                action in
                
//                ソースは写真選択
                self.ipc.sourceType = .photoLibrary
                
//                写真選択UIを起動
                self.present(self.ipc, animated: true, completion: nil)
            })
        )
        
        alert.addAction(
            UIAlertAction(title: "キャンセル", style: .cancel, handler: {
                
                action in
            })
        )
        
        present(alert, animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        
        
        ipc.dismiss(animated: true, completion: nil)
        
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        
        ipc.dismiss(animated: true, completion: nil)
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
