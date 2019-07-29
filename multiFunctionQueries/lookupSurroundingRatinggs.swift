//
//  lookupSurroundingRatinggs.swift
//  yelpu
//
//  Created by Neil Bronfin on 5/24/19.
//  Copyright © 2019 Neil Bronfin. All rights reserved.
//

// Identify lat/longs of restaurants in an array => for each lat/long look up ratings of rr in radius and manipulate => Compare to rr being looked up to get relative performance
//    Save in dictionary, RR as key, then the relative metrics in an array and ill need to keep track of inidexes here

import Foundation
import YelpAPI
import CDYelpFusionKit


public func surroundingRrPerformance(phoneNumbers: [String]) {

    var long_array = [NSNumber]()
    var lat_array = [NSNumber]()
    var myRatingsArray = [NSNumber]()
    var phone_array = [String]()
    var completion_help = 0
    var is_complete = false

    for sectionIndex in 0..<(phoneNumbers.count){
        completion_help += 1
        let apikey = "S2jB4Q-UGXJ6ovvGr3A9oAmjiSNVDsBmLWKHF7iUdcZsj1WRTxmq0Y4SaHvBjKj1mtRv6LQrjxMfI-veZukYvvBF_SRsAplkaE3wposhh4QfTy5iV5fwgk0y2x7kXHYx"
    //LOOKUP IS BY PHONE NUMBER ENTERED INTO ARRAY
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
                //    print(">>>>>", json, #line, "<<<<<<<<<")
                
                var formatDict = [NSDictionary?]()
                formatDict = json["businesses"] as! [NSDictionary]
                
        //Go through the restaurant of phone# looked up and save relevant info
                if formatDict.count > 0 {
                    if let restName = formatDict[0]?["phone"] as? String {
                        if let restLatCordinate = formatDict[0]?["coordinates"] as? NSDictionary {
                            if let restLat = restLatCordinate["latitude"] as? NSNumber {
                                if let restLong = restLatCordinate["longitude"] as? NSNumber {
                                    if let restRating = formatDict[0]?["rating"] as? NSNumber {
                                        //ADD RELEVANT INFO TO ARRAYS FOR LOCATION, NAME (PHONE), RATING
                                        lat_array.append(restLat)
                                        long_array.append(restLong)
                                        myRatingsArray.append(restRating)
                                        phone_array.append(restName)
                                        print(lat_array)
                                        print(long_array)
                                        print(myRatingsArray)
                                        print(phone_array)
                                    }
                                }
                            }
                        }}
                }} catch {
                    print("caught")
            }
            }.resume()
        DispatchQueue.main.asyncAfter(deadline: .now() + 4.1) {
        surroundingRrPerformance(latArray: lat_array, longArray: long_array, myRatingsArray: myRatingsArray, phoneArray: phone_array,price:"1",radius:7000,myRrNamesArray: phone_array)
        }
    }
}
