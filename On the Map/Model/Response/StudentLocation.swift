//
//  StudentLocation.swift
//  On the Map
//
//  Created by Diego on 24/09/2020.
//

import Foundation

struct StudentLocation: Codable {
    let createdAt: String?
    let firstName: String
    let lastName: String
    let latitude: Double
    let longitude: Double
    let mapString: String
    let mediaURL: String
    let objectId: String?
    let uniqueKey: String
    let updatedAt: String?
    
}
