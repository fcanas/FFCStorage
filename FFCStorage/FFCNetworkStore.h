//
//  FFCNetworkStore.h
//  FFCStorage
//
//  Created by Fabian Canas on 2/21/15.
//  Copyright (c) 2015 Fabian Canas. All rights reserved.
//

@import Foundation;

#import <FFCStorage/FFCStore.h>

@class FFCNetworkClient;

/**
 @p FFCNetworkStore is an implementation of @p FFCStore suitable for storing and retrieving 
 @p FFCModel objects from a RESTful API via an @p FFCNetworkClient.
 */
@interface FFCNetworkStore : NSObject <FFCStore>

/**
 Configures the receiver with the default @p FFCNetworkClient
 */
- (nullable instancetype)init;

/**
 Configures the receiver with the provided @p FFCNetworkClient
 */
- (nullable instancetype)initWithNetworkClient:(nonnull FFCNetworkClient *)networkClient NS_DESIGNATED_INITIALIZER;

@end
