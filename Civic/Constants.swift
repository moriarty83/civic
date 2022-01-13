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
}
