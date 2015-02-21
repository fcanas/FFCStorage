//
//  FFCNetworkClient.m
//  FFCStorage
//
//  Created by Fabian Canas on 2/21/15.
//  Copyright (c) 2015 Fabian Canas. All rights reserved.
//

#import "FFCNetworkClient.h"
#import "FFCBearerCredentials.h"

@interface FFCNetworkClient ()
@property (nonatomic, readonly, copy) NSString *host;
@property (nonatomic, readonly, copy) NSString *path;
@end

@implementation FFCNetworkClient

static FFCNetworkClient *_sharedClient = nil;

+ (instancetype)sharedClient
{
    return _sharedClient;
}

- (void)makeSharedClient
{
    _sharedClient = self;
}

- (instancetype)init
{
    return [self initWithHost:nil path:nil];
}

- (instancetype)initWithHost:(NSString *)host path:(NSString *)path
{
    self = [super init];
    NSAssert(host!=nil, @"Initializing a Client without a hostname is not allowed.");
    
    if (self == nil) {
        return nil;
    }
    
    _host = [host copy];
    _path = [path copy] ?: @"/";
    
    _session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    
    return self;
}

- (NSURL *)URLForRelativePath:(NSString *)subpath
{
    NSURLComponents *components = [[NSURLComponents alloc] init];
    components.scheme = @"http";
    components.host = self.host;
    components.path = [self.path stringByAppendingPathComponent:subpath];
    return [components URL];
}

- (NSMutableURLRequest *)baseRequestForSubpath:(NSString *)subpath
{
    NSURL *url = [self URLForRelativePath:subpath];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    
    NSMutableDictionary *headerFields = [@{@"Content-Type": @"application/json"} mutableCopy];
    
    if (self.credentials != nil) {
        headerFields[@"client"] = self.credentials.client;
        headerFields[@"uid"] = self.credentials.uid;
        headerFields[@"access-token"] = self.credentials.token;
    }
    
    request.allHTTPHeaderFields = headerFields;
    
    return request;
}

@end
