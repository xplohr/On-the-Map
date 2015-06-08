//
//  UdacityConvenience.swift
//  On The Map
//
//  Created by Che-Chuen Ho on 4/8/15.
//  Copyright (c) 2015 Che-Chuen Ho. All rights reserved.
//

import Foundation
import UIKit
import FBSDKLoginKit

extension UdacityClient {
    
    // MARK: - Authentication
    func authenticationWithUserPass(username: String, password: String, completionHandler: (success: Bool, errorString: String?) -> Void) {
        
        // 1. Specify parameters
        var parameters = [String: AnyObject]() // No URL parameters in this case. The username & password gets passed via JSON in HTTP body
        let jsonBody = [ParameterKeys.ParameterDictionaryName: [ParameterKeys.Username: username, ParameterKeys.Password: password]]
        
        // 2. Make the request
        urlTask = taskForPOSTMethod(UdacityClient.Methods.SessionCreate, parameters: parameters, jsonBody: jsonBody) {
            data, error in
            
            // 3. Send the desired value(s) to the completion handler
            if let error = error {
                completionHandler(success: false, errorString: error.description)
            } else {
                // Check returned data to see if it succeeded or returned an error
                self.processAuthenticationResponse(data, error: error, completionHandler: completionHandler)
            }
        }
    }
    
    func authenticationWithFacebook(completionHandler: (success: Bool, errorString: String?) -> Void) {
        var parameters = [String: AnyObject]()
        
        let jsonBody = [FacebookKeys.FacebookDictionaryName: [FacebookKeys.accessToken: FBSDKAccessToken.currentAccessToken().tokenString]]
        
        urlTask = taskForPOSTMethod(UdacityClient.Methods.SessionCreate, parameters: parameters, jsonBody: jsonBody) {
            data, error in
            
            self.processAuthenticationResponse(data, error: error, completionHandler: completionHandler)
        }
    }
    
    func processAuthenticationResponse(data: AnyObject!, error: NSError?, completionHandler: (success: Bool, errorString: String?) -> Void) {
        if let status = data[JSONResponseKeys.Status] as? Int {
            completionHandler(success: false, errorString: status.description)
        } else {
            println("Authenticated")
            let sessionData = data[JSONResponseKeys.Session]
            if let sessionDictionary = sessionData as? NSDictionary {
                self.sessionID = sessionDictionary[JSONResponseKeys.SessionID] as? String
            } else {
                completionHandler(success: false, errorString: JSONResponseKeys.SessionError)
            }
            
            // Get user info
            let accountData = data[JSONResponseKeys.Account]
            if let accountDictionary = accountData as? NSDictionary {
                self.userID = accountDictionary[JSONResponseKeys.AccountKey] as? String
                self.getUserPublicInfo(self.userID!) {success, errorString in
                    if success {
                        completionHandler(success: true, errorString: nil)
                    } else {
                        completionHandler(success: false, errorString: JSONResponseKeys.UserGetInfoError)
                    }
                }
            } else {
                completionHandler(success: false, errorString: JSONResponseKeys.UserGetInfoError)
            }
        }
    }
    
    // MARK: - Account methods
    func getUserPublicInfo(userID: String, completionHandler:(success: Bool, errorString: String?) -> Void) {
        
        var parameters = [String: AnyObject]()
        
        urlTask = taskForGETMethod(UtilityMethods.substituteKeyInMethod(UdacityClient.Methods.UserData, key: "userID", value: userID)!, parameters: parameters) { data, error in
            
            if let error = error {
                completionHandler(success: false, errorString: error.description)
            } else {
                if let status = data[JSONResponseKeys.Status] as? Int {
                    completionHandler(success: false, errorString: status.description)
                } else {
                    let userData = data[JSONResponseKeys.User]
                    if let userDictionary = userData as? NSDictionary {
                        self.userFirstName = userDictionary[JSONResponseKeys.UserFirstName] as? String
                        self.userLastName = userDictionary[JSONResponseKeys.UserLastName] as? String
                        completionHandler(success: true, errorString: nil)
                    } else {
                        completionHandler(success: false, errorString: JSONResponseKeys.UserGetInfoError)
                    }
                }
            }
        }
    }
    
    // MARK: - Logging Out
    
    func logout(completionHandler: (success:Bool, errorString: String?) -> Void) {
        let request = NSMutableURLRequest(URL: NSURL(string: "https://www.udacity.com/api/session")!)
        request.HTTPMethod = "DELETE"
        var xsrfCookie: NSHTTPCookie? = nil
        let sharedCookieStorage = NSHTTPCookieStorage.sharedHTTPCookieStorage()
        for cookie in sharedCookieStorage.cookies as! [NSHTTPCookie] {
            if cookie.name == "XSRF-TOKEN" { xsrfCookie = cookie }
        }
        if let xsrfCookie = xsrfCookie {
            request.addValue(xsrfCookie.value!, forHTTPHeaderField: "X-XSRF-Token")
        }
        
        urlTask = taskForGETMethod(Methods.Logout, parameters: nil) {
            response, error in
            
            if let error = error {
                completionHandler(success: false, errorString: "Could not log out of Udacity: \(error.description)")
            } else {
                self.session.invalidateAndCancel()
                self.sessionID = nil
                self.userFirstName = nil
                self.userLastName = nil
                self.userID = nil
                
                completionHandler(success: true, errorString: nil)
            }
        }
    }
    
}
