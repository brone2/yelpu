//
//  yelpDataPull.swift
//  yelpu
//
//  Created by Neil Bronfin on 5/29/19.
//  Copyright © 2019 Neil Bronfin. All rights reserved.
//
//PROBLEMS
// 1) YOU CAN ONLY RETURN 20 RESTAURANTS
//NEED TO LEARN COMPLETION HANDLING!!!
// Lates is it looks lik eall RR are being pulled but the array count is odly the same (19), it appears to happen ater the loop, and idkk``
// TODO, add restaurant rating

import Foundation
import YelpAPI
import CDYelpFusionKit

func formatPhoneNumbers(rawPhoneNumbers: [String]) {
    
    var completion_help = 0
    var myRrPhoneNumberArray = [String]()
    
    for sectionIndex in 0..<(rawPhoneNumbers.count){
        
        //helper to know when to call next function
        completion_help += 1
        if let formattedPhoneNumberString = formatPhoneNumber(sourcePhoneNumber: rawPhoneNumbers[sectionIndex]) {
        myRrPhoneNumberArray.append(formattedPhoneNumberString)
            
        if completion_help == rawPhoneNumbers.count {
               v1q1MyRrCoordinatesAndPerformance(phoneNumbers: myRrPhoneNumberArray)
        }
    }
    }
}

//For all my Restaurants, pull coordinates and ratings. Save in arrays that are aligned by array index
// 1Function ************************************************************************************************************************************************
func v1q1MyRrCoordinatesAndPerformance(phoneNumbers: [String]) {
    print("HHHH:")
    var myRrLatArray = [NSNumber]()
    var myRrReviewCount = [Int]()
    var myRrLongArray = [NSNumber]()
    var myRrRatingsArray = [NSNumber]()
    var myRrPhoneNumberArray = [String]()
    var myRrAddressArray = [Any]()
    var myRrStateArray = [String]()
    var myRrCityArray = [String]()
    var myRrZipArray = [String]()
    var completion_help = 0
    
      for sectionIndex in 0..<(phoneNumbers.count){
        
        //helper to know when to call next function
        completion_help += 1
        print(completion_help)
        print(phoneNumbers.count)
        print(myRrPhoneNumberArray.count)
        
        //Call data, look is by phone numbre
        let apikey = "S2jB4Q-UGXJ6ovvGr3A9oAmjiSNVDsBmLWKHF7iUdcZsj1WRTxmq0Y4SaHvBjKj1mtRv6LQrjxMfI-veZukYvvBF_SRsAplkaE3wposhh4QfTy5iV5fwgk0y2x7kXHYx"
        let url = URL(string: "https://api.yelp.com/v3/businesses/search/phone?phone=\(phoneNumbers[sectionIndex])") //Phone number lookup
        print(phoneNumbers[sectionIndex])
        var request = URLRequest(url: url!)
        request.setValue("Bearer \(apikey)", forHTTPHeaderField: "Authorization")
        request.httpMethod = "GET"
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let err = error {
                print(err.localizedDescription)
            }
            do {
                let json = try JSONSerialization.jsonObject(with: data!, options: []) as! [String: Any]
         //       print(">>>>>", json, #line, "<<<<<<<<<")
                var formatDict = [NSDictionary?]()
                
                if json["businesses"] != nil {
                formatDict = json["businesses"] as! [NSDictionary]
                
             
          
                //Go through the restaurant of phone# looked up and save relevant info
                if formatDict.count > 0 {
                    if let restPhoneNumber = formatDict[0]?["phone"] as? String {
                        if let restLatCordinate = formatDict[0]?["coordinates"] as? NSDictionary {
                            if let restLat = restLatCordinate["latitude"] as? NSNumber {
                                if let restLong = restLatCordinate["longitude"] as? NSNumber {
                                    if let restRating = formatDict[0]?["rating"] as? NSNumber {
                                        if let restReviewCount = formatDict[0]?["review_count"] as? Int {
                                          if let restFullLocationInfo = formatDict[0]?["location"] as? NSDictionary {
                                            if let tempAddress = restFullLocationInfo["display_address"] as? Any {
                                               if let tempState = restFullLocationInfo["state"] as? String {
                                                if let tempCity = restFullLocationInfo["city"] as? String {
                                                    if let tempZip = restFullLocationInfo["zip_code"] as? String {
                                                
                                                    //ADD RELEVANT INFO TO ARRAYS FOR MY RR LOCATION, NAME, RATING, ADDRESS
                                                    myRrLatArray.append(restLat)
                                                    myRrLongArray.append(restLong)
                                                    myRrRatingsArray.append(restRating)
                                                    myRrPhoneNumberArray.append(restPhoneNumber)
                                                    myRrReviewCount.append(restReviewCount)
                                                    myRrAddressArray.append(tempAddress)
                                                    myRrCityArray.append(tempCity)
                                                    myRrStateArray.append(tempState)
                                                    myRrZipArray.append(tempZip)
                                                //TODO
                                                    //If on last loop of loop, call next function                                   // PROBLEM: IF THERE IS AN ERROR ON  LAST LOOP WON'T BE CALLED ******!!!!!******
                                                        print(myRrAddressArray)
                                                        print(myRrPhoneNumberArray.count)
                                            //TODO  Price should be a variable
                                                            if completion_help == phoneNumbers.count {
                                                                v1q2surroundingRrPerformance(myRrPhoneNumberArray: myRrPhoneNumberArray, myRrLatArray: myRrLatArray, myRrLongArray: myRrLongArray, myRrRatingsArray: myRrRatingsArray, price: "1",radius: 1000,myRrReviewCount:myRrReviewCount,myRrAddressArray:myRrAddressArray,myRrCityArray:myRrCityArray,myRrStateArray: myRrStateArray,myRrZipArray:myRrZipArray)}
                                                }
                                                } }}}
                                    }
                                }
                            }
                            }
                        }}
                    }        }} catch {
                    print("caught")
            }
            }.resume()
        

    }
}

