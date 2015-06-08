//
//  ListViewController.swift
//  On The Map
//
//  Created by Che-Chuen Ho on 4/15/15.
//  Copyright (c) 2015 Che-Chuen Ho. All rights reserved.
//

import Foundation
import UIKit

class ListViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    var timer: NSTimer? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //loadStudentLocations()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        loadStudentLocations()
        tableView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func loadStudentLocations() {
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        HUDView.sharedInstance().hudWithSpinner(self.view)
        timer = NSTimer.scheduledTimerWithTimeInterval(10 as NSTimeInterval, target: self, selector: "didTimeOut", userInfo: nil, repeats: false)
        
        ParseClient.sharedInstance().getStudentLocations() { success, error in
            UIApplication.sharedApplication().networkActivityIndicatorVisible = false
            self.timer?.invalidate()
            dispatch_async(dispatch_get_main_queue()) {
                HUDView.sharedInstance().hideHudView(self.view)
            }
            
            if success {
                dispatch_async(dispatch_get_main_queue()) {
                    self.tableView.reloadData()
                }
            } else {
                dispatch_async(dispatch_get_main_queue()) {
                    let alert = UIAlertView(title: "Error", message: "\(error!)", delegate: self, cancelButtonTitle: "OK")
                    alert.show()
                }
            }
        }
    }
    
    @IBAction func addPinTapped(sender: UIBarButtonItem) {
        performSegueWithIdentifier("showAddPin", sender: self)
    }
    
    @IBAction func reloadButtonTapped(sender: UIBarButtonItem) {
        loadStudentLocations()
        tableView.reloadData()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showAddPin" {
            let destination = segue.destinationViewController as! AddLocationViewController
            destination.delegate = self
        }
    }
    
    func didTimeOut() {
        UIApplication.sharedApplication().networkActivityIndicatorVisible = false
        HUDView.sharedInstance().hideHudView(self.view)
        UtilityMethods.showErrorAlert("Network Error", message: "Could not reach website. Please check your network connection and try again.")
        ParseClient.sharedInstance().cancelURLTask()
    }
    
}
