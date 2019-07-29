
//****NSMutableDictionary!!!!!

import Foundation
import YelpAPI
import CDYelpFusionKit

var restLocation1 = [NSMutableDictionary()]//[String:[NSNumber]]()
var temp_array1 = [NSNumber]()
var temp_dict1 = NSMutableDictionary() //[String: [Float]]()

public func restInRadius1(phoneNumbers: [String]) {
    
    
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
                //  print(">>>>>", json, #line, "<<<<<<<<<")
                
                var formatDict = [NSDictionary?]()
                formatDict = json["businesses"] as! [NSDictionary]
                
                if formatDict.count > 0 {
                
                    if let restName = formatDict[0]?["phone"] as? String {
                        if let restLatCordinate = formatDict[0]?["coordinates"] as? NSDictionary {
                            let restLat = restLatCordinate["latitude"] as? NSNumber
                            if let restLat = restLatCordinate["latitude"] as? NSNumber  {
                                if let restLong = restLatCordinate["longitude"] as? NSNumber  {
                                    
                                    temp_array.removeAll()
                                    temp_array.append(restLat)
                                    temp_array.append(restLong)
                                    
                                    //Dictionary here has name and lat, long
                                    temp_dict.setValue(temp_array, forKey: "\(restName)")
                                    restLocation.append(temp_dict)
                                    print("ZZZZZZZZ")
                                    print(formatDict)
                                    print(phoneNumbers[sectionIndex])
                                   print("temp_dict")
                                   print(temp_dict)
                                }
                            }
                            
                        } else {
                            print("NNNNNNN")
                        }}}

                
            } catch {
                print("caught")
            }
            }.resume()
    }
}
