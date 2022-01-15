//
//  RepsData.swift
//  Civic
//
//  Created by Christopher M Moriarty on 1/15/22.
//

import Foundation

struct RepData{
    let name: String
    let divisionName: String
    let officeName: String
    let party: String
    let photoUrl: String?
    let socialMedia: Array<SocialMedia>
}


struct SocialMedia{
    let type: String
    let id: String
}

struct OfficeData{
    let name: String
    let divisionName: String
}

