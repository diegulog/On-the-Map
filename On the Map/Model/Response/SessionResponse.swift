//
//  SessionResponse.swift
//  On the Map
//
//  Created by Diego on 24/09/2020.
//

import Foundation

struct SessionResponse: Codable {
    let account: Account
    let session: Session
}

struct Account: Codable {
    let registered : Bool
    let key : String
}
struct Session: Codable {
    let id: String
    let expiration: String
}
