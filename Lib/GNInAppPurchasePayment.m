//
//  GNInAppPurchasePayment.m
//  GNInAppPurchaseManager
//
//  Created by Jakub Knejzlik on 18/03/15.
//  Copyright (c) 2015 Jakub Knejzlik. All rights reserved.
//

#import "GNInAppPurchasePayment.h"

@interface GNInAppPurchasePayment () <SKPaymentTransactionObserver>
@property (nonatomic,strong) NSString *transactionIdentifier;
@property (nonatomic,strong) SKPaymentTransaction *transaction;
@end

@implementation GNInAppPurchasePayment

-(instancetype)initWithProduct:(SKProduct *)product quantity:(NSInteger)quantity{
    self = [super init];
    if (self) {
        SKMutablePayment *payment = [SKMutablePayment paymentWithProduct:product];
        payment.quantity = quantity;
        self.payment = payment;
        [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
    }
    return self;
}

-(void)dealloc{
    [[SKPaymentQueue defaultQueue] removeTransactionObserver:self];
}

-(void)start{
    [[SKPaymentQueue defaultQueue] addPayment:self.payment];
}

#pragma mark - Payment Transaction Observing

-(void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions{
    for (SKPaymentTransaction *transaction in transactions) {
//        NSLog(@"%@ == %@ %i",transaction.payment.productIdentifier,self.payment.productIdentifier,transaction.transactionState);
        if (!self.transaction && [transaction.payment.productIdentifier isEqualToString:self.payment.productIdentifier]) {
            self.transaction = transaction;
        }
        if (self.transaction == transaction) {
            switch (transaction.transactionState) {
                case SKPaymentTransactionStatePurchased:
                    self.success();
                    break;
                case SKPaymentTransactionStateFailed:
                    self.failure(transaction.error);
                    break;
                default:
                    break;
            }
        }
    }
}

-(void)paymentQueue:(SKPaymentQueue *)queue removedTransactions:(NSArray *)transactions{
    
}


@end
