//
//  FFCNetworkClient.h
//  FFCStorage
//
//  Created by Fabian Canas on 2/21/15.
//  Copyright (c) 2015 Fabian Canas. All rights reserved.
//

#import <Foundation/Foundation.h>

@class FFCBearerCredentials;

typedef NS_ENUM(NSUInteger, FFCClientScheme) {
    FFCClientSchemeHTTP,
    FFCClientSchemeHTTPS
};

@interface FFCNetworkClient : NSObject
+ (instancetype)sharedClient;

@property (nonatomic, strong) FFCBearerCredentials *credentials;
@property (nonatomic, readonly, strong) NSURLSession *session;

- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)new NS_UNAVAILABLE;

- (instancetype)initWithHost:(NSString *)host path:(NSString *)path;

- (instancetype)initWithScheme:(FFCClientScheme)scheme host:(NSString *)host path:(NSString *)path NS_DESIGNATED_INITIALIZER;

- (NSMutableURLRequest *)baseRequestForSubpath:(NSString *)subpath;

- (void)makeSharedClient;

@end