// 2Function ************************************************************************************************************************************************
//Lookup surrrounding RR performance and Calculate for restaurants in radius and price range. Relationship between myRR and values for other is through index
// 1) surroundingRrCount: Array which lists count of RR surrounding each off my RR
// 2) surroundingRrRatingWeightedAvgArray: Array which lists weighted average of RR surrounding my RR
// 3) surroundingRrRatingNonWeightedAvgArray: Array which lists non-weighted average of RR surrounding my RR
func v1q2surroundingRrPerformance(myRrPhoneNumberArray: [String],myRrLatArray:[NSNumber],myRrLongArray:[NSNumber],myRrRatingsArray:[NSNumber],price: String,radius: Int,myRrReviewCount:[Int],myRrAddressArray:[Any],myRrCityArray: [String],myRrStateArray: [String],myRrZipArray: [String]) {
 print("AAAA:")
//These two variables used to inicatee when all of my RR have been accounted for to go to next function
    var completion_help_outter_loop = 0
    var outterLoopFinalLoop = myRrPhoneNumberArray.count
    
    var tempSurroundingRrRating  = [Float]()
    var tempSurroundingRrReviewCount = [Int]() //This is used for an individual rr surrounding rr count
    var tempSurroundingRrWeigtedRatingScore = [Float]() //Rating*Number of reviewss
    
    var totalSurroundingRrReviewCount = [Int]() //This is total reviews surrounding restaurants
//Surrounding RR info
    var surroundingRrRatingWeightedAvgArray = [Float]()
    var surroundingRrRatingNonWeightedAvgArray = [Float]()
    var surroundingRrCount = [Int]()
 
//sectionIndexLoop is loopingg by myRestaurant using myLat and myLong
    for sectionIndex in 0..<(myRrPhoneNumberArray.count){
     
        var completion_help_inner_loop = 0
        
        let apikey = "S2jB4Q-UGXJ6ovvGr3A9oAmjiSNVDsBmLWKHF7iUdcZsj1WRTxmq0Y4SaHvBjKj1mtRv6LQrjxMfI-veZukYvvBF_SRsAplkaE3wposhh4QfTy5iV5fwgk0y2x7kXHYx"
        
        //LOOKUP RESTAURANTS IN RADIUS OF THE LAT AND LONG VALUES RETRIEVED FROM INITIAL LOOP USING PHONE#
        let url = URL(string: "https://api.yelp.com/v3/businesses/search?latitude=\(myRrLatArray[sectionIndex])&longitude=\(myRrLongArray[sectionIndex])&price=\(price)&radius=\(radius)")
        usleep(1000000)
        var request = URLRequest(url: url!)
        request.setValue("Bearer \(apikey)", forHTTPHeaderField: "Authorization")
        request.httpMethod = "GET"
        usleep(1000000)
        
        URLSession.shared.dataTask(with: request, completionHandler:{ (data, response, error) -> Void in
          DispatchQueue.main.async {

            if let err = error {
                print(err.localizedDescription)
            }
            do {
                let json = try JSONSerialization.jsonObject(with: data!, options: []) as! [String: Any]
                var surroundingRrDict = [NSDictionary?]()
                surroundingRrDict = json["businesses"] as! [NSDictionary]
        //restIndex is looping through surrounding restaurants as specified by the lat and long pulled by section index
        //problem here is the fact you only get 20 restaurants per pull
                for restIndex in 0..<(surroundingRrDict.count){
                    completion_help_inner_loop += 1

           // Get rating values, put in array, sum up
                    let review_count = surroundingRrDict[restIndex]?["review_count"] as! Int
                    let rating = surroundingRrDict[restIndex]?["rating"] as! NSNumber
                    let floatRating = Float(rating)
                    let weightedRating = Float(review_count) * floatRating
                    // Store individual RR values surrounding myRR in temp arrays
                    tempSurroundingRrRating.append(Float(rating))
                    tempSurroundingRrReviewCount.append(review_count)
                    tempSurroundingRrWeigtedRatingScore.append(weightedRating)
                    
                    
           //After storing values of last rr in loop, sum up results and store in aggregated loops
                    if completion_help_inner_loop == surroundingRrDict.count {
                  
                        //Calculate aggregate values
                        let sumRawRatingsArray = tempSurroundingRrRating.reduce(0, +)
                        let weightedSumRatings = tempSurroundingRrWeigtedRatingScore.reduce(0, +)
                        let totalRatings = tempSurroundingRrReviewCount.reduce(0, +)
                        let countRrNearby = Float(tempSurroundingRrRating.count)
                         //Calculated Weighted avergae
                                let nonWeightedAvgRating = sumRawRatingsArray/countRrNearby
                                let weightedAvgRating = weightedSumRatings/Float(totalRatings)
                        
                        //Store aggregated values in arrays
                        surroundingRrCount.append(Int(countRrNearby))
                        surroundingRrRatingWeightedAvgArray.append(weightedAvgRating)
                        surroundingRrRatingNonWeightedAvgArray.append(nonWeightedAvgRating)
                        
                        totalSurroundingRrReviewCount.append(totalRatings)
                        
                        //Clear temporary arrays
                        tempSurroundingRrRating.removeAll()
                        tempSurroundingRrReviewCount.removeAll()
                        tempSurroundingRrWeigtedRatingScore.removeAll()
                        
                        completion_help_outter_loop += 1
                        
                        if completion_help_outter_loop == outterLoopFinalLoop {
                            v1q2myResults(myRrPhoneNumberArray: myRrPhoneNumberArray, myRrRatingsArray: myRrRatingsArray, surroundingRrCount: surroundingRrCount, surroundingRrRatingWeightedAvgArray: surroundingRrRatingWeightedAvgArray, surroundingRrRatingNonWeightedAvgArray: surroundingRrRatingNonWeightedAvgArray,myRrReviewCount:myRrReviewCount,myRrAddressArray:myRrAddressArray,myRrCityArray:myRrCityArray,myRrStateArray: myRrStateArray,myRrZipArray:myRrZipArray,
                                          totalSurroundingRrReviewCount:totalSurroundingRrReviewCount)
                        }
                    }
                }} catch {
                    print("caught")
            }}
            }).resume()
    }
}


