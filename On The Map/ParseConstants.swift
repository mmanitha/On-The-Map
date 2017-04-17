//
//  ParseConstants.swift
//  On The Map
//
//  Created by Michael Manisa on 4/11/17.
//  Copyright © 2017 Michael Manisa. All rights reserved.
//

extension ParseClient {
    
    struct Constants {
        
        static let parseApplicationId = "QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr"
        static let parseRESTApiKey = "QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY"
        
        //MARK: URLs
        static let ApiScheme = "https"
        static let ApiHost = "parse.udacity.com"
        static let ApiPath = "parse/classes/StudentLocation"
        
    }
    
    struct JSONResponseKeys {
        
        static let objectID = "objectId"
        static let latitude = "latitude"
        static let longitude = "longitude"
        static let mapString = "mapString"
        static let uniqueKey = "uniqueKey"
        static let lastName = "lastName"
        static let firstName = "firstName"
        static let mediaURL = "mediaURL"
        
    }
    
}
