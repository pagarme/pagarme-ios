//
//  ViewController.swift
//  PagarMe
//
//  Created by regis@r3tecnologia.net on 12/31/2020.
//  Copyright (c) 2020 regis@r3tecnologia.net. All rights reserved.
//

import UIKit
import PagarMe

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let creditCard = PagarMeCreditCard(cardNumber: "5162305427988883", cardHolderName: "Test Card", cardExpirationMonth: "10", cardExpirationYear: "21", cardCvv: "123")
        if creditCard.hasErrorCardNumber() {
            // Error with CardNumber
            print("Error with CardNumber")
        } else if creditCard.hasErrorCardHolderName() {
            // Error with CardHolderName
            print("Error with CardHolderName")
        } else if creditCard.hasErrorCardCVV() {
            // Error with CardCVV
            print("Error with CardCVV")
        } else if creditCard.hasErrorCardExpirationMonth() {
            // Error with CardExpirationMonth
            print("Error with CardExpirationMonth")
        } else if creditCard.hasErrorCardExpirationYear() {
            // Error with CardExpirationYear
            print("Error with CardExpirationYear")
        } else {
            creditCard.generateHash({ (error, cardHash) -> Void in
                if (error != nil) {
                    print("erro = \(error.debugDescription)")
                } else {
                    print(cardHash!)
                }
            })
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

