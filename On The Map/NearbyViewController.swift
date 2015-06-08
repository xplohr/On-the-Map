//
//  NearbyViewController.swift
//  On The Map
//
//  Created by Che-Chuen Ho on 5/20/15.
//  Copyright (c) 2015 Che-Chuen Ho. All rights reserved.
//

import UIKit
import CoreLocation

class NearbyViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    var nearbyLocations = [StudentInformation]()
    var clManager = CLLocationManager()
    let nearbyRadius = 160934.0 // 100 miles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        clManager.delegate = self
    }
    
    override func viewWillDisappear(animated: Bool) {
        clManager.stopUpdatingLocation()
    }
    
    override func viewWillAppear(animated: Bool) {
        dispatch_async(dispatch_get_main_queue()) {
            self.getNearbyLocations()
        }
    }
    
    @IBAction func refreshLocationsTapped(sender: UIBarButtonItem) {
        getNearbyLocations()
    }
    
    @IBAction func addLocationTapped(sender: UIBarButtonItem) {
        performSegueWithIdentifier("showAddPin", sender: self)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "showAddPin" {
            let controller = segue.destinationViewController as! AddLocationViewController
            controller.delegate = self
        }
    }
}
