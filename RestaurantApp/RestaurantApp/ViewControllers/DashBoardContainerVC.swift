//
//  DashBoardContainerVC.swift
//  RestaurantApp
//
//  Created by iMac on 05/05/20.
//  Copyright © 2020 iMac. All rights reserved.
//

//
//  DashBoardContainerVC.swift
//  RestaurantApp
//
//  Created by iMac on 05/05/20.
//  Copyright © 2020 iMac. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import HMSegmentedControl
import MXPagerView
class DashBoardContainerVC: UIViewController,MXPagerViewDelegate, MXPagerViewDataSource {
 

    @IBOutlet weak var segmentControl: HMSegmentedControl!
    @IBOutlet weak var pagerView: MXPagerView!
    
    //MARK: Variables
    var arrViewControllers = [UIViewController]()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupView()
       
        // Do any additional setup after loading the view.
    }
    
    func setupView(){
          //Setup segment control properties
          segmentControl.sectionTitles = ["Map","List"]
          segmentControl.selectionStyle = .fullWidthStripe
          segmentControl.selectedSegmentIndex = 0
          segmentControl.selectionIndicatorColor = UIColor.CustomColor.btnGreenBackgroundColor
          segmentControl.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.gray, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16)]
          segmentControl.selectedTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16)]
          segmentControl.selectionIndicatorLocation = .down
          
          //Set Index Change Closure
          segmentControl.indexChangeBlock = {(index) in
              self.pagerView.showPage(at: index, animated: true)
          }
          
          //Set View controllers
          let storyboard = UIStoryboard(name: StoryBoardIdentifier.MainStoryBoard, bundle: nil)
          
          let objMapVC = storyboard.instantiateViewController(withIdentifier: ViewControllerIdentifier.MapVC) as! MapVC
          objMapVC.objDashBoardContainerVC = self
          
          let objMapLocationListVC = storyboard.instantiateViewController(withIdentifier: ViewControllerIdentifier.MapLocationListVC) as! MapLocationListVC
          objMapLocationListVC.objDashBoardContainerVC = self
          
          arrViewControllers = [objMapVC, objMapLocationListVC]
          
          //Set PagerView Delegates & DataSource
          pagerView.delegate = self
          pagerView.dataSource = self
          pagerView.reloadData()
      }
    func getLocationData(userCoordinate: CLLocationCoordinate2D?, mapCenterCoordinate: CLLocationCoordinate2D?){
        if !(Utilities.checkInternetConnection()){
            let arrPayload = SqlManager.instance.getRestaurant()
                   if arrPayload.count != 0{
                           if let objMapVC = self.arrViewControllers[0] as? MapVC{
                               objMapVC.setMapPayloadAndReload(arrPayload: arrPayload)
                           }
                           
                           if let objMapLocationListVC = self.arrViewControllers[1] as? MapLocationListVC{
                               objMapLocationListVC.setMapPayloadAndReload(arrPayload: arrPayload)
                           }
                             for objPayload in arrPayload {
                               SqlManager.instance.addRestaurant(cid: objPayload.id!, cname: objPayload.name ?? "", cphone: objPayload.phone ?? "", caddress: objPayload.address ?? "", creserve_url: objPayload.reserve_url ?? "", cimage_url: objPayload.image_url ?? "")
                               }
                       }
            return
        }
        var cityName = "chicago"
        let geoCoder = CLGeocoder()
        let location = CLLocation(latitude: userCoordinate?.latitude ?? 0, longitude:  userCoordinate?.longitude ?? 0)
        geoCoder.reverseGeocodeLocation(location, completionHandler: { (placemarks, _) -> Void in
            placemarks?.forEach { (placemark) in
                if let city = placemark.locality {
                    print(city)
                    cityName = city
                }
            }
        })

        
        Restaurants.fetchLocationData(city: cityName, page: 1, success: { (arrPayload) in
            if arrPayload?.count != 0{
                if let objMapVC = self.arrViewControllers[0] as? MapVC{
                    objMapVC.setMapPayloadAndReload(arrPayload: arrPayload!)
                }
                
                if let objMapLocationListVC = self.arrViewControllers[1] as? MapLocationListVC{
                    objMapLocationListVC.setMapPayloadAndReload(arrPayload: arrPayload!)
                }
                  for objPayload in arrPayload! {
                    SqlManager.instance.addRestaurant(cid: objPayload.id!, cname: objPayload.name ?? "", cphone: objPayload.phone ?? "", caddress: objPayload.address ?? "", creserve_url: objPayload.reserve_url ?? "", cimage_url: objPayload.image_url ?? "")
                    }
            }
        }, failure: { (error) in
        }, connectionFail: { (connectionFailed) in
        })
    }
    //MARK: MXPagerView delegate
    func numberOfPages(in pagerView: MXPagerView) -> Int {
        return self.arrViewControllers.count
    }

    func pagerView(_ pagerView: MXPagerView, viewForPageAt index: Int) -> UIView? {
        return arrViewControllers[index].view
    }

    func pagerView(_ pagerView: MXPagerView, willMoveToPage page: UIView, at index: Int) {
        self.segmentControl.setSelectedSegmentIndex(UInt(index), animated: true)
    }
}

 



