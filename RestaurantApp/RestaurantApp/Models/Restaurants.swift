/* 
Copyright (c) 2020 Swift Models Generated from JSON powered by http://www.json4swift.com

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
*/

import Foundation
 import SVProgressHUD
/* For support, please feel free to contact me at https://www.linkedin.com/in/syedabsar */
var total_entry: Int = 0
public class Restaurants {
	public var id : Int?
	public var name : String?
	public var address : String?
	public var city : String?
	public var state : String?
	public var area : String?
	public var postal_code : String?
	public var country : String?
	public var phone : String?
	public var lat : Double?
	public var lng : Double?
	public var price : Int?
	public var reserve_url : String?
	public var mobile_reserve_url : String?
	public var image_url : String?

/**
    Returns an array of models based on given dictionary.
    
    Sample usage:
    let restaurants_list = Restaurants.modelsFromDictionaryArray(someDictionaryArrayFromJSON)

    - parameter array:  NSArray from JSON dictionary.

    - returns: Array of Restaurants Instances.
*/
    public class func modelsFromDictionaryArray(array: [[String: Any]]) -> [Restaurants]
    {
        var models:[Restaurants] = []
        for item in array
        {
            models.append(Restaurants(dictionary: item as! NSDictionary)!)
        }
        return models
    }
    init(id: Int, name: String, phone: String, address: String,reserve_url: String, image_url: String) {
           self.id = id
           self.name = name
           self.phone = phone
           self.address = address
        self.reserve_url = reserve_url
        self.image_url = image_url
       }

/**
    Constructs the object based on the given dictionary.
    
    Sample usage:
    let restaurants = Restaurants(someDictionaryFromJSON)

    - parameter dictionary:  NSDictionary from JSON.

    - returns: Restaurants Instance.
*/
	required public init?(dictionary: NSDictionary) {

		id = dictionary["id"] as? Int
		name = dictionary["name"] as? String
		address = dictionary["address"] as? String
		city = dictionary["city"] as? String
		state = dictionary["state"] as? String
		area = dictionary["area"] as? String
		postal_code = dictionary["postal_code"] as? String
		country = dictionary["country"] as? String
		phone = dictionary["phone"] as? String
		lat = dictionary["lat"] as? Double
		lng = dictionary["lng"] as? Double
		price = dictionary["price"] as? Int
		reserve_url = dictionary["reserve_url"] as? String
		mobile_reserve_url = dictionary["mobile_reserve_url"] as? String
		image_url = dictionary["image_url"] as? String
	}

		
/**
    Returns the dictionary representation for the current instance.
    
    - returns: NSDictionary.
*/
	public func dictionaryRepresentation() -> NSDictionary {

		let dictionary = NSMutableDictionary()

		dictionary.setValue(self.id, forKey: "id")
		dictionary.setValue(self.name, forKey: "name")
		dictionary.setValue(self.address, forKey: "address")
		dictionary.setValue(self.city, forKey: "city")
		dictionary.setValue(self.state, forKey: "state")
		dictionary.setValue(self.area, forKey: "area")
		dictionary.setValue(self.postal_code, forKey: "postal_code")
		dictionary.setValue(self.country, forKey: "country")
		dictionary.setValue(self.phone, forKey: "phone")
		dictionary.setValue(self.lat, forKey: "lat")
		dictionary.setValue(self.lng, forKey: "lng")
		dictionary.setValue(self.price, forKey: "price")
		dictionary.setValue(self.reserve_url, forKey: "reserve_url")
		dictionary.setValue(self.mobile_reserve_url, forKey: "mobile_reserve_url")
		dictionary.setValue(self.image_url, forKey: "image_url")

		return dictionary
	}
    
    //MARK: API Call
       class func fetchLocationData(city: String, page: Int, success withResponse: @escaping (_ arrPayload: [Restaurants]?) -> (), failure: @escaping (_ error: String) -> Void, connectionFail: @escaping (_ error: String) -> Void){
           SVProgressHUD.show()
        let str = "?city=chicago&per_page=50&page=\(page)"
           
           let requestURL = String(format: AppConstant.serverAPI.URL.kBaseURL + str)
           
           APIManager.sharedInstance.callURLStringJson(requestURL, httpMethod: .get, withRequest: nil, withSuccess: { (response) in
               if let res = response as? [String:Any] {
                if let totalEntry = res["total_entries"] as? Int{
                    total_entry = totalEntry
                }
                       if let arrPayloadData = res["restaurants"] as? [[String:Any]], arrPayloadData.count > 0 {
                        let arrPayload = Restaurants.modelsFromDictionaryArray(array: arrPayloadData)
                           withResponse(arrPayload)
                        
                       }else{
                           withResponse(nil)
                       }
                      
               }
               SVProgressHUD.dismiss()
           }, failure: { (error) in
               SVProgressHUD.dismiss()
               failure(error)
           }, connectionFailed: { (connectionFailed) in
               SVProgressHUD.dismiss()
               connectionFail(connectionFailed)
           })
       }

}
