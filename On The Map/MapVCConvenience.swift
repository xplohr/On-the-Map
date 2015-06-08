//
//  MapVCConvenience.swift
//  On The Map
//
//  Created by Che-Chuen Ho on 4/27/15.
//  Copyright (c) 2015 Che-Chuen Ho. All rights reserved.
//

import Foundation
import MapKit

extension MapViewController: MKMapViewDelegate {

    func mapView(mapView: MKMapView!, viewForAnnotation annotation: MKAnnotation!) -> MKAnnotationView! {
        if let annotation = annotation as? LocationPin {
            let identifier = "pin"
            var view: MKPinAnnotationView
            if let dequeedView = mapView.dequeueReusableAnnotationViewWithIdentifier(identifier) as? MKPinAnnotationView {
                dequeedView.annotation = annotation
                view = dequeedView
            } else {
                view = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
                view.canShowCallout = true
                view.calloutOffset = CGPoint(x: -5, y: 5)
                view.rightCalloutAccessoryView = UIButton.buttonWithType(UIButtonType.DetailDisclosure) as! UIView
            }
            
            return view
        }
        
        return nil
    }
    
    func mapView(mapView: MKMapView!, annotationView view: MKAnnotationView!, calloutAccessoryControlTapped control: UIControl!) {
        let pinData = view.annotation as! LocationPin
        UIApplication.sharedApplication().openURL(NSURL(string: pinData.link!)!)
    }
}

extension MapViewController: AddLocationViewControllerDelegate {
    func addLocationDidFinish(controller: AddLocationViewController) {
        loadStudentLocations()
    }
}
