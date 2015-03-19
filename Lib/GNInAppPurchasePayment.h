//
//  GNInAppPurchasePayment.h
//  GNInAppPurchaseManager
//
//  Created by Jakub Knejzlik on 18/03/15.
//  Copyright (c) 2015 Jakub Knejzlik. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <StoreKit/StoreKit.h>

@interface GNInAppPurchasePayment : NSObject
@property (nonatomic,strong) SKPayment *payment;

@property (nonatomic,copy) void(^success)(void);
@property (nonatomic,copy) void(^failure)(NSError *error);

-(instancetype)initWithProduct:(SKProduct *)product quantity:(NSInteger)quantity;

-(void)start;

@end
