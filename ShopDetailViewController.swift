//
//  ShopDetailViewController.swift
//  GourmetSearch3
//
//  Created by 曽和寛貴 on 2017/09/13.
//  Copyright © 2017年 曽和寛貴. All rights reserved.
//

import UIKit
import MapKit

class ShopDetailViewController: UIViewController {
    
    
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
    
    
    @IBAction func tapTapped(_ sender: Any) {
        print("telTapped")
    }
    
    @IBAction func addressTapped(_ sender: Any) {
        print("address tapped")
    }
    
    @IBAction func fevoriteTapped(_ sender: Any) {
        
        print("favoritetapped")
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
