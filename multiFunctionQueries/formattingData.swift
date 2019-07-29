//
//  formattingData.swift
//  yelpu
//
//  Created by Neil Bronfin on 5/25/19.
//  Copyright © 2019 Neil Bronfin. All rights reserved.
//

import Foundation



func formatData(myRrNamesArray:[String],myRatingsArray: [NSNumber],myRestComparedToNonWeightedArray:[NSNumber],myRestComparedToWeightedArray:[NSNumber]) {
    
    var restInfoMyRating = NSMutableDictionary()
    var restInfoComparedToNonWeighted = NSMutableDictionary()
    var restInfoComparedToWeighted = NSMutableDictionary()
    
for sectionIndex in 0..<(myRrNamesArray.count) {
    
// Find a way to save this
// Could do a different dictionary for each subject, may be the best way here
    print(myRrNamesArray)
    restInfoMyRating.setValue(myRatingsArray[sectionIndex], forKey: "\(myRrNamesArray[sectionIndex])")
    //THIS SEEMS TO E CATCHINNG A NIL AND FAILINIG
    print(myRestComparedToNonWeightedArray)
    restInfoComparedToNonWeighted.setValue(myRestComparedToNonWeightedArray[sectionIndex], forKey: "\(myRrNamesArray[sectionIndex])")
    print(myRestComparedToWeightedArray)
    restInfoComparedToWeighted.setValue(myRestComparedToWeightedArray[sectionIndex], forKey: "\(myRrNamesArray[sectionIndex])")
    
    print("RESULTS")
    
    print("MyRatings")
    print(restInfoMyRating)
    print("MyRatingsComparedToAreaNonWeighted")
    print(restInfoComparedToNonWeighted)
    print("MyRatingsComparedToAreaWeighted")
    print(restInfoComparedToWeighted)
    
}

}




//Arrays of 1) myRatings ratingArray   2) name nameArray 3) average rating other restaurants avgRatingArray
// 4) Weighted average other restaurants avgWeightedRatingArray 5) Array myRest - Other Rest myRestComparedToNonWeighted
// 6) Array myRest - others weighted myRestComparedToWeighted
