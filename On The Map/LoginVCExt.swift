//
//  LoginVCExt.swift
//  On The Map
//
//  Created by Che-Chuen Ho on 5/18/15.
//  Copyright (c) 2015 Che-Chuen Ho. All rights reserved.
//

import UIKit

// Reference: http://www.sitepoint.com/using-uikit-dynamics-swift-animate-apps/
extension LoginViewController {
    
    func showErrorDrop(title: String!, body: String?) {
        errorView.frame.origin.y = 0
        errorView.layer.cornerRadius = 5
        errorView.layer.masksToBounds = true
        errorLabel.text = title + " " + body!
        errorView.hidden = false
        
        animator = UIDynamicAnimator(referenceView: view)
        gravity = UIGravityBehavior(items: [errorView])
        animator.addBehavior(gravity)
        collision = UICollisionBehavior(items: [errorView])
        collision.translatesReferenceBoundsIntoBoundary = true
        
        let bottomBounds = view.frame.height - (view.frame.height / 3)
        collision.addBoundaryWithIdentifier("viewFloor", fromPoint: CGPointMake(0, bottomBounds), toPoint: CGPointMake(view.frame.width, bottomBounds))
        animator.addBehavior(collision)
    }
    
    func hideErrorDrop() {
        errorView.hidden = true
    }
}
