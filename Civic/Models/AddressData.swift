//
//  AddressData.swift
//  Civic
//
//  Created by Christopher M Moriarty on 1/14/22.
//

import Foundation

struct Address: Decodable{
    let address: String
    let city: String
    let state: String
    let zip: String
    
    func addressString() -> String{
        let array = [address, city, state, zip]
        var string = array.joined(separator: " ")
        return string.replacingOccurrences(of: " ", with: "%20")
    }
}
