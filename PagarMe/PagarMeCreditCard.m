//  PagarMeCreditCard.m
//  PagarMe
//
//  Created by Pedro Franceschi on 5/3/13.
//  Updated by Luciano Nascimento on 17/3/15.
//  Copyright (c) 2013 PagarMe. All rights reserved.
//

#import <AFNetworking/AFNetworking.h>

#import "PagarMeCreditCard.h"
#import "PagarMe.h"
#import "Luhn.h"
#import "PagarmeRSA.h"

@interface PagarMeCreditCard ()

@property (retain) NSString *cardNumber;
@property (retain) NSString *cardHolderName;
@property (retain) NSString *cardExpirationMonth;
@property (retain) NSString *cardExpirationYear;
@property (retain) NSString *cardCvv;
@property (copy) void (^callbackBlock)(NSError *error, NSString *cardHash);

@end

@implementation PagarMeCreditCard

#pragma mark Public methods
- (id)initWithCardNumber:(NSString *)cardNumber cardHolderName:(NSString *)cardHolderName cardExpirationMonth:(NSString *)cardExpirationMonth cardExpirationYear:(NSString *)cardExpirationYear cardCvv:(NSString *)cardCvv
{
    _cardNumber = cardNumber;
    _cardHolderName = cardHolderName;
    _cardExpirationMonth = cardExpirationMonth;
    _cardExpirationYear = cardExpirationYear;
    _cardCvv = cardCvv;

    return self;
}

- (BOOL)hasErrorCardNumber
{
    return (![_cardNumber isValidCreditCardNumber]) ? YES : NO;
}

- (BOOL)hasErrorCardHolderName
{
    return ([_cardHolderName length] <= 0) ? YES : NO;
}

- (BOOL)hasErrorCardExpirationMonth
{
    return ([_cardExpirationMonth intValue] <= 0 || [_cardExpirationMonth intValue] > 12) ? YES : NO;
}

- (BOOL)hasErrorCardExpirationYear
{
    // There is no official guideline as the credit card issuers can choose each when the cards they issue will expire.
    return NO;
}

- (BOOL)hasErrorCardCVV
{
    return ([_cardCvv length] < 3 || [_cardCvv length] > 4) ? YES : NO;
}

- (void)generateHash:(void (^)(NSError *error, NSString *cardHash))block
{
    _callbackBlock = block;
    
    NSString *url = [NSString stringWithFormat:@"%@/transactions/card_hash_key", API_ENDPOINT];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObject:[[PagarMe sharedInstance] encryptionKey] forKey:@"encryption_key"];
    
    [manager GET:url parameters:parameters progress:nil success:^(NSURLSessionTask *task, id responseObject) {
        
        NSArray *_id = [responseObject objectForKey:@"id"];
        NSString *publicKey = [responseObject objectForKey:@"public_key"];
        NSString *cardHashString = [self cardHashString];
        
        NSString *encryptedString = [PagarmeRSA encryptString:cardHashString publicKey:publicKey];
        
        _callbackBlock(nil, [NSString stringWithFormat:@"%@_%@", _id, encryptedString]);
        
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        _callbackBlock(error, nil);
    }];
}

#pragma mark Private methods
- (NSString *)cardHashString
{
    NSMutableArray *parameters = [[NSMutableArray alloc] init];
    [parameters addObject:[NSString stringWithFormat:@"card_number=%@", _cardNumber]];
    [parameters addObject:[NSString stringWithFormat:@"card_holder_name=%@", _cardHolderName]];
    [parameters addObject:[NSString stringWithFormat:@"card_expiration_date=%@%@", _cardExpirationMonth, _cardExpirationYear]];
    [parameters addObject:[NSString stringWithFormat:@"card_cvv=%@", _cardCvv]];

    return [parameters componentsJoinedByString:@"&"];
}

@end
