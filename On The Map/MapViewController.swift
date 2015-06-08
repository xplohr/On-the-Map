//
//  MapViewController.swift
//  On The Map
//
//  Created by Che-Chuen Ho on 4/7/15.
//  Copyright (c) 2015 Che-Chuen Ho. All rights reserved.
//
//  References:
//      - http://www.raywenderlich.com/90971/introduction-mapkit-swift-tutorial

import UIKit
import MapKit
import Foundation

class MapViewController: UIViewController {

    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var locationCountLabel: UILabel!
    
    var timer: NSTimer? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
                
        let initialLocation = CLLocation(latitude: 39.833333, longitude: -98.583333)
        let regionRadius: CLLocationDistance = 750000
        centerMapOnLocation(initialLocation, radius: regionRadius)
    }
    
    override func viewWillAppear(animated: Bool) {
        
        loadStudentLocations()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func centerMapOnLocation(location: CLLocation, radius: CLLocationDistance) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate, radius * 2.0, radius * 2.0)
        mapView.setRegion(coordinateRegion, animated: true)
    }
    
    func loadStudentLocations() {
        HUDView.sharedInstance().hudWithSpinner(self.view)
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        timer = NSTimer.scheduledTimerWithTimeInterval(10 as NSTimeInterval, target: self, selector: "didTimeOut", userInfo: nil, repeats: false)
        
        ParseClient.sharedInstance().getStudentLocations() { success, error in
            self.timer?.invalidate()
            
            dispatch_async(dispatch_get_main_queue()) {
                HUDView.sharedInstance().hideHudView(self.view)
                UIApplication.sharedApplication().networkActivityIndicatorVisible = false
                
            }
            
            if success {
                dispatch_async(dispatch_get_main_queue()) {
                    self.showLocations()
                }
            } else {
                dispatch_async(dispatch_get_main_queue()) {
                    let alert = UIAlertView(title: "Error", message: "\(error!)", delegate: self, cancelButtonTitle: "OK")
                    alert.show()
                }
            }
        }
    }
    
    func showLocations() {
        if let annotations = mapView.annotations {
            mapView.removeAnnotations(annotations)
        }
        
        let studentLocations = ParseClient.sharedInstance().locations
        for location: StudentInformation in studentLocations {
            let pin = LocationPin(studentName: location.nameString, url: location.mediaURL, coord: location.coordinate)
            mapView.addAnnotation(pin)
        }
        
        updateLocationCount()
    }
    
    func updateLocationCount() {
        locationCountLabel.text = "\(ParseClient.sharedInstance().locations.count) of \(ParseClient.sharedInstance().totalStudentLocations) Locations Shown"
    }

    @IBAction func reloadButtonTapped(sender: AnyObject) {
        loadStudentLocations()
    }
    
    // Reference: http://stackoverflow.com/questions/24336187/how-to-present-a-modal-atop-the-current-view-in-swift
    @IBAction func addPinTapped(sender: AnyObject) {
        performSegueWithIdentifier("showAddPin", sender: nil)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showAddPin" {
            let destination = segue.destinationViewController as! AddLocationViewController
            destination.delegate = self
        }
    }
    
    func didTimeOut() {
        HUDView.sharedInstance().hideHudView(self.view)
        UIApplication.sharedApplication().networkActivityIndicatorVisible = false
        UtilityMethods.showErrorAlert("Network Error", message: "Could not reach website. Please check your network connection and try again.")
        ParseClient.sharedInstance().cancelURLTask()
    }
}

