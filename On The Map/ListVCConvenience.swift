//
//  ListVCConvenience.swift
//  On The Map
//
//  Created by Che-Chuen Ho on 5/9/15.
//  Copyright (c) 2015 Che-Chuen Ho. All rights reserved.
//

import Foundation
import UIKit

// MARK: - TableView methods
extension ListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellReuseIdentifier = "locationCell"
        let location = ParseClient.sharedInstance().locations[indexPath.row]
        var cell = tableView.dequeueReusableCellWithIdentifier(cellReuseIdentifier) as! UITableViewCell
        
        cell.textLabel!.text = location.nameString
        cell.detailTextLabel!.text = location.mediaURL
        
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ParseClient.sharedInstance().locations.count
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        let location = ParseClient.sharedInstance().locations[indexPath.row]
        UIApplication.sharedApplication().openURL(NSURL(string: location.mediaURL!)!)
    }
    
    func tableView(tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        
        if section == 0 {
            return "\(ParseClient.sharedInstance().locations.count) of \(ParseClient.sharedInstance().totalStudentLocations) Locations Shown"
        }
        
        return nil
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        if section == 0 {
            return "\(ParseClient.sharedInstance().locations.count) of \(ParseClient.sharedInstance().totalStudentLocations) Locations Shown"
        }
        
        return nil
    }
}

// MARK: - Delegate methods
extension ListViewController: AddLocationViewControllerDelegate {
    func addLocationDidFinish(controller: AddLocationViewController) {
        loadStudentLocations()
    }
}