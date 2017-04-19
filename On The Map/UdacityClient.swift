//
//  UdacityClient.swift
//  On The Map
//
//  Created by Michael Manisa on 4/11/17.
//  Copyright © 2017 Michael Manisa. All rights reserved.
//

import UIKit
import Foundation

// MARK: UdacityClient

class UdacityClient : NSObject {
    
    // MARK: Properties
    
    // shared session
    var session = URLSession.shared
    
    // configuration state
    var accountKey: String? = nil
    var sessionID: String? = nil
    
    // MARK: Initializers
    override init() {
        super.init()
    }
    
    

    func authenticateWithViewController(_ hostViewController: UIViewController, completionHandlerForAuth: @escaping (_ success: Bool, _ errorString: String?) -> Void) {
        
        // chain completion handlers for each request so that they run one after the other
        getCredentials() { (success, accountKey, sessionId, errorString) in
            
            if success {
                
                // success! we have the accountKey and sessionId!
                self.accountKey = accountKey
                self.sessionID = sessionId
                
                completionHandlerForAuth(true, nil)
                
                // debugging
                print(self.accountKey!)
                print(self.sessionID!)
                
            } else {
                
                completionHandlerForAuth(false, errorString)
            }
        }
    }
    
    // MARK: GET
    
    private func getCredentials(_ completionHandlerForGetCredentials: @escaping (_ success: Bool, _ accountKey: String?, _ sessionId: String?, _ errorString: String?) -> Void) {
        
        /* 1. Set the parameters */
        // none
        
        /* 2/3. Build the URL, Configure the request */
        let request = NSMutableURLRequest(url: URL(string: "https://www.udacity.com/api/session")!)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = "{\"udacity\": {\"\(UdacityClient.JSONBodyKeys.Username)\": \"michael.manisa@gmail.com\", \"\(UdacityClient.JSONBodyKeys.Password)\": \"sBux1820202\"}}".data(using: String.Encoding.utf8)
        
        /* 4. Make the request */
        let task = self.session.dataTask(with: request as URLRequest) { data, response , error in
            
            func sendError(_ error: String) {
                print(error)
                completionHandlerForGetCredentials(false, nil, nil, error)
            }
            
            /* GUARD: Was there an error? */
            guard (error == nil) else {
                sendError("There was an error with your getCredentials request: \(error)")
                return
            }
            
            /* GUARD: Did we get a successful 2XX response? */
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
                sendError("Your getCredentials request returned a status code other than 2xx!")
                return
            }
            
            /* GUARD: Was there any data returned? */
            guard let data = data else {
                sendError("No data was returned by the getCredentials request!")
                return
            }
            
            let range = Range(5..<data.count)
            let newData = data.subdata(in: range)
            
            /* 5/6. Parse the data and use the data (happens in completion handler) */
            var parsedResult: AnyObject! = nil
            
            do {
                parsedResult = try JSONSerialization.jsonObject(with: newData, options: .allowFragments) as AnyObject
                print(parsedResult)
            } catch {
                
            }
            
            if let accountDictionary = parsedResult["account"] as? [String:AnyObject], let sessionDictionary = parsedResult["session"] as? [String:AnyObject] {
                let key = accountDictionary["key"] as! String?
                let session = sessionDictionary["id"] as! String?
                completionHandlerForGetCredentials(true, key, session, nil)
            }
            
        }
        
        /* 7. Start the request */
        task.resume()
    }
    
    
    func endSession() {
        
        let request = NSMutableURLRequest(url: URL(string: "https://www.udacity.com/api/session")!)
        request.httpMethod = "DELETE"
        var xsrfCookie: HTTPCookie? = nil
        let sharedCookieStorage = HTTPCookieStorage.shared
        for cookie in sharedCookieStorage.cookies! {
            if cookie.name == "XSRF-TOKEN" { xsrfCookie = cookie }
        }
        if let xsrfCookie = xsrfCookie {
            request.setValue(xsrfCookie.value, forHTTPHeaderField: "X-XSRF-TOKEN")
        }
        let session = URLSession.shared
        let task = session.dataTask(with: request as URLRequest) { data, response, error in
            if error != nil { // Handle error…
                return
            }
            let range = Range(5 ..< data!.count)
            let newData = data?.subdata(in: range) /* subset response data! */
            print(NSString(data: newData!, encoding: String.Encoding.utf8.rawValue)!)
        }
        
        task.resume()
    }
    
    
    // MARK: Shared Instance
    
    class func sharedInstance() -> UdacityClient {
        struct Singleton {
            static var sharedInstance = UdacityClient()
        }
        return Singleton.sharedInstance
    }
    
    
}
