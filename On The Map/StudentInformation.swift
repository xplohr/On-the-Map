//
//  StudentInformation.swift
//  On The Map
//
//  Created by Che-Chuen Ho on 4/16/15.
//  Copyright (c) 2015 Che-Chuen Ho. All rights reserved.
//

import Foundation
import MapKit

struct StudentInformation {
    var objectID: String? = nil
    var firstName: String? = nil
    var lastName: String? = nil
    var mapString: String? = nil
    var mediaURL: String? = nil
    var latitude: Double? = nil
    var longitude: Double? = nil
    
    init(values: Dictionary<String, AnyObject>) {
        objectID = values[ParseClient.JSONKeys.ObjectID] as? String
        firstName = values[ParseClient.JSONKeys.FirstName] as? String
        lastName = values[ParseClient.JSONKeys.LastName] as? String
        mapString = values[ParseClient.JSONKeys.MapString] as? String
        mediaURL = values[ParseClient.JSONKeys.MediaURL] as? String
        latitude = values[ParseClient.JSONKeys.Latitude] as? Double
        longitude = values[ParseClient.JSONKeys.Longitude] as? Double
    }
    
    var nameString: String {
        var name = ""
        
        if firstName != nil {
            name += firstName!
        }
        
        if lastName != nil {
            name += " " + lastName!
        }
        
        return name
    }
    
    var coordinate: CLLocationCoordinate2D {
        if latitude != nil && longitude != nil {
            return CLLocationCoordinate2D(latitude: latitude!, longitude: longitude!)
        }
        
        return CLLocationCoordinate2D(latitude: 0, longitude: 0)
    }
}
