//
//  ParseConstants.swift
//  On The Map
//
//  Created by Che-Chuen Ho on 4/20/15.
//  Copyright (c) 2015 Che-Chuen Ho. All rights reserved.
//

extension ParseClient {
    
    // MARK: - Constants
    struct Constants {
    
        static let BaseURL = "https://api.parse.com/1/classes/"
        static let ParseAppID = "QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr"
        static let ParseAppIDHeader = "X-Parse-Application-Id"
        static let ParseRestKey = "QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY"
        static let ParseRestKeyHeader = "X-Parse-REST-API-Key"
    }
    
    // MARK: - Methods
    struct Methods {
    
        static let GetLocations = "StudentLocation"
        static let PostLocation = "StudentLocation"
    }
    
    // MARK: - JSON Keys
    struct JSONKeys {
    
        static let Results = "results"
        static let CreateDate = "createdAt"
        static let FirstName = "firstName"
        static let LastName = "lastName"
        static let Latitude = "latitude"
        static let Longitude = "longitude"
        static let MapString = "mapString"
        static let MediaURL = "mediaURL"
        static let ObjectID = "objectId"
        static let UniqueKey = "uniqueKey"
        static let UpdatedDate = "updatedAt"
        static let CountRecords = "count"
        static let LimitResults = "limit"
        static let SkipRecords = "skip"
    }
}