//
//  HUDview.swift
//  On The Map
//
//  Created by Che-Chuen Ho on 5/25/15.
//  Copyright (c) 2015 Che-Chuen Ho. All rights reserved.
//

import UIKit

class HUDView: UIView {
    class func sharedInstance() -> HUDView {
    
        struct Singleton {
            static var sharedInstance = HUDView()
        }
        
        return Singleton.sharedInstance
    }
    
    func hudWithSpinner(view: UIView) {
        var hud = HUDView(frame: view.frame)
        hud.userInteractionEnabled = false
        hud.backgroundColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.25)
        
        var spinner = UIActivityIndicatorView(activityIndicatorStyle: .WhiteLarge)
        spinner.hidesWhenStopped = false
        spinner.hidden = false
        spinner.startAnimating()
        spinner.frame.origin = CGPointMake((hud.frame.size.width / 2) - (spinner.frame.size.width / 2), (hud.frame.size.height / 2) - (spinner.frame.size.height / 2))
        hud.addSubview(spinner)
        
        view.addSubview(hud)
    }
    
    func hideHudView(view: UIView) {
        for subview in view.subviews {
            if subview.isKindOfClass(HUDView) {
                subview.removeFromSuperview()
            }
        }
    }
}
