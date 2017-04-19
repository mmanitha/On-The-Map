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
    
    func taskForParse(methodType string: String, parameters: [String:AnyObject]?, pathExtension: String?, jsonBody: String?, completionHanderForParse: @escaping (_ result: AnyObject?, _ error: NSError?) -> Void) -> URLSessionDataTask {
        
        /* 1. Set the parameters */
        
        /* 2/3. Build the URL, Configure the request */
        let urlFromParameters = ParseURLFromParameters(parameters!, withPathExtension: nil)
        let request = NSMutableURLRequest(url: urlFromParameters)
        request.addValue("\(ParseClient.Constants.parseApplicationId)", forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue("\(ParseClient.Constants.parseRESTApiKey)", forHTTPHeaderField: "X-Parse-REST-API-Key")
        
        if jsonBody != nil {
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpBody = jsonBody?.data(using: String.Encoding.utf8)
        }
        
        /* 4. Make the request */
        let task = URLSession.shared.dataTask(with: request as URLRequest) { (data, response, error) in
        
            func sendError(_ error: String) {
                
                print(error)
                let userInfo = [NSLocalizedDescriptionKey : error]
                completionHanderForParse(nil, NSError(domain: "taskForParse", code: 1, userInfo: userInfo))
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
            self.convertDataWithCompletionHandler(data, completionHandlerForConvertData: completionHanderForParse)

        }
        
        /* 7. Start the request */
        task.resume()
        
        return task
    }
    
    

    // GETting Student Locations

    func getStudents(_ completionHandlerForGetStudents: @escaping (_ result: AnyObject?, _ error: NSError?) -> Void) {
        
        var parameters = [String:AnyObject]()
        parameters["limit"] = "1" as AnyObject?
        
        let _ = taskForParse(methodType: "GET", parameters: parameters as [String:AnyObject], pathExtension: nil, jsonBody: nil) { (result, error) in
            
            if error == nil {
                completionHandlerForGetStudents(result, nil)
            } else {
                print(error!)
                let userInfo = [NSLocalizedDescriptionKey : error]
                completionHandlerForGetStudents(nil, NSError(domain: "getStudents", code: 1, userInfo: userInfo))
            }
        }
    }

    
    // GETting single student location
    
    func getStudent(with objectId: String, _ completionHanderForGetStudent: @escaping (_ result: AnyObject?, _ error: NSError?) -> Void) {
        
        var parameters = [String:AnyObject]()
        parameters["where"] = "{\"uniqueKey\":\"\(objectId)\"}" as AnyObject?
        

        
        let _ = taskForParse(methodType: "GET", parameters: parameters as [String:AnyObject], pathExtension: nil, jsonBody: nil) { (result, error) in
            
            if error == nil {
                completionHanderForGetStudent(result, nil)
            } else {
                print(error!)
                let userInfo = [NSLocalizedDescriptionKey : error]
                completionHanderForGetStudent(nil, NSError(domain: "getStudent", code: 1, userInfo: userInfo))
            }
        }
    }
    
    
    // POSTing a student location

    func postLocation(_ student: StudentLocation, _ completionHanderForPostLocation: @escaping (_ result: AnyObject?, _ error: NSError?) -> Void) {
    
        let jsonBody = "{\"uniqueKey\": \"\(student.uniqueKey)\", \"firstName\": \"\(student.firstName)\", \"lastName\": \"\(student.lastName)\",\"mapString\": \"\(student.mapString)\", \"mediaURL\": \"\(student.mediaURL)\",\"latitude\": \(student.latitude), \"longitude\": \(student.longitude)}"
        
        let _ = taskForParse(methodType: "POST", parameters: nil, pathExtension: nil, jsonBody: jsonBody) { (result, error) in
            
            if error == nil {
                completionHanderForPostLocation(result, nil)
            } else {
                print(error!)
                let userInfo = [NSLocalizedDescriptionKey : error]
                completionHanderForPostLocation(nil, NSError(domain: "postLocation", code: 1, userInfo: userInfo))
            }
        }
    }
    
    
    // PUTting a student location
    
    func putLocation(_ objectId: String, _ student: StudentLocation, _ completionHanderForPutLocation: @escaping (_ result: AnyObject?, _ error: NSError?) -> Void) {
        
        let jsonBody = "{\"uniqueKey\": \"\(student.uniqueKey)\", \"firstName\": \"\(student.firstName)\", \"lastName\": \"\(student.lastName)\",\"mapString\": \"\(student.mapString)\", \"mediaURL\": \"\(student.mediaURL)\",\"latitude\": \(student.latitude), \"longitude\": \(student.longitude)}"
        
        let _ = taskForParse(methodType: "PUT", parameters: nil, pathExtension: objectId, jsonBody: jsonBody) { (result, error) in
            
            if error == nil {
                completionHanderForPutLocation(result, nil)
            } else {
                print(error!)
                let userInfo = [NSLocalizedDescriptionKey : error]
                completionHanderForPutLocation(nil, NSError(domain: "putLocation", code: 1, userInfo: userInfo))
            }
        }
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
