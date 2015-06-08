//
//  ParseClient.swift
//  On The Map
//
//  Created by Che-Chuen Ho on 4/20/15.
//  Copyright (c) 2015 Che-Chuen Ho. All rights reserved.
//

import Foundation

class ParseClient: NSObject {
    
    var session: NSURLSession
    var locations = [StudentInformation]()
    var urlTask: NSURLSessionTask? = nil
    var totalStudentLocations: Int
    
    override init() {
        session = NSURLSession.sharedSession()
        totalStudentLocations = 0
    }
    
    // MARK: - Shared Instance
    class func sharedInstance() -> ParseClient {
    
        struct Singleton {
            static var sharedInstance = ParseClient()
        }
        
        return Singleton.sharedInstance
    }
    
    // MARK: - GET
    func taskForGETMethod(method: String, parameters: [String: AnyObject]?, completionHandler: (result: AnyObject!, error: NSError?) -> Void) -> NSURLSessionDataTask {
        
        var urlString = ParseClient.Constants.BaseURL + method
        
        if parameters != nil {
            urlString += UtilityMethods.escapedParameters(parameters!)
        }
        
        let url = NSURL(string: urlString)!
        let request = NSMutableURLRequest(URL: url)
        request.addValue(ParseClient.Constants.ParseAppID, forHTTPHeaderField: ParseClient.Constants.ParseAppIDHeader)
        request.addValue(ParseClient.Constants.ParseRestKey, forHTTPHeaderField: ParseClient.Constants.ParseRestKeyHeader)
        
        let task = session.dataTaskWithRequest(request) {data, response, downloadError in
            if let error = downloadError {
                let newError = ParseClient.errorForData(data, response: response, error: error)
                completionHandler(result: nil, error: newError)
            } else {
                UtilityMethods.parseJSONWithCompletionHandler(data, completionHandler: completionHandler)
            }
        }
        
        task.resume()
        
        return task
    }
    
    // MARK: - POST
    func taskForPOSTMethod(method: String, parameters: [String: AnyObject], completionHandler: (result: AnyObject!, error: NSError?) -> Void) -> NSURLSessionDataTask {
        
        var mutableParameters = parameters
        
        let urlString = ParseClient.Constants.BaseURL + method
        let url = NSURL(string: urlString)!
        let request = NSMutableURLRequest(URL: url)
        request.addValue(ParseClient.Constants.ParseAppID, forHTTPHeaderField: ParseClient.Constants.ParseAppIDHeader)
        request.addValue(ParseClient.Constants.ParseRestKey, forHTTPHeaderField: ParseClient.Constants.ParseRestKeyHeader)
        request.HTTPMethod = "POST"
        
        var error: NSError? = nil
        request.HTTPBody = NSJSONSerialization.dataWithJSONObject(mutableParameters, options: nil, error: &error)
        let dataString = NSString(data: request.HTTPBody!, encoding: NSUTF8StringEncoding)
        
        let task = session.dataTaskWithRequest(request) { data, response, error in
            if error != nil {
                let newError = ParseClient.errorForData(data, response: response, error: error)
                completionHandler(result: nil, error: newError)
            } else {
                UtilityMethods.parseJSONWithCompletionHandler(data, completionHandler: completionHandler)
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
    
    class func errorForData(data: NSData?, response: NSURLResponse?, error: NSError) -> NSError {
        
        if let parsedResult = NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.AllowFragments, error: nil) as? [String: AnyObject] {
            if let errorMessage = parsedResult[ParseClient.JSONKeys.ObjectID] as? String {
                let userInfo = [NSLocalizedDescriptionKey: errorMessage]
                
                return NSError(domain: "Parse Error", code: 1, userInfo: userInfo)
            }
        }
        
        return error
    }
}