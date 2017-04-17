//
//  StudentLocation.swift
//  On The Map
//
//  Created by Michael Manisa on 4/13/17.
//  Copyright © 2017 Michael Manisa. All rights reserved.
//

struct StudentLocation {
    
    // MARK: Properties
    let uniqueKey: AnyObject
    let firstName: AnyObject
    let lastName: AnyObject
    let mapString: AnyObject
    let mediaURL: AnyObject
    let latitude: AnyObject
    let longitude: AnyObject
    
    // MARK: Initializers
    init(dictionary: [String:AnyObject]) {
        uniqueKey = dictionary[ParseClient.JSONResponseKeys.uniqueKey] as AnyObject
        firstName = dictionary[ParseClient.JSONResponseKeys.firstName] as AnyObject
        lastName = dictionary[ParseClient.JSONResponseKeys.lastName] as AnyObject
        mapString = dictionary[ParseClient.JSONResponseKeys.mapString] as AnyObject
        mediaURL = dictionary[ParseClient.JSONResponseKeys.mediaURL] as AnyObject
        latitude = dictionary[ParseClient.JSONResponseKeys.latitude] as AnyObject
        longitude = dictionary[ParseClient.JSONResponseKeys.longitude] as AnyObject
    }
    
}
