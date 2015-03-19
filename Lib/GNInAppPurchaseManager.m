//
//  GNInAppPurchaseManager.m
//  GNInAppPurchaseManager
//
//  Created by Jakub Knejzlik on 18/03/15.
//  Copyright (c) 2015 Jakub Knejzlik. All rights reserved.
//

#import "GNInAppPurchaseManager.h"

#import "GNInAppProductsRequest.h"
#import "GNInAppPurchasePayment.h"
#import "GNInAppRestoreRequest.h"

#import <CWLSynthesizeSingleton.h>

@interface GNInAppPurchaseManager () <SKPaymentTransactionObserver>
@property (nonatomic,copy) void(^transactionHandler)(NSString *productIdentifier,void(^finishHandler)(void));
@property (nonatomic,strong) NSMutableArray *productRequests;
@property (nonatomic,strong) NSMutableArray *restoreRequests;
@property (nonatomic,strong) NSMutableArray *payments;
@end

@implementation GNInAppPurchaseManager
CWL_SYNTHESIZE_SINGLETON_FOR_CLASS_WITH_ACCESSOR(GNInAppPurchaseManager, sharedInstance);

-(NSMutableArray *)productRequests{
    if (!_productRequests) {
        _productRequests = [NSMutableArray array];
    }
    return _productRequests;
}
-(NSMutableArray *)restoreRequests{
    if (!_restoreRequests) {
        _restoreRequests = [NSMutableArray array];
    }
    return _restoreRequests;
}
-(NSMutableArray *)payments{
    if (!_payments) {
        _payments = [NSMutableArray array];
    }
    return _payments;
}
-(GNInAppStorageStrategy *)storageStrategy{
    if (!_storageStrategy) {
        _storageStrategy = [[GNInAppUserDefaultsStorageStrategy alloc] init];
    }
    return _storageStrategy;
}



-(void)startupWithTransactionHandler:(void(^)(NSString *productIdentifier,void(^finishHandler)(void)))transactionHandler{
    self.transactionHandler = transactionHandler;
    [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
}


+(BOOL)canMakePayments{
    return [SKPaymentQueue canMakePayments];
}

-(BOOL)isProductPurchased:(NSString *)productIdentifier{
    return [self totalProductPurchases:productIdentifier] > 0;
}
-(NSDate *)latestProductPurchaseDate:(NSString *)productIdentifier{
    NSDate *date = [self.storageStrategy latestDateForProductIdentifier:productIdentifier];
    return date;
}
-(NSInteger)totalProductPurchases:(NSString *)productIdentifier{
    return [self.storageStrategy totalAmountForProductIdentifier:productIdentifier];
}


#pragma mark - Product Requests
-(void)loadProductWithIdentifier:(NSString *)productIdentifier success:(void (^)(SKProduct *))success failure:(void (^)(NSError *))failure{
    [self loadProductsWithIdentifiers:[NSSet setWithObject:productIdentifier] success:^(NSArray *products) {
        success(products.firstObject);
    } failure:failure];
}
-(void)loadProductsWithIdentifiers:(NSSet *)productIdentifiers success:(void(^)(NSArray *products))success failure:(void(^)(NSError *error))failure{
    GNInAppProductsRequest *request = [[GNInAppProductsRequest alloc] initWithProductIdentifiers:productIdentifiers];
    __weak GNInAppProductsRequest *weakRequest = request;
    [request setSuccess:^(SKProductsResponse *response) {
        success(response.products);
        [self.productRequests removeObject:weakRequest];
    }];
    
    [request setFailure:^(NSError *error) {
        failure(error);
        [self.productRequests removeObject:weakRequest];
    }];
    [self.productRequests addObject:request];
    [request start];
}


#pragma mark - Payments

-(void)purchaseProductWithIdentifier:(NSString *)productIdentifier quantity:(NSInteger)quantity success:(void(^)(SKProduct *product))success failure:(void(^)(NSError *error))failure{
    [self loadProductWithIdentifier:productIdentifier success:^(SKProduct *product) {
        GNInAppPurchasePayment *payment = [[GNInAppPurchasePayment alloc] initWithProduct:product quantity:quantity];
        __weak GNInAppPurchasePayment *weakPayment = payment;
        [payment setSuccess:^{
            [self.payments removeObject:weakPayment];
            success(product);
        }];
        
        [payment setFailure:^(NSError *error) {
            [self.payments removeObject:weakPayment];
            failure(error);
        }];
        [self.payments addObject:payment];
        [payment start];
    } failure:failure];
}


-(void)restoreCompletedTransactionsWithSuccess:(void(^)(void))success failure:(void(^)(NSError *error))failure{
    GNInAppRestoreRequest *request = [[GNInAppRestoreRequest alloc] init];
    __weak GNInAppRestoreRequest *weakRequest = request;
    
    [request setSuccess:^{
        success();
        [self.restoreRequests removeObject:weakRequest];
    }];
    
    [request setFailure:^(NSError *error) {
        failure(error);
        [self.restoreRequests removeObject:weakRequest];
    }];
    [self.restoreRequests addObject:request];
    [request start];
}

#pragma mark - Payment Transactions
-(void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions{
    NSLog(@"transactions updated %@",transactions);
    for (SKPaymentTransaction *transaction in transactions) {
        NSLog(@"%@ => %i",transaction.payment.productIdentifier,transaction.transactionState == SKPaymentTransactionStatePurchased);
        if (transaction.transactionState == SKPaymentTransactionStatePurchased || transaction.transactionState == SKPaymentTransactionStateRestored) {
            NSDate *latestPurchaseDate = [self latestProductPurchaseDate:transaction.payment.productIdentifier];
            if (!latestPurchaseDate || [latestPurchaseDate timeIntervalSinceDate:transaction.transactionDate] < 0) {
                [self.storageStrategy storeDate:transaction.transactionDate quantity:transaction.payment.quantity productIdentifier:transaction.payment.productIdentifier];
            }
            self.transactionHandler(transaction.payment.productIdentifier,^{
                [queue finishTransaction:transaction];
            });
        }
    }
    NSLog(@"transactions end");
}

@end
