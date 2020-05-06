//
//  AppConstant.swift
//  RestaurantApp
//
//  Created by iMac on 05/05/20.
//  Copyright © 2020 iMac. All rights reserved.
//

import Foundation
import Foundation

class AppConstant: NSObject {
   
    //MARK: API constants
    struct serverAPI {
        struct URL {
            static let kBaseURL                  = "http://opentable.herokuapp.com/api/restaurants"
            
        }
        
        struct errorMessages {
            static let kNoInternetConnectionMessage     = "Please check your internet connection."
            static let kCommanErrorMessage              = "Something went wrong please try again later."
        }
    }
}
