//
//  idkAut.swift
//  yelpu
//
//  Created by Neil Bronfin on 5/23/19.
//  Copyright © 2019 Neil Bronfin. All rights reserved.
//

import UIKit
import YelpAPI
import CDYelpFusionKit


final class CDYelpFusionKitManager: NSObject {
    
    static let shared = CDYelpFusionKitManager()
    
    var apiClient: CDYelpAPIClient!
    
    func configure() {
        // How to authorize using your clientId and clientSecret
        self.apiClient = CDYelpAPIClient(apiKey: "YOUR_API_KEY")
    }
}



// SEARCH BY LAT/LONG
public func fetchYelpBusinessesLatLong(latitude: Double, longitude: Double) {
    let apikey = "S2jB4Q-UGXJ6ovvGr3A9oAmjiSNVDsBmLWKHF7iUdcZsj1WRTxmq0Y4SaHvBjKj1mtRv6LQrjxMfI-veZukYvvBF_SRsAplkaE3wposhh4QfTy5iV5fwgk0y2x7kXHYx"
    let url = URL(string: "https://api.yelp.com/v3/businesses/search?latitude=\(latitude)&longitude=\(longitude)")
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
        } catch {
            print("caught")
        }
        }.resume()
}