// 3Function ************************************************************************************************************************************************
// For each of my restaurants, have arrayy of calculatedd performance relative to those in its surrounding compared to weighted and waited
// Aggregate the arrrays to get 1) Weighted average yelp rating 2) average delta vs non weighted 3) avg delta vs weighted
// Preferably have dictionary to look up by restaurant
func  v1q2myResults(myRrPhoneNumberArray: [String],myRrRatingsArray:[NSNumber],surroundingRrCount:[Int],surroundingRrRatingWeightedAvgArray:[Float],surroundingRrRatingNonWeightedAvgArray:[Float],myRrReviewCount:[Int],myRrAddressArray:[Any],myRrCityArray: [String],myRrStateArray: [String],myRrZipArray: [String],totalSurroundingRrReviewCount:[Int]) {

    var myRrNameDict = NSMutableDictionary() //At some point need to  find way to pull street address from phone number
    var myRrReviewCountDict = NSMutableDictionary()
    var myRrSurroundingRrCountDict = NSMutableDictionary()
    var myRrRatingsDict = NSMutableDictionary()
    var myRrRatingDeltaToNonWeightedAvgRatingDict = NSMutableDictionary()
    var myRrRatingDeltaToWeightedAvgRatingDict = NSMutableDictionary()
    var myRrAddressDict = NSMutableDictionary()
    var myRrFullAddress:String?
    
    var csv_helper_count = 0
    var mailString = NSMutableString()
    mailString.append("Rest#,City, State, Zip Code, Full Address, RR Rating,RR Rating Count, RR in Radius, RR in radius Avg rating (Weighted),totalSurroundingRrReviewCount,RR in radius Avg rating (Not  Weighted)\n")
    
 //Loop to go through each  array. All arrays MUST BE THE SAME LENGTH OR YOU HAVE A SERIOUS PROBLEM!!!!!!!!!!
    for sectionIndex in 0..<(myRrPhoneNumberArray.count) {
        
        csv_helper_count += 1
        
    //Store values in variables
        var myPhoneNumber = myRrPhoneNumberArray[sectionIndex]
        var myRating = myRrRatingsArray[sectionIndex]
        var myReviewCount = myRrReviewCount[sectionIndex]
        var surroundingRrCountValue = surroundingRrCount[sectionIndex]
        var surroundingRrRatingWeightedValue = surroundingRrRatingWeightedAvgArray[sectionIndex]
        var surroundingRrRatingNonWeightedValue = surroundingRrRatingNonWeightedAvgArray[sectionIndex]
        
        var totalSurroundingRrReviewCount = totalSurroundingRrReviewCount[sectionIndex]
        
        var myCity = myRrCityArray[sectionIndex]
        var myState = myRrStateArray[sectionIndex]
        var myZip = myRrZipArray[sectionIndex]
        //var addressInfo = myRrAddressArray[sectionIndex] as NSArray
        
        if let arr = myRrAddressArray[sectionIndex] as? [String] {
            print(arr)
            let joinedAddress = arr.joined(separator: ", ")
            myRrFullAddress = joinedAddress
            myRrFullAddress = myRrFullAddress?.replacingOccurrences(of: ",", with:  "")
        }
        
        // TODO: Create loop for each value fo address info, it is an arrayy and should be able to cnnect each
    //    var addressInfo = string.Join(",", MyList)myRrAddressArray[sectionIndex]
        
    //Calculate delta metrics
        var myRrRatingDeltaWeighted = Float(myRating) - surroundingRrRatingWeightedValue
        var myRrRatingDeltaNotWeighted = Float(myRating) - surroundingRrRatingNonWeightedValue
        
            
        //Store each metric in dictionary, myPhoneNumber (phone#) is the key for all
        myRrReviewCountDict.setValue(myReviewCount, forKey: "\(myPhoneNumber)")
        myRrRatingsDict.setValue(myRating, forKey: "\(myPhoneNumber)")
        myRrSurroundingRrCountDict.setValue(surroundingRrCountValue, forKey: "\(myPhoneNumber)")
        myRrRatingDeltaToNonWeightedAvgRatingDict.setValue(myRrRatingDeltaNotWeighted, forKey: "\(myPhoneNumber)")
        myRrRatingDeltaToWeightedAvgRatingDict.setValue(myRrRatingDeltaWeighted, forKey: "\(myPhoneNumber)")
        myRrAddressDict.setValue(myRrFullAddress, forKey: "\(myPhoneNumber)")
      
    //https://stackoverflow.com/questions/32593516/how-do-i-exactly-export-a-csv-file-from-ios-written-in-swift
    //Create CSV
     mailString.append("\(myPhoneNumber),\(myCity),\(myState),\(myZip), \(myRrFullAddress!),\(myRating),\(myReviewCount), \(surroundingRrCountValue), \(surroundingRrRatingWeightedValue),\(totalSurroundingRrReviewCount),\(surroundingRrRatingNonWeightedValue)\n")
    //   mailString.append("\(myPhoneNumber), \(myRating),\(myReviewCount), \(surroundingRrCountValue), \(surroundingRrRatingWeightedValue),\(surroundingRrRatingNonWeightedValue)\n")
        print(mailString)
        
        if csv_helper_count == myRrPhoneNumberArray.count{
            creatCSV(mailString: mailString)
        }
    }
}


func creatCSV(mailString:NSMutableString) -> Void {
    let fileName = "findMe.csv"
    let path = NSURL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent(fileName)
    var csvText = mailString
    
    do {
        try csvText.write(to: path!, atomically: true, encoding: String.Encoding.utf8.rawValue)
    } catch {
        print("Failed to create file")
        print("\(error)")
    }
    print(path ?? "not found")
}
