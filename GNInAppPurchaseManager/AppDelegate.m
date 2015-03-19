//
//  AppDelegate.m
//  GNInAppPurchaseManager
//
//  Created by Jakub Knejzlik on 18/03/15.
//  Copyright (c) 2015 Jakub Knejzlik. All rights reserved.
//

#import "AppDelegate.h"

#import "GNInAppPurchaseManager.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [[GNInAppPurchaseManager sharedInstance] startupWithTransactionHandler:^(NSString *productIdentifier,void(^finishCallback)(void)) {
        NSLog(@"handle transaction with product %@",productIdentifier);
        finishCallback();
    }];
    // Override point for customization after application launch.
    
    NSLog(@"%i",[GNInAppPurchaseManager canMakePayments]);
    if (![GNInAppPurchaseManager canMakePayments]) {
        [[[UIAlertView alloc] initWithTitle:@"Cannot make payments!" message:nil delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
    }
    
    return YES;
}

@end
