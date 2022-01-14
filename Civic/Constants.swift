//
//  Constants.swift
//  Civic
//
//  Created by Christopher M Moriarty on 1/12/22.
//
import Foundation

struct K {
    static let loginSegue = "loginToCivic"
    
    struct Reps {
        static let api_key = Bundle.main.infoDictionary?["CIVIC_KEY"] as? String
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
