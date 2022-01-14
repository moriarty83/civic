//
//  RepsData.swift
//  Civic
//
//  Created by Christopher M Moriarty on 1/13/22.
//

import Foundation

struct Office: Decodable{
    let name: String
    let divisionId: String
    let levels: Array<String>
    let roles: Array<String>
    let officialIndices: Array<Int>
}

struct Official: Decodable{
    let name: String
    let party: String
    let photoUrl: String?
    let channels: Array<SocialChannel>?
}

struct SocialChannel: Decodable{
    let type: String
    let id: String
}

struct Division: Decodable{
    let name: String
    let officeIndices: Array<Int>?
}

struct RepsData: Decodable{
    let offices: Array<Office>
    let divisions: Dictionary<String, Division>
    let officials: Array<Official>
}
