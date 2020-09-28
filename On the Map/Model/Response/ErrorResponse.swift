//
//  ErrorResponse.swift
//  On the Map
//
//  Created by Diego on 24/09/2020.
//

import Foundation

class ErrorResponse: Codable {
    let statusCode: Int
    let error: String
    
    enum CodingKeys: String, CodingKey {
        case statusCode = "status"
        case error
    }
}

extension ErrorResponse: LocalizedError {
    var errorDescription: String? {
        return error
    }
}
