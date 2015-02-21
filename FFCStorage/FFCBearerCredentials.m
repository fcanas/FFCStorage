//
//  FFCBearerCredentials.m
//  FFCStorage
//
//  Created by Fabian Canas on 2/21/15.
//  Copyright (c) 2015 Fabian Canas. All rights reserved.
//

#import "FFCBearerCredentials.h"

@implementation FFCBearerCredentials

- (instancetype)initWithToken:(NSString *)token Uid:(NSString *)uid expiry:(NSDate *)date client:(NSString *)client
{
    self = [super init];
    
    if (self == nil) {
        return nil;
    }
    
    _token = [token copy];
    _uid = [uid copy];
    _expiry = [date copy];
    _client = [client copy];
    
    return self;
}

- (BOOL)needsRefresh
{// Do we have between a minute and an hour?
    return ( [self.expiry timeIntervalSinceNow] > 60 ) && ( [self.expiry timeIntervalSinceNow] < 60 * 60 );
}


- (BOOL)isValid
{// Do we have an hour remaining on the token?
    return [self.expiry timeIntervalSinceNow] > 60 * 60;
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"Token for %@. Expires on %@", self.uid, self.expiry];
}

@end
