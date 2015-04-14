//
//  FFCCredentialStore.h
//  FFCStorage
//
//  Created by Fabian Canas on 2/21/15.
//  Copyright (c) 2015 Fabian Canas. All rights reserved.
//

@import Foundation;
#import <FFCStorage/FFCStoreNullability.h>

@class FFCNetworkClient;
@class FFCBearerCredentials;

FFC_ASSUME_NONNULL_BEGIN
@interface FFCCredentialStore : NSObject

/**
 Initializes a new credential store using the default @p FFCNetworkClient
 */
- (instancetype)init;

/**
 Initializes a new credential store using the provided @p FFCNetworkClient

 A credential store needs a network client so it can attempt to refresh expiring credentials.
 When credentials are loaded from the keychain or the network, those credentials are then
 passed to the network client for use in authenticated requests.
 */
- (instancetype)initWithClient:(FFCNetworkClient *)client NS_DESIGNATED_INITIALIZER;

/**
 Attempts to load credentials from the keychain first. If tokens are found to be expired,
 attempts to fetch new tokens via the network client.

 If cretendials are obtained, the network client is configured with those credentials.
 */
- (void)restoreSession:(void(^)(NSDictionary *, NSError *))completion;

/**
 Attempts to configure credentials with an existing remote account via the network client.

 If cretendials are obtained, the network client is configured with those credentials.
 */
- (void)loginWithEmail:(NSString *)email
              password:(NSString *)password
            completion:(void(^)(NSDictionary *userData, NSString *errorMessage))completion;

/**
 Attempts to configure credentials creating a new remote account via the network client.

 If cretendials are obtained, the network client is configured with those credentials.
 */
- (void)signupWithEmail:(NSString *)email
               password:(NSString *)password
             completion:(void(^)(NSDictionary *userData, NSString *errorMessage))completion;

/**
 Removes all credential components from the keychain. 
 This should be called when logging out, or at other times when you wish to revoke credentials.
 */
+ (void)clearCredentials;

@end
FFC_ASSUME_NONNULL_END