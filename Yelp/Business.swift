//
//  Business.swift
//  Yelp
//
//  Created by Rachana Bedekar on 4/25/15.
//  Copyright (c) 2015 Timothy Lee. All rights reserved.
//

import UIKit

class Business: NSObject {
    var imageUrl : String = ""
    var name : String = ""
    var ratingImageUrl : String = ""
    var numReviews : Int = 0
    var address : String = ""
    var categories : String = ""
    var distance : Double = 0.0
    
    func initWithDictionary(dictionary : NSDictionary) -> Business {
        super.superclass?.initialize()

        let categories : NSArray = dictionary["categories"] as! NSArray
        var categoryNames : NSMutableArray = NSMutableArray()
        categoryNames.arrayByAddingObject(categories)
        self.categories = categoryNames.componentsJoinedByString(", ")
        
        self.name = (dictionary["name"] as? String)!
        self.imageUrl = (dictionary["image_url"] as? String)!
        let street : String = (dictionary.valueForKeyPath("location.address")![0] as! String)
        let neighborhood = dictionary.valueForKeyPath("location.neighborhoods")![0] as! String
        self.address = street + ", " + neighborhood
        
        self.numReviews = dictionary["review_count"] as! Int
        self.ratingImageUrl = (dictionary["rating_img_url"] as? String)!
        
        let milesPerMeter : Double = 0.000621371
        let distanceDouble : Double = (dictionary["distance"] as? Double)!
        self.distance =  distanceDouble * milesPerMeter

        return self
        
    }
    func businessesWithDictionaries (dictionaries : NSArray) -> NSArray
    {
        var businesses : NSMutableArray = NSMutableArray()
        for obj : AnyObject in dictionaries
        {
            if let dictionary = obj as? NSDictionary
            {
                let business : Business = Business().initWithDictionary(dictionary)
                businesses.addObject(business)
            }
        }
        return businesses
    }
    
}
