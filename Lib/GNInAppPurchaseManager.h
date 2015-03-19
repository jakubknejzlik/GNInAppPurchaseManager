//
//  GNInAppPurchaseManager.h
//  GNInAppPurchaseManager
//
//  Created by Jakub Knejzlik on 18/03/15.
//  Copyright (c) 2015 Jakub Knejzlik. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <StoreKit/StoreKit.h>

#import "GNInAppKeyChainStorageStrategy.h"
#import "GNInAppUserDefaultsStorageStrategy.h"

@interface GNInAppPurchaseManager : NSObject

@property (nonatomic,strong) GNInAppStorageStrategy *storageStrategy;

+(instancetype)sharedInstance;

+(BOOL)canMakePayments;

-(BOOL)isProductPurchased:(NSString *)productIdentifier;
-(NSDate *)latestProductPurchaseDate:(NSString *)productIdentifier;
-(NSInteger)totalProductPurchases:(NSString *)productIdentifier;

-(void)startupWithTransactionHandler:(void(^)(NSString *productIdentifier,void(^finishHandler)(void)))transactionHandler;

-(void)loadProductWithIdentifier:(NSString *)productIdentifier success:(void(^)(SKProduct *product))success failure:(void(^)(NSError *error))failure;
-(void)loadProductsWithIdentifiers:(NSSet *)productIdentifiers success:(void(^)(NSArray *products))success failure:(void(^)(NSError *error))failure;

/**
 * Success and failure handlers are used for UI updates only. Always handle product purchases with startupWithTransactionHandler
 */
-(void)purchaseProductWithIdentifier:(NSString *)productIdentifier quantity:(NSInteger)quantity success:(void(^)(SKProduct *product))success failure:(void(^)(NSError *error))failure;

-(void)restoreCompletedTransactionsWithSuccess:(void(^)(void))success failure:(void(^)(NSError *error))failure;

@end