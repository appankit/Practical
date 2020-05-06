//
//  APIManager.swift
//  RestaurantApp
//
//  Created by iMac on 05/05/20.
//  Copyright © 2020 iMac. All rights reserved.
//

import Foundation
import SystemConfiguration
import UIKit
import Alamofire
class APIManager: NSObject {

    //Shared Instance class
    static let sharedInstance = APIManager()
    
    //MARK: Check for internet connection
    func isConnectedToNetwork() -> Bool {
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(MemoryLayout<sockaddr_in>.size)
        zeroAddress.sin_family = sa_family_t(AF_INET)
        
        guard let defaultRouteReachability = withUnsafePointer(to: &zeroAddress, {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {
                SCNetworkReachabilityCreateWithAddress(nil, $0)
            }
        }) else {
            return false
        }
        
        var flags: SCNetworkReachabilityFlags = []
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags) {
            return false
        }
        
        let isReachable = flags.contains(.reachable)
        let needsConnection = flags.contains(.connectionRequired)
        
        return (isReachable && !needsConnection)
    }
    
    //MARK: Post method with content type application/json
    func callURLStringJson(_ URLString: String, httpMethod: HTTPMethod, withRequest requestDictionary: [String: Any]?, withSuccess success: @escaping (_ responseDictionary: AnyObject) -> Void, failure: @escaping (_ error: String) -> Void, connectionFailed: @escaping (_ error: String) -> Void) {
        if(Utilities.checkInternetConnection())
        {
            let escapedURLString = URLString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
            let url = URL(string:escapedURLString ?? URLString)!
            print(url)
            
            do {
                let jsonData = try JSONSerialization.data(withJSONObject: requestDictionary ?? [:], options: JSONSerialization.WritingOptions.prettyPrinted)
                let jsonString: String = String(data: jsonData, encoding: String.Encoding.utf8)!
                print(jsonString)
                // here "jsonData" is the dictionary encoded in JSON data
            } catch let error as NSError {
                print(error)
            }
            
            Alamofire.request(url, method: httpMethod, parameters: requestDictionary ?? nil, encoding: JSONEncoding.default).responseJSON(completionHandler: { (response) in
                switch response.result {
                case .success:
//                    DispatchQueue.global(qos: .background).async {
//                        let jsonString: String = String(data: response.data!, encoding: String.Encoding.utf8)!
//                        print(jsonString)
//                    }
                    
                    //API Request Success/Failure with response code
                    if response.response?.statusCode == 200
                    {
                        success(response.result.value! as AnyObject)
                    }else{
                        let value = response.result.value as? [String:Any]
                        let msg = value?["status"] as? String
                        failure(msg ?? AppConstant.serverAPI.errorMessages.kCommanErrorMessage)
                    }
                case .failure(let error):
                    print("Request failed with error: \(error.localizedDescription)")
                    failure(error.localizedDescription)
                }
            })
        }
        else
        {
            connectionFailed(AppConstant.serverAPI.errorMessages.kNoInternetConnectionMessage)
        }
    }
}
