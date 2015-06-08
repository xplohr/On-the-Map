//
//  LocationPin.swift
//  On The Map
//
//  Created by Che-Chuen Ho on 4/27/15.
//  Copyright (c) 2015 Che-Chuen Ho. All rights reserved.
//

import Foundation
import MapKit

class LocationPin: NSObject, MKAnnotation {
    let name: String
    let link: String?
    let coordinate: CLLocationCoordinate2D
    
    init(studentName: String, url: String?, coord: CLLocationCoordinate2D) {
        name = studentName
        link = url
        coordinate = coord
        
        super.init()
    }
    
    var title: String {
        return name
    }
    
    var subtitle: String {
        if (link != nil) {
            return link!
        }
        
        return ""
    }
}
