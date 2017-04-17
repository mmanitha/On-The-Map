//
//  ParseClient.swift
//  On The Map
//
//  Created by Michael Manisa on 4/11/17.
//  Copyright © 2017 Michael Manisa. All rights reserved.
//

import Foundation

// MARK: ParseClient

class ParseClient : NSObject {
    

    // GETting Student Locations
    func taskForGETStudents(_ method: String, parameters: [String:AnyObject], jsonBody: String, completionHandlerForGETStudents: @escaping (_ result: AnyObject?, _ error: NSError?) -> Void) -> URLSessionDataTask {
        
        /* 1. Set the parameters */
        var parameters = parameters
        parameters["limit"] = "100" as AnyObject?
        
        /* 2/3. Build the URL, Configure the request */
        let urlFromParameters = ParseURLFromParameters(parameters)
        let request = NSMutableURLRequest(url: urlFromParameters)
        request.addValue("\(ParseClient.Constants.parseApplicationId)", forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue("\(ParseClient.Constants.parseRESTApiKey)", forHTTPHeaderField: "X-Parse-REST-API-Key")
        let session = URLSession.shared
        
        /* 4. Make the request */
        let task = session.dataTask(with: request as URLRequest) { data, response, error in
            
            func sendError(_ error: String) {
                print(error)
                let userInfo = [NSLocalizedDescriptionKey : error]
                completionHandlerForGETStudents(nil, NSError(domain: "taskForGETMethod", code: 1, userInfo: userInfo))
            }
            
            /* GUARD: Was there an error? */
            guard (error == nil) else {
                sendError("There was an error with your request: \(error)")
                return
            }
            
            /* GUARD: Did we get a successful 2XX response? */
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
                sendError("Your request returned a status code other than 2xx!")
                return
            }
            
            /* GUARD: Was there any data returned? */
            guard let data = data else {
                sendError("No data was returned by the request!")
                return
            }
            
            /* 5/6. Parse the data and use the data (happens in completion handler) */
            self.convertDataWithCompletionHandler(data, completionHandlerForConvertData: completionHandlerForGETStudents)
        }
        
        /* 7. Start the request */
        task.resume()
        
        return task
    }
    
    
    // GETting a Student Location
    func taskForGETSingleStudent(_ method: String, parameters: [String:AnyObject], uniqueKey: String, jsonBody: String, completionHandlerForGETSingleStudent: @escaping (_ result: AnyObject?, _ error: NSError?) -> Void) -> URLSessionDataTask {
        
        /* 1. Set the parameters,required parameter: where={"uniqueKey":"1234"} */
        var parameters = parameters
        parameters["limit"] = "{%22uniqueKey%22:%22\(uniqueKey)%22}" as AnyObject?
        
        //Build URL with URL constructor, establish parameters, return it
        let urlString = ParseURLFromParameters(parameters)
        
        /* 2/3. Build the URL, Configure the request */
        let request = NSMutableURLRequest(url: urlString)
        request.addValue("\(ParseClient.Constants.parseApplicationId)", forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue("\(ParseClient.Constants.parseRESTApiKey)", forHTTPHeaderField: "X-Parse-REST-API-Key")
        let session = URLSession.shared
        
        /* 4. Make the request */
        let task = session.dataTask(with: request as URLRequest) { data, response, error in
            
            func sendError(_ error: String) {
                print(error)
                let userInfo = [NSLocalizedDescriptionKey : error]
                completionHandlerForGETSingleStudent(nil, NSError(domain: "taskForGETMethod", code: 1, userInfo: userInfo))
            }
            
            /* GUARD: Was there an error? */
            guard (error == nil) else {
                sendError("There was an error with your request: \(error)")
                return
            }
            
            /* GUARD: Did we get a successful 2XX response? */
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
                sendError("Your request returned a status code other than 2xx!")
                return
            }
            
            /* GUARD: Was there any data returned? */
            guard let data = data else {
                sendError("No data was returned by the request!")
                return
            }
            
            /* 5/6. Parse the data and use the data (happens in completion handler) */
            self.convertDataWithCompletionHandler(data, completionHandlerForConvertData: completionHandlerForGETSingleStudent)
        }
        
        /* 7. Start the request */
        task.resume()
        
        return task
    }
    
