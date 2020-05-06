//
//  Utilities.swift
//  RestaurantApp
//
//  Created by iMac on 05/05/20.
//  Copyright © 2020 iMac. All rights reserved.
//

import UIKit

class Utilities: NSObject {
   
    //MARK: Check internet connection
    static func checkInternetConnection() -> Bool
    {
        if(APIManager.sharedInstance.isConnectedToNetwork())
        {
            return true
        }else{
            return false
        }
    }
    
    
}


func topViewController(base: UIViewController? = (UIApplication.shared.delegate as! AppDelegate).window?.rootViewController) -> UIViewController? {
    
    if let nav = base as? UINavigationController {
        return topViewController(base: nav.visibleViewController)
    }
    
    if let tab = base as? UITabBarController {
        
        if let selected = tab.selectedViewController {
            return topViewController(base: selected)
        }
    }
    if let presented = base?.presentedViewController {
        return topViewController(base: presented)
    }
    return base
}
