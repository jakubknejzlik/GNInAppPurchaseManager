//
//  GNInAppRestoreRequest.m
//  GNInAppPurchaseManager
//
//  Created by Jakub Knejzlik on 19/03/15.
//  Copyright (c) 2015 Jakub Knejzlik. All rights reserved.
//

#import "GNInAppRestoreRequest.h"

#import <StoreKit/StoreKit.h>

@interface GNInAppRestoreRequest () <SKPaymentTransactionObserver>
@end

@implementation GNInAppRestoreRequest

-(instancetype)init{
    self = [super init];
    if (self) {
        [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
    }
    return self;
}


-(void)dealloc{
    [[SKPaymentQueue defaultQueue] removeTransactionObserver:self];
}

-(void)start{
    [[SKPaymentQueue defaultQueue] restoreCompletedTransactions];
}


#pragma mark - PaymentQueue Delegate Methods
-(void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions{
    //noop
}
-(void)paymentQueueRestoreCompletedTransactionsFinished:(SKPaymentQueue *)queue{
    self.success();
}
-(void)paymentQueue:(SKPaymentQueue *)queue restoreCompletedTransactionsFailedWithError:(NSError *)error{
    self.failure(error);
}

@end
