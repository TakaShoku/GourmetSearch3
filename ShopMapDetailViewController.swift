//
//  ShopMapDetailViewController.swift
//  GourmetSearch3
//
//  Created by 曽和寛貴 on 2017/09/22.
//  Copyright © 2017年 曽和寛貴. All rights reserved.
//

import UIKit
import MapKit


class ShopMapDetailViewController: UIViewController {
    
    
    @IBOutlet weak var map: MKMapView!
    @IBOutlet weak var showHereButton: UIBarButtonItem!
    
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func showHereButtonTapped(_ sender: UIBarButtonItem) {
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
