//
//  RestaurantDetailsVC.swift
//  RestaurantApp
//
//  Created by iMac on 05/05/20.
//  Copyright © 2020 iMac. All rights reserved.
//

import UIKit
import WebKit

class RestaurantDetailsVC: UIViewController {

    @IBOutlet weak var webView: WKWebView!
    var url: String?
    override func viewDidLoad() {
        super.viewDidLoad()
        webView.load(NSURLRequest(url: NSURL(string: url!)! as URL) as URLRequest)

        // Do any additional setup after loading the view.
    }
    
    @IBAction func btnCloseClick(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
