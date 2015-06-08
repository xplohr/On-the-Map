//
//  AddLocationVCConvenience.swift
//  On The Map
//
//  Created by Che-Chuen Ho on 4/29/15.
//  Copyright (c) 2015 Che-Chuen Ho. All rights reserved.
//

import CoreLocation
import UIKit
import Foundation

extension AddLocationViewController {
    
    // MARK: - Geocoding methods
    
    func forwardGeocodeAddressString(addressString: String) {
        HUDView.sharedInstance().hudWithSpinner(self.view)
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(addressString) { placemarks, error in
            dispatch_async(dispatch_get_main_queue()) {
                HUDView.sharedInstance().hideHudView(self.view)
            }
            
            if (error != nil) {
                dispatch_async(dispatch_get_main_queue()) {
                    println("\(error): \(error.description)")
                    let alert = UIAlertView(title: "Location Error", message: "Unable to get your location. Please try again", delegate: nil, cancelButtonTitle: "OK")
                    alert.show()
                }
            } else if placemarks.count > 0 {
                let result = placemarks[0] as! CLPlacemark
                self.newLocation = result.location
                dispatch_async(dispatch_get_main_queue()) {
                    self.processNewLocation()
                }
            }
        }
    }
    
    // MARK: - Helper methods
    
    // Referece 1: http://blog.mattheworiordan.com/post/13174566389/url-regular-expression-for-links-with-or-without
    // Reference 2: http://www.raywenderlich.com/86205/nsregularexpression-swift-tutorial
    func urlIsValid(urlString: String?) -> Bool {
        
        if ((urlString) != nil) {
            var error: NSError? = nil
            
            let regex = NSRegularExpression(pattern: "((([A-Za-z]{3,9}:(?:\\/\\/)?)(?:[\\-;:&=\\+\\$,\\w]+@)?[A-Za-z0-9\\.\\-]+|(?:www\\.|[\\-;:&=\\+\\$,\\w]+@)[A-Za-z0-9\\.\\-]+)((?:\\/[\\+~%\\/\\.\\w\\-_]*)?\\??(?:[\\-\\+=&;%@\\.\\w_]*)#?(?:[\\.\\!\\/\\\\w]*))?)", options: NSRegularExpressionOptions.CaseInsensitive, error: &error)
            let matchRange = regex!.rangeOfFirstMatchInString(urlString!, options: nil, range: NSMakeRange(0, count(urlString!)))
            
            if matchRange.location != NSNotFound {
                return true
            }
        }
        
        return false
    }
}

// MARK: - UITextFieldDelegate
extension AddLocationViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        return false
    }
}