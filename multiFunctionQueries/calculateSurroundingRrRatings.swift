import Foundation
import YelpAPI
import CDYelpFusionKit

var avgRatingArray = [Float]()
var avgWeightedRatingArray = [Float]()
var restIndex = 0

//*******NEED TO ENSURUE THAT THE ARRAY FOR RR SURROUNDING EACH RR IS CLEARING BEFORE MOVNIG ON TO THE NEXT SURROUNDING RR OF RR
var myRestComparedToWeightedArray = [Float]()
var myRestComparedToNonWeightedArray = [Float]()
var rrInRadiusCount = [Float]()

//LOOKING UP THE SURROUNDING RESTAURANTS OF EACH RESTAURANT AND CALCULATING RELEVANT INFO
public func surroundingRrPerformance(latArray: [NSNumber],longArray: [NSNumber],myRatingsArray: [NSNumber],phoneArray: [String],price: String,radius: Int, myRrNamesArray:[String]) {
   
//One loop for each restaurant identified by phone#
    for sectionIndexTopLoop in 0..<(latArray.count) {
    usleep(1000000)
    restIndex = sectionIndexTopLoop
    let apikey = "S2jB4Q-UGXJ6ovvGr3A9oAmjiSNVDsBmLWKHF7iUdcZsj1WRTxmq0Y4SaHvBjKj1mtRv6LQrjxMfI-veZukYvvBF_SRsAplkaE3wposhh4QfTy5iV5fwgk0y2x7kXHYx"
        
//LOOKUP RESTAURANTS IN RADIUS OF THE LAT AND LONG VALUES RETRIEVED FROM INITIAL LOOP USING PHONE#
    let url = URL(string: "https://api.yelp.com/v3/businesses/search?latitude=\(latArray[sectionIndexTopLoop])&longitude=\(longArray[sectionIndexTopLoop])&price=\(price)&radius=\(radius)")
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
            print("AAA")
            // print(json["businesses"])
        
        //COMMUNITY RUNS DICT HOLDS ALL  RESTAURANTS/ASSOCIATED INFO THAT WERE IN THE RADIUS OF LAT/LONG PROVIDED
            var communityRuns = [NSDictionary?]()
            communityRuns = json["businesses"] as! [NSDictionary]
            for sectionIndex in 0..<(communityRuns.count){
                // Get rating values, put in array, sum up
                let restName = communityRuns[sectionIndex]?["name"] as! String
                let review_count = communityRuns[sectionIndex]?["review_count"] as! Int
                let rating = communityRuns[sectionIndex]?["rating"] as! NSNumber
                let floatRating = Float(rating)
                let weightedRating = Float(review_count) * floatRating
                
                //Append arrays ****IS THIS CLEARING FOR EACH RESTAURANT????
                print(sectionIndexTopLoop)
                print(latArray.count)
                print(ratingsRestaurant)
                ratingsRestaurant.append(floatRating)
                weightedRatings.append(weightedRating)
                ratingsCount.append(Float(review_count))
                
                if sectionIndex == latArray.count {
                
            //Find average and weighted average ratings of restaurants
                    let sumArray = ratingsRestaurant.reduce(0, +)
                    let weightedSumRatings = weightedRatings.reduce(0, +)
                    let totalRatings = ratingsCount.reduce(0, +)
                    let countRrNearby = Float(ratingsRestaurant.count)
                    
                    let avgRating = sumArray/countRrNearby
                    let weightedAvgRating = weightedSumRatings/totalRatings
                    
                    // The reason myRestaurant is a single pull from ratingArray is that we are comparing our one restaurant to all those in the area (which is why those are looped)
                    let myRrDeltaToNonWeightedRating = Float(myRatingsArray[sectionIndexTopLoop]) - avgRating
                    let myRrDeltaToWeightedRating = Float(myRatingsArray[sectionIndexTopLoop]) - weightedAvgRating
                    
                    
                    avgRatingArray.append(avgRating)
                    avgWeightedRatingArray.append(weightedAvgRating)
                    
                    myRestComparedToWeightedArray.append(myRrDeltaToWeightedRating)
                    print(myRestComparedToWeightedArray)
                    myRestComparedToNonWeightedArray.append(myRrDeltaToNonWeightedRating)
                    print(myRestComparedToNonWeightedArray)
                    rrInRadiusCount.append(countRrNearby)
                    
                    //Arrays of 1) myRatings ratingArray   2) name nameArray 3) average rating other restaurants avgRatingArray
                    // 4) Weighted average other restaurants avgWeightedRatingArray 5) Array myRest - Other Rest myRestComparedToNonWeighted
                    // 6) Array myRest - others weighted myRestComparedToWeighted
                    print(avgRatingArray)
                    print(avgWeightedRatingArray)
                    
                    print(myRestComparedToWeightedArray)
                    print(myRestComparedToNonWeightedArray)
                    
                }
       
        }
        
        } catch {
            print("caught")
        }
        }.resume()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 10.1) {
            
            formatData(myRrNamesArray: myRrNamesArray, myRatingsArray: myRatingsArray, myRestComparedToNonWeightedArray: myRestComparedToNonWeightedArray as [NSNumber], myRestComparedToWeightedArray:myRestComparedToWeightedArray as [NSNumber])
        }
        
}
   
}
