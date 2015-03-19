//
//  GNInAppUserDefaultsStorageStrategy.m
//  GNInAppPurchaseManager
//
//  Created by Jakub Knejzlik on 19/03/15.
//  Copyright (c) 2015 Jakub Knejzlik. All rights reserved.
//

#import "GNInAppUserDefaultsStorageStrategy.h"

@implementation GNInAppUserDefaultsStorageStrategy

-(void)storeDate:(NSDate *)date quantity:(NSInteger)quantity productIdentifier:(NSString *)productIdentifier{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:date forKey:[productIdentifier stringByAppendingString:@"-date"]];
    NSInteger total = [defaults integerForKey:[productIdentifier stringByAppendingString:@"-total"]] + quantity;
    [defaults setInteger:total forKey:[productIdentifier stringByAppendingString:@"-total"]];
    [defaults synchronize];
}

-(NSDate *)latestDateForProductIdentifier:(NSString *)productIdentifer{
    return [[NSUserDefaults standardUserDefaults] objectForKey:[productIdentifer stringByAppendingString:@"-date"]];
}

-(NSInteger)totalAmountForProductIdentifier:(NSString *)productIdentifer{
    return [[NSUserDefaults standardUserDefaults] integerForKey:[productIdentifer stringByAppendingString:@"-total"]];
}

@end
