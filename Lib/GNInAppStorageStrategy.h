//
//  GNInAppStorageStrategy.h
//  GNInAppPurchaseManager
//
//  Created by Jakub Knejzlik on 19/03/15.
//  Copyright (c) 2015 Jakub Knejzlik. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GNInAppStorageStrategy : NSObject

-(void)storeDate:(NSDate *)date quantity:(NSInteger)quantity productIdentifier:(NSString *)productIdentifier;

-(NSDate *)latestDateForProductIdentifier:(NSString *)productIdentifer;

-(NSInteger)totalAmountForProductIdentifier:(NSString *)productIdentifer;

@end
