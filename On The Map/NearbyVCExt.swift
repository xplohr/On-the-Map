//
//  NearbyVCExt.swift
//  On The Map
//
//  Created by Che-Chuen Ho on 5/22/15.
//  Copyright (c) 2015 Che-Chuen Ho. All rights reserved.
//

import UIKit
import CoreLocation

// MARK: - Core Location
extension NearbyViewController: CLLocationManagerDelegate {
    // Reference: http://nshipster.com/core-location-in-ios-8/
    
    func getNearbyLocations() {
        
        if CLLocationManager.locationServicesEnabled() == false {
            showLocationError()
        } else {
            let status = CLLocationManager.authorizationStatus()
            if CLLocationManager.authorizationStatus() == .NotDetermined {
                clManager.requestWhenInUseAuthorization()
            } else if CLLocationManager.authorizationStatus() == .AuthorizedWhenInUse {
                clManager.startUpdatingLocation()
                processLocations()
            }
        }
    }
    
    func showLocationError() {
        let alertController = UIAlertController(title: "Location Access Disabled", message: "In order to discover nearby student pins, please open this app's Settings and set location access to 'While Using the App'.", preferredStyle: .Alert)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
        alertController.addAction(cancelAction)
        
        let openAction = UIAlertAction(title: "Open App Settings", style: .Default) {
            (action) in
            
            if let url = NSURL(string: UIApplicationOpenSettingsURLString) {
                UIApplication.sharedApplication().openURL(url)
            }
        }
        alertController.addAction(openAction)
        
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    func processLocations() {
        HUDView.sharedInstance().hudWithSpinner(self.view)
        nearbyLocations.removeAll(keepCapacity: false)
        
        let userLocation = clManager.location
        if userLocation == nil {
            showLocationError()
            return
        }
        
        for pin in ParseClient.sharedInstance().locations {
            if pin.latitude != nil && pin.longitude != nil {
                let distance = userLocation.distanceFromLocation(CLLocation(latitude: pin.latitude!, longitude: pin.longitude!))
                if distance <= nearbyRadius {
                    nearbyLocations += [pin]
                }
            }
        }
        
        HUDView.sharedInstance().hideHudView(self.view)
    }
    
    // MARK: - CLLocationManagerDelegate Methods
    func locationManager(manager: CLLocationManager!, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        
        if status == .AuthorizedWhenInUse {
            clManager.startUpdatingLocation()
            processLocations()
        }
    }
}

// MARK: - TableView Methods
extension NearbyViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cellReuseIdentifier = "locationCell"
        let location = nearbyLocations[indexPath.row]
        var cell = tableView.dequeueReusableCellWithIdentifier(cellReuseIdentifier) as! UITableViewCell
        
        cell.textLabel!.text = location.nameString
        cell.detailTextLabel!.text = location.mediaURL
        
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return nearbyLocations.count
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        let location = nearbyLocations[indexPath.row]
        UIApplication.sharedApplication().openURL(NSURL(string: location.mediaURL!)!)
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        switch section {
        case 0:
            return "Student Locations Within 100 Miles"
            
        default:
            return ""
        }
    }
    
    func tableView(tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        
        if section == 0 {
            return "\(ParseClient.sharedInstance().locations.count) of \(ParseClient.sharedInstance().totalStudentLocations) Locations Shown"
        }
        
        return nil
    }
}

// MARK: - AddLocationViewControllerDelegate Methods
extension NearbyViewController: AddLocationViewControllerDelegate {
    func addLocationDidFinish(controller: AddLocationViewController) {
        getNearbyLocations()
    }
}
