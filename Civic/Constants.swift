//
//  Constants.swift
//  Civic
//
//  Created by Christopher M Moriarty on 1/12/22.
//
import Foundation
import UIKit
import BTNavigationDropdownMenu

struct K {
    static let loginSegue = "loginToCivic"
    
    static var userAddressString = ""

    
    struct Reps {
        static let api_key = Bundle.main.infoDictionary?["CIVIC_KEY"] as? String
    }
    
    struct Auth{
        static var loggedIn = false
    }
    
    struct FStore {
        
        static let collectionName = "addresses"
        static let userIdField = "user_id"
        static let addressField = "address"
        static let cityField = "city"
        static let stateField = "state"
        static let zipField = "zip"
        
    }
    
    
}
