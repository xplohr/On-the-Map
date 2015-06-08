//
//  ParseConvenience.swift
//  On The Map
//
//  Created by Che-Chuen Ho on 4/22/15.
//  Copyright (c) 2015 Che-Chuen Ho. All rights reserved.
//

import Foundation
import UIKit

extension ParseClient {
    
    func getStudentLocations(completionHandler: (success: Bool, errorString: String?) -> Void) {
        
        /******************************
         * Locations download strategy:
         * 1) Get the total count of records from the source
         * 2) Does the source count match totalStudentLocations?
         *      a) YES: Does locations.count == totalStudentLocations?
         *          i) YES: return success
         *          ii) NO: download next 100 records offset by locations.count
         *      b) NO: Clear locations and download a fresh source, then return success
         *****************************/
        
        var headers = [JSONKeys.CountRecords: 1, JSONKeys.LimitResults: 0]
        urlTask = taskForGETMethod(Methods.GetLocations, parameters: headers) {
            data, error in
            
            if let error = error {
                completionHandler(success: false, errorString: error.description)
            } else {
                let currentCount = data[JSONKeys.CountRecords] as! Int
                
                if self.totalStudentLocations == currentCount {
                    if self.locations.count == self.totalStudentLocations {
                        completionHandler(success: true, errorString: nil)
                    } else {
                        headers = [JSONKeys.SkipRecords: self.locations.count, JSONKeys.CountRecords: 1]
                        dispatch_async(dispatch_get_main_queue()) {
                            self.downloadLocations(headers, completionHandler: completionHandler)
                        }
                    }
                } else {
                    headers = [JSONKeys.CountRecords: 1]
                    self.locations.removeAll(keepCapacity: false)
                    dispatch_async(dispatch_get_main_queue()) {
                        self.downloadLocations(headers, completionHandler: completionHandler)
                    }
                }
            }
        }
        /*let headers = [ParseClient.JSONKeys.SkipRecords: Int(arc4random_uniform(10)), ParseClient.JSONKeys.CountRecords: 1]
        
        urlTask = taskForGETMethod(ParseClient.Methods.GetLocations, parameters: headers)  {
            data, error in
            
            if let error = error {
                completionHandler(success: false, errorString: error.description)
            } else {
                self.totalStudentLocations = data[JSONKeys.CountRecords] as! Int
                let sessionData = data[JSONKeys.Results] as! [[String: AnyObject]]
                
                if sessionData.count < 1 {
                    completionHandler(success: false, errorString: "No more records to retrieve")
                }
                
                self.locations.removeAll(keepCapacity: false)
                for location in sessionData {
                    let studentLocation = StudentInformation(values: location)
                    self.locations.append(studentLocation)
                }
                
                completionHandler(success: true, errorString: nil)
            }
        }*/
    }
    
    func downloadLocations(parameters: [String: AnyObject]?, completionHandler: (success: Bool, errorString: String?) -> Void) {
        
        urlTask = self.taskForGETMethod(Methods.GetLocations, parameters: parameters) {
            data, error in
            
            if let error = error {
                completionHandler(success: false, errorString: error.description)
            } else {
                self.totalStudentLocations = data[JSONKeys.CountRecords] as! Int
                let sessionData = data[JSONKeys.Results] as! [[String: AnyObject]]
                
                if sessionData.count < 1 {
                    completionHandler(success: true, errorString: nil)
                }
                
                for location in sessionData {
                    let studentLocation = StudentInformation(values: location)
                    self.locations.append(studentLocation)
                }
                
                completionHandler(success: true, errorString: nil)
            }
        }
    }
    
    func postStudentLocation(values: [String: AnyObject], completionHandler: (success: Bool, errorString: String?) -> Void) {
        
        urlTask = taskForPOSTMethod(ParseClient.Methods.PostLocation, parameters: values) { data, error in
            
            if let error = error {
                completionHandler(success: false, errorString: error.description)
            } else {
                completionHandler(success: true, errorString: nil)
            }
        }
    }
    
    func clearAllValues() {
        
        locations.removeAll(keepCapacity: false)
        totalStudentLocations = 0
        session.invalidateAndCancel()
    }
}