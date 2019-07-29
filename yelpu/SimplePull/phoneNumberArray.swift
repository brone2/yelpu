//
//  searchByPhone.swift
//  yelpu
//
//  Created by Neil Bronfin on 5/23/19.
//  Copyright © 2019 Neil Bronfin. All rights reserved.
//

import Foundation
import YelpAPI
import CDYelpFusionKit

var phoneNumbers = [String]()
var restNameRating = [String:[NSDictionary?]]()

public func fetchYelpBusinessesPhoneArray(phoneNumbers: [String]) {
    
    var restInfo = [NSDictionary?]()
   
    for sectionIndex in 0..<(phoneNumbers.count){
    
    // hello
    let apikey = "S2jB4Q-UGXJ6ovvGr3A9oAmjiSNVDsBmLWKHF7iUdcZsj1WRTxmq0Y4SaHvBjKj1mtRv6LQrjxMfI-veZukYvvBF_SRsAplkaE3wposhh4QfTy5iV5fwgk0y2x7kXHYx"
    let url = URL(string: "https://api.yelp.com/v3/businesses/search/phone?phone=\(phoneNumbers[sectionIndex])")
    var request = URLRequest(url: url!)
    request.setValue("Bearer \(apikey)", forHTTPHeaderField: "Authorization")
    request.httpMethod = "GET"
    
    URLSession.shared.dataTask(with: request) { (data, response, error) in
        if let err = error {
            print(err.localizedDescription)
        }
        do {
            let json = try JSONSerialization.jsonObject(with: data!, options: []) as! [String: Any]
            print(">>>>>", json, #line, "<<<<<<<<<")
            
            var formatDict = [NSDictionary?]()
            formatDict = json["businesses"] as! [NSDictionary]
           print(formatDict)
            
            if formatDict.count > 0 {
            if let restName = formatDict[0]?["name"] as? String {
            restNames.append(restName)
            print(restNames)
                }}
            
        } catch {
            print("caught")
        }
        }.resume()
}
}
