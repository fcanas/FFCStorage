//
//  FFCNetworkClient.h
//  FFCStorage
//
//  Created by Fabian Canas on 2/21/15.
//  Copyright (c) 2015 Fabian Canas. All rights reserved.
//

#import <Foundation/Foundation.h>

@class FFCBearerCredentials;

@interface FFCNetworkClient : NSObject
+ (instancetype)sharedClient;

@property (nonatomic, strong) FFCBearerCredentials *credentials;
@property (nonatomic, readonly, strong) NSURLSession *session;

- (instancetype)initWithHost:(NSString *)host path:(NSString *)path;
- (NSMutableURLRequest *)baseRequestForSubpath:(NSString *)subpath;
- (void)makeSharedClient;

@end
