//
//  PagarMe.swift
//  PagarMe
//
//  Created by Regis Araujo Melo on 31/12/20.
//

import Foundation

let API_ENDPOINT = "https://api.pagar.me/1"

public class PagarMe {
    
    public var encryptionKey: String?
    
    static var shared: PagarMe = {
        let instance = PagarMe()
        return instance
    }()

    class public func sharedInstance() -> PagarMe? {
        return shared
    }
    
    private init() {}
}

extension PagarMe: NSCopying {
    public func copy(with zone: NSZone? = nil) -> Any {
        return self
    }
}
