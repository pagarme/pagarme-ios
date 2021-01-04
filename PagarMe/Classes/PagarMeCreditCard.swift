//
//  PagarMeCreditCard.swift
//  PagarMe
//
//  Created by Regis Araujo Melo on 31/12/20.
//

import Foundation
import SwiftLuhn

public class PagarMeCreditCard {
    
    var cardNumber: String?
    var cardHolderName: String?
    var cardExpirationMonth: String?
    var cardExpirationYear: String?
    var cardCvv: String?
    var callbackBlock: ((_ error: Error?, _ cardHash: String?) -> Void)?
    private var cardHashResponse: CardHashResponse?
    
    // MARK: Public methods
    public convenience init(cardNumber: String?, cardHolderName: String?, cardExpirationMonth: String?, cardExpirationYear: String?, cardCvv: String?) {
        self.init()
        self.cardNumber = cardNumber
        self.cardHolderName = cardHolderName
        self.cardExpirationMonth = cardExpirationMonth
        self.cardExpirationYear = cardExpirationYear
        self.cardCvv = cardCvv
        
    }
    
    public func hasErrorCardNumber() -> Bool {
        guard let card = self.cardNumber else {
            print("You didn't provide a cardNumber!")
            return false
        }
        return card.isValidCardNumber() ? false : true
    }
    
    public func hasErrorCardHolderName() -> Bool {
        return ((cardHolderName?.count ?? 0) <= 0) ? true : false
    }
    
    public func hasErrorCardExpirationMonth() -> Bool {
        return (Int(cardExpirationMonth ?? "") ?? 0 <= 0 || Int(cardExpirationMonth ?? "") ?? 0 > 12) ? true : false
    }
    
    public func hasErrorCardExpirationYear() -> Bool {
        // There is no official guideline as the credit card issuers can choose each when the cards they issue will expire.
        return false
    }
    
    public func hasErrorCardCVV() -> Bool {
        return ((cardCvv?.count ?? 0) < 3 || (cardCvv?.count ?? 0) > 4) ? true : false
    }
    
    
    public func generateHash(_ block: @escaping (_ error: Error?, _ cardHash: String?) -> Void) {
        
        let semaphore = DispatchSemaphore (value: 0)
        
        callbackBlock = block
        
        CardHashServices.shared.fetchCardHash(from: .card_hash_key) { (result: Result<CardHashResponse, CardHashServices.APIServiceError>) in
            switch result {
            case .success(let response):
                self.cardHashResponse = response
                let cardHashString = self.cardHashString()
                self.callbackBlock!(nil, cardHashString)
            case .failure(let error):
                print(error.localizedDescription)
                self.callbackBlock!(error, "")
            }
        }
        
        semaphore.wait()
    }
    
    private func clearPublicKey() -> String {
        var key = self.cardHashResponse!.publicKey
        let spos = (key as NSString?)?.range(of: "-----BEGIN PUBLIC KEY-----")
        let epos = (key as NSString?)?.range(of: "-----END PUBLIC KEY-----")
        if spos?.location != NSNotFound && epos?.location != NSNotFound {
            let s = (spos?.location ?? 0) + (spos?.length ?? 0)
            let e = epos?.location ?? 0
            let range = NSRange(location: s, length: e - s)
            key = ((key as NSString?)?.substring(with: range))!
        }
        key = (key.replacingOccurrences(of: "\r", with: ""))
        key = (key.replacingOccurrences(of: "\n", with: ""))
        key = (key.replacingOccurrences(of: "\t", with: ""))
        key = (key.replacingOccurrences(of: " ", with: ""))
        return key
    }
    
    func cardHashString() -> String? {
        
        var param: [URLQueryItem] = []
        param.append(URLQueryItem(name: "card_number", value: cardNumber))
        param.append(URLQueryItem(name: "card_holder_name", value: cardHolderName))
        param.append(URLQueryItem(name: "card_expiration_date", value: "\(String(cardExpirationMonth!))\(String(cardExpirationYear!))"))
        param.append(URLQueryItem(name: "card_cvv", value: cardCvv))
        
        var components = URLComponents()
        components.queryItems = param
        
        let unEncryptText = components.description.replacingOccurrences(of: "?", with: "")
        let publicKey = clearPublicKey()
        
        guard let textData = unEncryptText.data(using: String.Encoding.utf8) else { return nil }
        let encryptedData = RSAWrapper.encryptWithRSAPublicKey(textData, pubkeyBase64: publicKey, keychainTag: "teste")
        guard encryptedData != nil else { return nil }
        let encryptedDataText = encryptedData!.base64EncodedString(options: NSData.Base64EncodingOptions())
        
        guard let id = self.cardHashResponse?.id else {
            return nil
        }
        return "\(id)_\(encryptedDataText)"
        
    }
}
