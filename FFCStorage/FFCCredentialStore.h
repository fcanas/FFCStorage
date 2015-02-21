//
//  FFCCredentialStore.h
//  FFCStorage
//
//  Created by Fabian Canas on 2/21/15.
//  Copyright (c) 2015 Fabian Canas. All rights reserved.
//

#import <Foundation/Foundation.h>

@class FFCNetworkClient;
@class FFCBearerCredentials;

@interface FFCCredentialStore : NSObject

- (instancetype)initWithClient:(FFCNetworkClient *)client;

- (void)restoreSession:(void(^)(NSDictionary *, NSError *))completion;

- (void)loginWithEmail:(NSString *)email
              password:(NSString *)password
            completion:(void(^)(NSDictionary *userData, NSString *errorMessage))completion;

- (void)signupWithEmail:(NSString *)email
               password:(NSString *)password
             completion:(void(^)(NSDictionary *userData, NSString *errorMessage))completion;

+ (void)clearCredentials;

@end
