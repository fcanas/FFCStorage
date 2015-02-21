//
//  FFCBearerCredentials.h
//  FFCStorage
//
//  Created by Fabian Canas on 2/21/15.
//  Copyright (c) 2015 Fabian Canas. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FFCBearerCredentials : NSObject

- (instancetype)initWithToken:(NSString *)token
                          Uid:(NSString *)uid
                       expiry:(NSDate *)date
                       client:(NSString *)client;

@property (nonatomic, readonly, copy) NSString *client;
@property (nonatomic, readonly, copy) NSString *uid;
@property (nonatomic, readonly, copy) NSString *token;
@property (nonatomic, readonly, copy) NSDate *expiry;

- (BOOL)isValid;

@end
