//
//  GNInAppProductsRequest.h
//  GNInAppPurchaseManager
//
//  Created by Jakub Knejzlik on 18/03/15.
//  Copyright (c) 2015 Jakub Knejzlik. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <StoreKit/StoreKit.h>

@interface GNInAppProductsRequest : NSObject

@property (nonatomic,strong) NSSet *productIdentifiers;

@property (nonatomic,copy) void(^success)(SKProductsResponse *response);
@property (nonatomic,copy) void(^failure)(NSError *failure);

-(instancetype)initWithProductIdentifiers:(NSSet *)productIdentifiers;

-(void)start;

@end
