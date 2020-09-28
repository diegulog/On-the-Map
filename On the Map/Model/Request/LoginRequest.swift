//
//  LoginRequest.swift
//  On the Map
//
//  Created by Diego on 24/09/2020.
//

import Foundation

struct LoginRequest: Codable {
    var udacity: Credentiales
    struct Credentiales: Codable {
        let username: String
        let password: String
    }

    init(username: String, password:String) {
        self.udacity = Credentiales(username: username, password: password)
    }

}

