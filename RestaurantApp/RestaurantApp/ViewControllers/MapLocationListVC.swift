//
//  MapLocationListVC.swift
//  RestaurantApp
//
//  Created by iMac on 05/05/20.
//  Copyright © 2020 iMac. All rights reserved.
//

import UIKit
import SDWebImage
class MapLocationListVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    //MARK: IBOutlet
    @IBOutlet weak var tblMapLocationList: UITableView!
    //MARK: Variable
    var objDashBoardContainerVC: DashBoardContainerVC?
    var arrPayload = [Restaurants]()
    var page = 1
    //MARK: View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tblMapLocationList.tableFooterView = UIView()
        let nib = UINib(nibName: "RestaurantCell", bundle: nil)
        tblMapLocationList.register(nib, forCellReuseIdentifier: "RestaurantCell")
        // Do any additional setup after loading the view.
    }
    @objc func openDetails(sender:UIButton){
         let storyboard = UIStoryboard(name: StoryBoardIdentifier.MainStoryBoard, bundle: nil)
        let vc = storyboard.instantiateViewController(identifier: "RestaurantDetailsVC") as! RestaurantDetailsVC
        let obj = arrPayload[sender.tag]
        vc.url = obj.reserve_url
        self.present(vc, animated: true, completion: nil)
    }
    
    func loadMore(page:Int){
        Restaurants.fetchLocationData(city: "", page: page, success: { (arrPayload) in
                   if arrPayload?.count != 0{
                    self.setMapPayloadAndReload(arrPayload: arrPayload!)
                         for objPayload in arrPayload! {
                           SqlManager.instance.addRestaurant(cid: objPayload.id!, cname: objPayload.name ?? "", cphone: objPayload.phone ?? "", caddress: objPayload.address ?? "", creserve_url: objPayload.reserve_url ?? "", cimage_url: objPayload.image_url ?? "")
                           }
                   }
               }, failure: { (error) in
               }, connectionFail: { (connectionFailed) in
               })
    }
    
    //MARK: UITableView Methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrPayload.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tblMapLocationList.dequeueReusableCell(withIdentifier: "RestaurantCell", for: indexPath) as! RestaurantCell
        let obj = arrPayload[indexPath.row]
        cell.lblRestaurantName.text = obj.name
        cell.lblAddress.text = obj.address
        cell.lblNum.text = "Phone: " + obj.phone!
        if let imgBanner = obj.image_url
        {
            cell.imgBanner.sd_setImage(with: URL(string: imgBanner), completed: nil)
            cell.imgBanner.sd_setImage(with: URL(string: imgBanner), placeholderImage: UIImage(named: "imgPlaceholder.png"), options: .refreshCached, context: nil)
        }
        cell.btnClick.tag = indexPath.row
        cell.btnClick.addTarget(self, action: #selector(openDetails), for: .touchUpInside)
        if indexPath.row == arrPayload.count - 1 && arrPayload.count < total_entry  {
            page = page + 1
            loadMore(page: page )
        }
        return cell
    }
    
    //MARK: Private Methods
    func setMapPayloadAndReload(arrPayload: [Restaurants]){
        //Reload data
        self.arrPayload +=  arrPayload
        tblMapLocationList.estimatedRowHeight = 312
        tblMapLocationList.rowHeight = UITableView.automaticDimension
        tblMapLocationList.delegate = self
        tblMapLocationList.dataSource = self
        tblMapLocationList.reloadData()
        self.tblMapLocationList.reloadData()
    }
}