    // POSTing a Student Location
    func taskForPOSTLocation(_ method: String, student: StudentLocation, parameters: [String:AnyObject], jsonBody: String, completionHandlerForPOST: @escaping (_ result: AnyObject?, _ error: NSError?) -> Void) -> URLSessionDataTask {
        
        /* 1. Set the parameters */
        
        /* 2/3. Build the URL, Configure the request */
        
        let urlString = ParseURLFromParameters(parameters)
        
        //make sure to check for existing uniqueKey before allowing to post
        let request = NSMutableURLRequest(url: urlString)
        request.httpMethod = "POST"
        request.addValue("\(ParseClient.Constants.parseApplicationId)", forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue("\(ParseClient.Constants.parseRESTApiKey)", forHTTPHeaderField: "X-Parse-REST-API-Key")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = "{\"uniqueKey\": \"\(student.uniqueKey)\", \"firstName\": \"\(student.firstName)\", \"lastName\": \"\(student.lastName)\",\"mapString\": \"\(student.mapString)\", \"mediaURL\": \"\(student.mediaURL)\",\"latitude\": \(student.latitude), \"longitude\": \(student.longitude)}".data(using: String.Encoding.utf8)
        let session = URLSession.shared
        
        /* 4. Make the request */
        let task = session.dataTask(with: request as URLRequest) { data, response, error in
            
            /* 5/6. Parse the data and use the data (happens in completion handler) */
            if error != nil { // Handle error…
                return
            }
            print(NSString(data: data!, encoding: String.Encoding.utf8.rawValue)!)
        }
        
        /* 7. Start the request */
        task.resume()
        
        return task
    }
    
    // PUTting a Student Location
    func taskForPUTLocation(student: StudentLocation) {
        
        /* 1. Set the parameters */
        
        /* 2/3. Build the URL, Configure the request */
        //build URL with url constructor, utilize path extention to add object ID
        let urlString = "https://parse.udacity.com/parse/classes/StudentLocation/8ZExGR5uX8"
        let url = URL(string: urlString)
        let request = NSMutableURLRequest(url: url!)
        request.httpMethod = "PUT"
        request.addValue("\(ParseClient.Constants.parseApplicationId)", forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue("\(ParseClient.Constants.parseRESTApiKey)", forHTTPHeaderField: "X-Parse-REST-API-Key")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = "{\"uniqueKey\": \"\(student.uniqueKey)\", \"firstName\": \"\(student.firstName)\", \"lastName\": \"\(student.lastName)\",\"mapString\": \"\(student.mapString)\", \"mediaURL\": \"\(student.mediaURL)\",\"latitude\": \(student.latitude), \"longitude\": \(student.longitude)}".data(using: String.Encoding.utf8)
        let session = URLSession.shared
        
        /* 4. Make the request */
        let task = session.dataTask(with: request as URLRequest) { data, response, error in
            
            /* 5/6. Parse the data and use the data (happens in completion handler) */
            if error != nil { // Handle error…
                return
            }
            print(NSString(data: data!, encoding: String.Encoding.utf8.rawValue)!)
        }
        
        /* 7. Start the request */
        task.resume()
    }
    
    // MARK: Helpers
    
    // given raw JSON, return a usable Foundation object
    private func convertDataWithCompletionHandler(_ data: Data, completionHandlerForConvertData: (_ result: AnyObject?, _ error: NSError?) -> Void) {
        
        var parsedResult: AnyObject! = nil
        do {
            parsedResult = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as AnyObject
        } catch {
            let userInfo = [NSLocalizedDescriptionKey : "Could not parse the data as JSON: '\(data)'"]
            completionHandlerForConvertData(nil, NSError(domain: "convertDataWithCompletionHandler", code: 1, userInfo: userInfo))
        }
        
        completionHandlerForConvertData(parsedResult, nil)
    }
    
    // create a URL from parameters
    private func ParseURLFromParameters(_ parameters: [String:AnyObject], withPathExtension: String? = nil) -> URL {
        
        var components = URLComponents()
        components.scheme = ParseClient.Constants.ApiScheme
        components.host = ParseClient.Constants.ApiHost
        components.path = ParseClient.Constants.ApiPath + (withPathExtension ?? "")
        components.queryItems = [URLQueryItem]()
        
        for (key, value) in parameters {
            let queryItem = URLQueryItem(name: key, value: "\(value)")
            components.queryItems!.append(queryItem)
        }
        
        return components.url!
    }
    
    // MARK: Shared Instance
    
    class func sharedInstance() -> ParseClient {
        struct Singleton {
            static var sharedInstance = ParseClient()
        }
        return Singleton.sharedInstance
    }
    
}
