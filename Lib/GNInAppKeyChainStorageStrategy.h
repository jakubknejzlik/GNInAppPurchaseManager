//
//  GNInAppKeyChainStorageStrategy.h
//  GNInAppPurchaseManager
//
//  Created by Jakub Knejzlik on 19/03/15.
//  Copyright (c) 2015 Jakub Knejzlik. All rights reserved.
//

#import "GNInAppStorageStrategy.h"

@interface GNInAppKeyChainStorageStrategy : GNInAppStorageStrategy

-(instancetype)initWithPrefix:(NSString *)prefix; // app bundle identifier is used as default

@end
