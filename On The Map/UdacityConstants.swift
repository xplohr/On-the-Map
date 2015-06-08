//
//  UdacityConstants.swift
//  On The Map
//
//  Created by Che-Chuen Ho on 4/8/15.
//  Copyright (c) 2015 Che-Chuen Ho. All rights reserved.
//

extension UdacityClient {
    
    // MARK: - Constants
    struct Constants {
    
        static let BaseURL: String = "https://www.udacity.com/api/"
    }
    
    // MARK: - Methods
    struct Methods {
    
        // MARK: Session
        static let SessionCreate = "session"
        
        // MARK: User
        static let UserData = "users/{userID}"
        
        // MARK: Authentication
        static let FacebookAuth = "session"
        
        // MARK: Logout
        static let Logout = "DELETE"
    }
    
    // MARK: - URL Keys
    struct URLKeys {
    
        static let UserID = "userID"
    }
    
    // MARK: - Parameter Keys
    struct ParameterKeys {
    
        static let ParameterDictionaryName = "udacity"
        static let Username = "username"
        static let Password = "password"
    }
    
    struct FacebookKeys {
    
        static let FacebookDictionaryName = "facebook_mobile"
        static let accessToken = "access_token"
    }
    
    // MARK: - JSON Response Keys
    struct JSONResponseKeys {
        
        // MARK: Status
        static let Status = "status"
        static let StatusMessage = "status_message"
        static let StatusMissingCredentials = "400"
        static let StatusBadCredentials = "403"
        
        // MARK: Account
        static let Account = "account"
        static let AccountRegistered = "registered"
        static let AccountKey = "key"
        
        // MARK: Session
        static let Session = "session"
        static let SessionID = "id"
        static let SessionExpiration = "expiration"
        static let SessionError = "450"
        
        // MARK: User Data
        static let User = "user"
        static let UserLastName = "last_name"
        static let UserFirstName = "first_name"
        static let UserWebsite = "website_url"
        static let UserLocation = "location"
        static let UserGetInfoError = "500"
    }
}
