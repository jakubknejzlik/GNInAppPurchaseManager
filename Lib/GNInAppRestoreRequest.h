//
//  GNInAppRestoreRequest.h
//  GNInAppPurchaseManager
//
//  Created by Jakub Knejzlik on 19/03/15.
//  Copyright (c) 2015 Jakub Knejzlik. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GNInAppRestoreRequest : NSObject
@property (nonatomic,copy) void(^success)(void);
@property (nonatomic,copy) void(^failure)(NSError *error);

-(void)start;

@end
