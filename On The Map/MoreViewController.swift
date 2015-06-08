//
//  MoreViewController.swift
//  On The Map
//
//  Created by Che-Chuen Ho on 6/6/15.
//  Copyright (c) 2015 Che-Chuen Ho. All rights reserved.
//

import UIKit

class MoreViewController: UITableViewController {
    
    override func viewWillAppear(animated: Bool) {
        tableView.reloadData()
    }
    
    @IBAction func logoutUser(sender: AnyObject) {
        let alert = UIAlertView(title: "Confirm Logout", message: "This action will clear all data and log out the current user. Do you want to continue?", delegate: self, cancelButtonTitle: "No", otherButtonTitles: "Yes")
        alert.show()
    }
    
    // MARK: - Table View methods
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("infoCell") as! UITableViewCell
        
        switch indexPath.row {
        case 0:
            cell.textLabel?.text = "Student"
            cell.detailTextLabel?.text = "\(UdacityClient.sharedInstance().userFirstName!) \(UdacityClient.sharedInstance().userLastName!)"
            
        case 1:
            cell.textLabel?.text = "Student ID"
            cell.detailTextLabel?.text = "\(UdacityClient.sharedInstance().userID!)"
            
        case 2:
            cell.textLabel?.text = "Total Number of Locations"
            cell.detailTextLabel?.text = "\(ParseClient.sharedInstance().totalStudentLocations)"
            
        case 3:
            cell.textLabel?.text = "Number of Locations Downloaded"
            cell.detailTextLabel?.text = "\(ParseClient.sharedInstance().locations.count)"
            
        default:
            break
        }
        
        return cell
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 4
    }
    
}