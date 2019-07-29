//
//  searchByDistancePrice.swift
//  yelpu
//
//  Created by Neil Bronfin on 5/23/19.
//  Copyright © 2019 Neil Bronfin. All rights reserved.
//

import Foundation
import YelpAPI
import CDYelpFusionKit



public func fetchYelpBusinessesLatLongPriceRadius(latitude: Double, longitude: Double,price: String,radius: Int) {
    let apikey = "S2jB4Q-UGXJ6ovvGr3A9oAmjiSNVDsBmLWKHF7iUdcZsj1WRTxmq0Y4SaHvBjKj1mtRv6LQrjxMfI-veZukYvvBF_SRsAplkaE3wposhh4QfTy5iV5fwgk0y2x7kXHYx"
    let url = URL(string: "https://api.yelp.com/v3/businesses/search?latitude=\(latitude)&longitude=\(longitude)&price=\(price)&radius=\(radius)")
    var request = URLRequest(url: url!)
    request.setValue("Bearer \(apikey)", forHTTPHeaderField: "Authorization")
    request.httpMethod = "GET"
    
    URLSession.shared.dataTask(with: request) { (data, response, error) in
        if let err = error {
            print(err.localizedDescription)
        }
        do {
           let json = try JSONSerialization.jsonObject(with: data!, options: []) as! [String: Any]
           // print(">>>>>", json, #line, "<<<<<<<<<")
          print("AAA")
           // print(json["businesses"])
            
            var communityRuns = [NSDictionary?]()
            communityRuns = json["businesses"] as! [NSDictionary]
            for sectionIndex in 0..<(communityRuns.count){
                
                // Get rating values, put in array, sum up
                
                    let restName = communityRuns[sectionIndex]?["name"] as! String
                    let review_count = communityRuns[sectionIndex]?["review_count"] as! Int
                    let rating = communityRuns[sectionIndex]?["rating"] as! NSNumber
                    //print(restName + String(review_count))
                    let floatRating = Float(rating)
                
                //Find average ratings of restaurants
                    ratingsRestaurant.append(floatRating)
                    let sumArray = ratingsRestaurant.reduce(0, +)
                    let countArray = Float(ratingsRestaurant.count)
                    let avgRating = sumArray/countArray
                
                //Find weighted average ratings of restaurants
                    let weightedRating = Float(review_count) * floatRating
                    weightedRatings.append(weightedRating)
                    let weightedSumRatings = weightedRatings.reduce(0, +)
                    ratingsCount.append(Float(review_count))
                    let totalRatings = ratingsCount.reduce(0, +)
                
                    let weightedAvgRating = weightedSumRatings/totalRatings
                    print(weightedAvgRating)
            }
        } catch {
            print("caught")
        }
        }.resume()
}

struct Colour: Codable {
    let name: String
    let id: Int
    func getString() {
        print( "Name: \(name), Id: \(id)" )
    }
}
