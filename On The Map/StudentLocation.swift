//
//  StudentLocation.swift
//  On The Map
//
//  Created by Michael Manisa on 4/13/17.
//  Copyright © 2017 Michael Manisa. All rights reserved.
//

struct StudentLocation {
    
    // MARK: Properties
    let uniqueKey: String?
    let objectId: String?
    let firstName: String?
    let lastName: String?
    let mediaURL: String?
    let latitude: Double?
    let longitude: Double?
    let mapString: String?
    
    // MARK: Initializers
    
    // construct a StudentLocation from a dictionary
    init(dictionary: [String:AnyObject]) {
        uniqueKey = dictionary[ParseClient.JSONResponseKeys.uniqueKey] as? String
        objectId = dictionary[ParseClient.JSONResponseKeys.objectID] as? String
        firstName = dictionary[ParseClient.JSONResponseKeys.firstName] as? String
        lastName = dictionary[ParseClient.JSONResponseKeys.lastName] as? String
        mediaURL = dictionary[ParseClient.JSONResponseKeys.mediaURL] as? String
        latitude = dictionary[ParseClient.JSONResponseKeys.latitude] as? Double
        longitude = dictionary[ParseClient.JSONResponseKeys.longitude] as? Double
        mapString = dictionary[ParseClient.JSONResponseKeys.mapString] as? String

    }
    
    // function to create the array of studentLocations
    static func studentLocationsFromResults(_ results: [[String:AnyObject]]) -> [StudentLocation] {

        var locations = [StudentLocation]()
        
        //iterate through the array of dictionaries, each student is a dictionary.
        for result in results {
            locations.append(StudentLocation(dictionary: result))
        }
        
        return locations
    }
    
}
