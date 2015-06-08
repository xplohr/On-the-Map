//
//  UdacityClient.swift
//  On The Map
//
//  Created by Che-Chuen Ho on 4/8/15.
//  Copyright (c) 2015 Che-Chuen Ho. All rights reserved.
//

import Foundation

class UdacityClient: NSObject {
    
    var session: NSURLSession
    var sessionID: String? = nil
    var userFirstName: String? = nil
    var userLastName: String? = nil
    var userID: String? = nil
    var urlTask: NSURLSessionTask? = nil
    
    override init() {
        session = NSURLSession.sharedSession()
        super.init()
    }
    
    // MARK: - Shared Instance
    
    class func sharedInstance() -> UdacityClient {
    
        struct Singleton {
            static var sharedInstance = UdacityClient()
        }
        
        return Singleton.sharedInstance
    }
    
    // MARK: - GET
    
    /* taskForGETMethod
    Purpose: Construct and execute a GET request, returning the results to a completion handler
    Parameters:
    - method: a String with the name of the API method to append to the URL
    - parameters: a dictionary containing key, values to append to the URL as URL parameters
    - completionHandler: callback to handle the results of the POST
    */
    func taskForGETMethod(method: String, parameters: [String: AnyObject]?, completionHandler: (result: AnyObject!, error: NSError?) -> Void) -> NSURLSessionDataTask {
        
        var urlString = UdacityClient.Constants.BaseURL + method
        
        if let mutableParameters = parameters {
            urlString += UtilityMethods.escapedParameters(mutableParameters)
        }
        
        let url = NSURL(string: urlString)!
        let request = NSURLRequest(URL: url)
        
        let task = session.dataTaskWithRequest(request) {data, response, downloadError in
            if let error = downloadError {
                let newError = UdacityClient.errorForData(data, response: response, error: error)
                completionHandler(result: nil, error: newError)
            } else {
                UdacityClient.parseJSONWithCompletionHandler(data, completionHandler: completionHandler)
            }
        }
        
        task.resume()
        
        return task
    }
    
    // MARK: - POST
    
    /* taskForPOSTMethod
        Purpose: Construct and execute a POST request, returning the results to a completion handler
        Parameters:
            - method: a String with the name of the API method to append to the URL
            - parameters: a dictionary containing key, values to append to the URL as URL parameters
            - jsonBody: a dictionary containing key, values to serialize into the HTTP Body
            - completionHandler: callback to handle the results of the POST
    */
    func taskForPOSTMethod(method: String, parameters: [String: AnyObject], jsonBody: [String: AnyObject], completionHandler: (result: AnyObject!, error: NSError?) -> Void) -> NSURLSessionTask {
        
        var mutableParameters = parameters
        
        let urlString = Constants.BaseURL + method + UtilityMethods.escapedParameters(mutableParameters)
        let url = NSURL(string: urlString)!
        let request = NSMutableURLRequest(URL: url)
        var jsonifyError: NSError? = nil
        request.HTTPMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.HTTPBody = NSJSONSerialization.dataWithJSONObject(jsonBody, options: nil, error: &jsonifyError)
        
        let task = session.dataTaskWithRequest(request) {data, response, downloadError in
            if let error = downloadError {
                let newError = UdacityClient.errorForData(data, response: response, error: error)
                completionHandler(result: nil, error: newError)
            } else {
                UdacityClient.parseJSONWithCompletionHandler(data, completionHandler: completionHandler)
            }
        }
        
        task.resume()
        
        return task
    }
    
    // MARK: - Cancel
    func cancelURLTask() {
        urlTask?.cancel()
    }
    
    // MARK: - Helpers
    
    /* Helper: Given a response with error, see if a status_message is returned. Otherwise, return the previous error */
    class func errorForData(data: NSData?, response: NSURLResponse?, error: NSError) -> NSError {
    
        if let parsedResult = NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.AllowFragments, error: nil) as? [String: AnyObject] {
            if let errorMessage = parsedResult[UdacityClient.JSONResponseKeys.StatusMessage] as? String {
                let userInfo = [NSLocalizedDescriptionKey: errorMessage]
                
                return NSError(domain: "Udacity Error", code: 1, userInfo: userInfo)
            }
        }
        
        return error
    }
    
    /* Helper: Given raw JSON, return a usable Foundation object */
    class func parseJSONWithCompletionHandler(data: NSData, completionHandler: (result: AnyObject!, error: NSError?) -> Void) {
        
        var parsingError: NSError? = nil
        let newData = data.subdataWithRange(NSMakeRange(5, data.length - 5))
        let parsedResult: AnyObject? = NSJSONSerialization.JSONObjectWithData(newData, options: NSJSONReadingOptions.AllowFragments, error: &parsingError)
        
        if let error = parsingError {
            completionHandler(result: nil, error: error)
        } else {
            completionHandler(result: parsedResult, error: nil)
        }
    }
}