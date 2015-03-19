//
//  GNInAppProductsRequest.m
//  GNInAppPurchaseManager
//
//  Created by Jakub Knejzlik on 18/03/15.
//  Copyright (c) 2015 Jakub Knejzlik. All rights reserved.
//

#import "GNInAppProductsRequest.h"

@interface GNInAppProductsRequest () <SKProductsRequestDelegate>
@property (nonatomic,strong) SKProductsRequest *request;
@property (nonatomic,strong) SKProductsResponse *response;
@end

@implementation GNInAppProductsRequest

-(instancetype)initWithProductIdentifiers:(NSSet *)productIdentifiers{
    self = [super init];
    if (self) {
        self.productIdentifiers = productIdentifiers;
        
        self.request = [[SKProductsRequest alloc] initWithProductIdentifiers:self.productIdentifiers];
        self.request.delegate = self;
    }
    return self;
}

-(void)dealloc{
    self.request.delegate = nil;
}

-(void)start{
    [self.request start];
}


#pragma mark - Request Delegate Methods

-(void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response{
    self.response = response;
}
-(void)request:(SKRequest *)request didFailWithError:(NSError *)error{
    self.failure(error);
}
-(void)requestDidFinish:(SKRequest *)request{
    self.request.delegate = nil;
    self.request = nil;
    self.success(self.response);
}

@end
