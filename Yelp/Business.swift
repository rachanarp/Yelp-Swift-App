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
        var categoryNames = [String]()
        
        for category in categories {
            categoryNames.append(category[0] as! String)
        }
        
        var categoriesStr : String = ""
        for categoryName in categoryNames {
            categoriesStr += categoryName + ","
        }
        
        let stringLength = count (categoriesStr)
        let substringIndex = stringLength - 1
        
        self.categories = categoriesStr.substringToIndex(categoriesStr.endIndex.predecessor())
        
        self.name = (dictionary["name"] as? String)!
        self.imageUrl = (dictionary["image_url"] as? String)!
        
        var address : String = ""
        if (nil != dictionary.valueForKeyPath("location.address") ) {
            if(dictionary.valueForKeyPath("location.address")?.count > 0){
                address = (dictionary.valueForKeyPath("location.address")?[0] as! String) }
        }
        
        var neighborhood : String = ""
        if (nil != dictionary.valueForKeyPath("location.neighborhoods") ) {
            if(dictionary.valueForKeyPath("location.neighborhoods")?.count > 0){
                neighborhood = (dictionary.valueForKeyPath("location.neighborhoods")?[0] as! String) }
        }

        self.address = address + ", " + neighborhood
        
        if (nil != dictionary["review_count"] ) {
            self.numReviews = dictionary["review_count"] as! Int }
        
        if (nil != dictionary["rating_img_url"] ) {
            self.ratingImageUrl = dictionary["rating_img_url"] as! String}
        
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
