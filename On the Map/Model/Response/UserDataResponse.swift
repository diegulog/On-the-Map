//
//  UserDataResponse.swift
//  On the Map
//
//  Created by Diego on 25/09/2020.
//

import Foundation

struct UserDataResponse: Codable {
    let user: UserModel
}

struct UserModel: Codable {
    var firstName: String
    var lastName: String
    var uniqueKey: String
    enum CodingKeys: String, CodingKey {
        case firstName = "first_name"
        case lastName = "last_name"
        case uniqueKey = "key"
        
    }
    
}
