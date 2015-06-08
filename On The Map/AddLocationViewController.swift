//
//  AddLocationViewController.swift
//  On The Map
//
//  Created by Che-Chuen Ho on 4/29/15.
//  Copyright (c) 2015 Che-Chuen Ho. All rights reserved.
//

import Foundation
import UIKit
import MapKit

protocol AddLocationViewControllerDelegate {
    func addLocationDidFinish(controller: AddLocationViewController)
}

class AddLocationViewController: UIViewController {
    
    @IBOutlet weak var line1Label: UILabel!
    @IBOutlet weak var line2Label: UILabel!
    @IBOutlet weak var line3Label: UILabel!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var findButton: UIButton!
    @IBOutlet weak var urlTextField: UITextField!
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var previewButton: UIButton!
    @IBOutlet weak var nextButton: UIBarButtonItem!
    
    var newLocation: CLLocation? = nil
    var delegate: AddLocationViewControllerDelegate? = nil
    
    override func viewDidLoad() {
        showLocationFields()
        urlTextField.delegate = self
        nextButton.title = "Next"
    }
    
    @IBAction func nextButtonTapped(sender: UIBarButtonItem) {
        if sender.title == "Next" {
            findButtonTapped(sender)
        } else if sender.title == "Submit" {
            submitButtonTapped(sender)
        }
    }
    
    @IBAction func cancelButtonTapped(sender: UIBarButtonItem) {
        if ((self.delegate) != nil) {
            self.delegate!.addLocationDidFinish(self)
        }
        
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func findButtonTapped(sender: AnyObject) {
        textView.resignFirstResponder()
        if textView.text.isEmpty {
            let alert = UIAlertView(title: "Location Empty", message: "Please enter your location", delegate: nil, cancelButtonTitle: "OK")
            alert.show()
        } else {
            forwardGeocodeAddressString(textView.text)
        }
    }
    
    @IBAction func submitButtonTapped(sender: AnyObject) {
        urlTextField.resignFirstResponder()
        if (urlIsValid(urlTextField.text)) {
            var values = [String: AnyObject]()
            
            values[ParseClient.JSONKeys.UniqueKey] = UdacityClient.sharedInstance().userID
            values[ParseClient.JSONKeys.FirstName] = UdacityClient.sharedInstance().userFirstName
            values[ParseClient.JSONKeys.LastName] = UdacityClient.sharedInstance().userLastName
            values[ParseClient.JSONKeys.MapString] = textView.text
            values[ParseClient.JSONKeys.MediaURL] = urlTextField.text
            values[ParseClient.JSONKeys.Latitude] = newLocation?.coordinate.latitude
            values[ParseClient.JSONKeys.Longitude] = newLocation?.coordinate.longitude
            
            ParseClient.sharedInstance().postStudentLocation(values) { success, errorString in
                if let error = errorString {
                    dispatch_async(dispatch_get_main_queue()) {
                        let alert = UIAlertView(title: "Could not post location", message: "Attempt to post your location failed with \(error)", delegate: nil, cancelButtonTitle: "OK")
                        alert.show()
                    }
                } else {
                    if ((self.delegate) != nil) {
                        dispatch_async(dispatch_get_main_queue()) {
                            self.delegate!.addLocationDidFinish(self)
                        }
                    }
                    
                    self.dismissViewControllerAnimated(true, completion: nil)
                }
            }
        } else {
            let alert = UIAlertView(title: "Invalid URL", message: "Please enter a valid URL", delegate: nil, cancelButtonTitle: "OK")
            alert.show()
        }
    }
    
    @IBAction func previewMedia(sender: UIButton) {
        if urlIsValid(urlTextField.text) {
            UIApplication.sharedApplication().openURL(NSURL(string: urlTextField.text)!)
        } else {
            UtilityMethods.showErrorAlert("Invalid URL", message: "Please enter a valid URL.")
        }
    }
    
    // MARK: - MapKit functions
    
    func centerMapOnLocation(location: CLLocation, radius: CLLocationDistance) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate, radius * 2.0, radius * 2.0)
        mapView.setRegion(coordinateRegion, animated: true)
    }
    
    func processNewLocation() {
        let pin = LocationPin(studentName: textView.text, url: nil, coord: newLocation!.coordinate)
        mapView.addAnnotation(pin)
        centerMapOnLocation(newLocation!, radius: 500 as CLLocationDistance)
        showMediaFields()
    }
    
    // MARK: - Helper functions
    
    func showLocationFields() {
        line1Label.hidden = false
        line2Label.hidden = false
        line3Label.hidden = false
        textView.hidden = false
        findButton.hidden = false
        urlTextField.hidden = true
        submitButton.hidden = true
        mapView.hidden = true
        previewButton.hidden = true
        nextButton.title = "Next"
    }
    
    func showMediaFields() {
        line1Label.hidden = true
        line2Label.hidden = true
        line3Label.hidden = true
        textView.hidden = true
        findButton.hidden = true
        urlTextField.hidden = false
        submitButton.hidden = false
        mapView.hidden = false
        previewButton.hidden = false
        nextButton.title = "Submit"
    }
    
}