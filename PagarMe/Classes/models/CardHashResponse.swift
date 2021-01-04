//
//  CardHashResponse.swift
//  PagarMe
//
//  Created by Regis Araujo Melo on 01/01/21.
//

import Foundation

public struct CardHashResponse : Codable {
    let dateCreated: String
    let id: Int
    let ip: String
    let publicKey: String
    
    enum CodingKeys: String, CodingKey {
        case dateCreated
        case id
        case ip
        case publicKey
    }
}
