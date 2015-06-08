//
//  LoginViewController.swift
//  On The Map
//
//  Created by Che-Chuen Ho on 4/7/15.
//  Copyright (c) 2015 Che-Chuen Ho. All rights reserved.
//

import Foundation
import UIKit
import FBSDKLoginKit

class LoginViewController: UIViewController, FBSDKLoginButtonDelegate {
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var fbLoginButton: FBSDKLoginButton!
    @IBOutlet weak var errorView: UIView!
    @IBOutlet weak var errorLabel: UILabel!
    
    var timer: NSTimer? = nil
    var gravity: UIGravityBehavior!
    var animator: UIDynamicAnimator!
    var collision: UICollisionBehavior!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        errorView.hidden = true
        fbLoginButton.readPermissions = ["public_profile"]
        fbLoginButton.delegate = self
        if (FBSDKAccessToken.currentAccessToken() != nil) {
            handleAuthenticateWithFacebook()
        }
    }
    
    override func viewWillDisappear(animated: Bool) {
        
        emailTextField.text = ""
        passwordTextField.text = ""
    }
    
    @IBAction func logoutDidComplete(segue: UIStoryboardSegue) {
        
    }
    
    @IBAction func loginTapped(sender: UIButton) {
        HUDView.sharedInstance().hudWithSpinner(self.view)
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        
        // Reference: http://stackoverflow.com/questions/27593290/why-is-performselector-not-present-in-swift
        timer = NSTimer.scheduledTimerWithTimeInterval(10 as NSTimeInterval, target: self, selector: "didTimeOut", userInfo: nil, repeats: false)
        
        UdacityClient.sharedInstance().authenticationWithUserPass(self.emailTextField.text, password: self.passwordTextField.text) {success, error in
            
            self.timer?.invalidate()
            
            dispatch_async(dispatch_get_main_queue()) {
                HUDView.sharedInstance().hideHudView(self.view)
                UIApplication.sharedApplication().networkActivityIndicatorVisible = false
            }
            
            if success {
                println("Login Success!")
                dispatch_async(dispatch_get_main_queue(), {
                    self.performSegueWithIdentifier("showTabView", sender: nil)
                })
            } else {
                println("Login Failure! \(error)")
                if error == UdacityClient.JSONResponseKeys.StatusBadCredentials || error == UdacityClient.JSONResponseKeys.StatusMissingCredentials {
                    dispatch_async(dispatch_get_main_queue(), {
                        self.showErrorDrop("Login Error!", body: "Could not log in. Please check the username and password and try again.")
                    })
                } else if error == UdacityClient.JSONResponseKeys.UserGetInfoError {
                    dispatch_async(dispatch_get_main_queue(), {
                        self.showErrorDrop("Login Error!", body: "Unable to retrieve user info.")
                    })
                } else if error == UdacityClient.JSONResponseKeys.SessionError {
                    dispatch_async(dispatch_get_main_queue(), {
                        self.showErrorDrop("Session Error!", body: "Unable to create session")
                    })
                } else {
                    dispatch_async(dispatch_get_main_queue(), {
                        self.showErrorDrop("Network Error!", body: "Could not reach website. Please check the network connection and try again.")
                    })
                }
            }
        }
    }
    
    func didTimeOut() {
        HUDView.sharedInstance().hideHudView(self.view)
        UIApplication.sharedApplication().networkActivityIndicatorVisible = false
        UdacityClient.sharedInstance().cancelURLTask()
    }
    
    // MARK: - Facebook login button methods
    
    func loginButton(loginButton: FBSDKLoginButton!, didCompleteWithResult result: FBSDKLoginManagerLoginResult!, error: NSError!) {
        
        handleAuthenticateWithFacebook()
    }
    
    func loginButtonDidLogOut(loginButton: FBSDKLoginButton!) {
        return
    }
    
    func handleAuthenticateWithFacebook() {
        UdacityClient.sharedInstance().authenticationWithFacebook() {
            success, error in
            
            if success {
                dispatch_async(dispatch_get_main_queue(), {
                    self.performSegueWithIdentifier("showTabView", sender: nil)
                })
            } else {
                dispatch_async(dispatch_get_main_queue(), {
                    FBSDKLoginManager().logOut()
                })
                if error == UdacityClient.JSONResponseKeys.UserGetInfoError {
                    UtilityMethods.showErrorAlert("Login Error", message: "Unable to retrieve user info")
                } else if error == UdacityClient.JSONResponseKeys.SessionError {
                    UtilityMethods.showErrorAlert("Session Error", message: "Unable to create session")
                } else {
                    UtilityMethods.showErrorAlert("Network Error", message: "Could not reach website. Please check the network connection and try again.")
                }
            }
        }
    }
    
    // MARK: - Touch events
    override func touchesEnded(touches: Set<NSObject>, withEvent event: UIEvent) {
        
        hideErrorDrop()
    }
    
}