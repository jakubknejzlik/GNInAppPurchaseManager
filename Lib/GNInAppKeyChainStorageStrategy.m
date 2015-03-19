//
//  GNInAppKeyChainStorageStrategy.m
//  GNInAppPurchaseManager
//
//  Created by Jakub Knejzlik on 19/03/15.
//  Copyright (c) 2015 Jakub Knejzlik. All rights reserved.
//

#import "GNInAppKeyChainStorageStrategy.h"


#import <Lockbox.h>

@interface GNInAppKeyChainStorageStrategy ()
@property (nonatomic,strong) Lockbox *lockbox;
@end

@implementation GNInAppKeyChainStorageStrategy

-(instancetype)init{
    return [self initWithPrefix:nil];
}

-(instancetype)initWithPrefix:(NSString *)prefix{
    self = [super init];
    if (self) {
        self.lockbox = [[Lockbox alloc] initWithKeyPrefix:prefix];
    }
    return self;
}

-(void)storeDate:(NSDate *)date quantity:(NSInteger)quantity productIdentifier:(NSString *)productIdentifier{
    [self.lockbox setDate:date forKey:[productIdentifier stringByAppendingString:@"-date"]];
    NSInteger total = [[self.lockbox stringForKey:[productIdentifier stringByAppendingString:@"-total"]] integerValue] + quantity;
    [self.lockbox setString:[NSString stringWithFormat:@"%d",total] forKey:[productIdentifier stringByAppendingString:@"-total"]];
}

-(NSDate *)latestDateForProductIdentifier:(NSString *)productIdentifer{
    return [self.lockbox dateForKey:[productIdentifer stringByAppendingString:@"-date"]];
}

-(NSInteger)totalAmountForProductIdentifier:(NSString *)productIdentifer{
    return [[self.lockbox stringForKey:[productIdentifer stringByAppendingString:@"-total"]] integerValue];
}

@end
