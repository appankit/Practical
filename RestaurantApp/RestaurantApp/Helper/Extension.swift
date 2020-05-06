//
//  Extension.swift
//  RestaurantApp
//
//  Created by iMac on 05/05/20.
//  Copyright © 2020 iMac. All rights reserved.
//

import Foundation
import UIKit
extension UIColor {
    //Custom color list used in app
    struct CustomColor {
        static let btnGreenBackgroundColor = UIColor.green
    }
}


extension UIApplication {
    
   
    //Status Bar View
    var statusBarView: UIView? {
        return value(forKey: "statusBar") as? UIView
    }
    
    //Find top most view controller
    class func topViewController(base: UIViewController? = (UIApplication.shared.delegate as! AppDelegate).window?.rootViewController) -> UIViewController? {
        
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
    
    //check application state
    class func isApplicationInForeground() -> Bool {
        let state: UIApplication.State = UIApplication.shared.applicationState
        let result: Bool = (state == .active)
        return result
    }
    
    class func isApplicationInBackground() -> Bool {
        let state: UIApplication.State = UIApplication.shared.applicationState
        let result: Bool = (state == .inactive)
        return result
    }
}
