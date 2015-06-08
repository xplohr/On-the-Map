//
//  MoreVC-Extension.swift
//  On The Map
//
//  Created by Che-Chuen Ho on 6/7/15.
//  Copyright (c) 2015 Che-Chuen Ho. All rights reserved.
//

import UIKit
import FBSDKLoginKit

extension MoreViewController {
    
    func completeLogout() {
        
        UdacityClient.sharedInstance().logout {
            success, errorString in
            
            if let error = errorString {
                let alert = UIAlertView(title: "Logout Error", message: error, delegate: nil, cancelButtonTitle: "OK")
                alert.show()
            } else {
                ParseClient.sharedInstance().clearAllValues()
                dispatch_async(dispatch_get_main_queue()) {
                    FBSDKLoginManager().logOut()
                    self.performSegueWithIdentifier("unwindToLogin", sender: self)
                }
            }
        }
    }
}