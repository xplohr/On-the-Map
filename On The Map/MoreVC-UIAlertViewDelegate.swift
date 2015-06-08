//
//  MoreVC-UIAlertViewDelegate.swift
//  On The Map
//
//  Created by Che-Chuen Ho on 6/7/15.
//  Copyright (c) 2015 Che-Chuen Ho. All rights reserved.
//

import UIKit

extension MoreViewController: UIAlertViewDelegate {
    
    func alertView(alertView: UIAlertView, didDismissWithButtonIndex buttonIndex: Int) {
        
        if buttonIndex == 1 {
            completeLogout()
        }
    }
}