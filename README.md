# PagarMe

### Installation with CocoaPods
    pod "PagarMe"

### How To

##### Add to `AppDelegate.m` - `didFinishLaunchingWithOptions`
```objc
[[PagarMe sharedInstance] setEncryptionKey:@"Your_PagarMe_EncryptionKey"];
```

##### Add to `AppDelegate.swift` - `didFinishLaunchingWithOptions`
```swift
PagarMe.sharedInstance()?.encryptionKey = "SUA ENCRYPTION KEY"
```
    
##### Usage
```objc
PagarMeCreditCard *pagarMeCreditCard = [[PagarMeCreditCard alloc] initWithCardNumber:@"4111111111111111" cardHolderName:@"Test Card" cardExpirationMonth:@"10" cardExpirationYear:@"20" cardCvv:@"123"];

if ([pagarMeCreditCard hasErrorCardNumber]) {
    // Error with CardNumber
}
else if ([pagarMeCreditCard hasErrorCardHolderName]) {
    // Error with CardHolderName
}
else if ([pagarMeCreditCard hasErrorCardCVV]) {
    // Error with CardCVV
}
else if ([pagarMeCreditCard hasErrorCardExpirationMonth]) {
    // Error with CardExpirationMonth
}
else if ([pagarMeCreditCard hasErrorCardExpirationYear]) {
    // Error with CardExpirationYear
}
else {
    // Validated all Fields!
    [pagarMeCreditCard generateHash:^(NSError *error, NSString *cardHash) {
        if(error) {
            NSLog(@"Error: %@", error);
            return;
        }
        NSLog(@"CardHash Generated: %@", cardHash);
    }];
}
```

```swift
let creditCard = PagarMeCreditCard(cardNumber: "4242424242424242", cardHolderName: "Test Card", cardExpirationMonth: "10", cardExpirationYear: "21", cardCvv: "123")
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
```

## Support
If you have any problem or suggestion please open an issue [here](https://github.com/pagarme/pagarme-ios/issues).

## License

Check [here](LICENSE).
