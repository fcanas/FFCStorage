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
@property (nonatomic, readonly, copy) NSNumber *port;
@property (nonatomic, readonly, copy) NSString *scheme;
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

- (instancetype)initWithScheme:(FFCClientScheme)scheme host:(NSString *)host port:(NSNumber *)port path:(NSString *)path
{
    self = [super init];
    NSAssert(host!=nil, @"Initializing a Client without a hostname is not allowed.");
    
    if (self == nil) {
        return nil;
    }
    
    switch (scheme) {
        case FFCClientSchemeHTTPS:
            _scheme = @"https";
            break;
        case FFCClientSchemeHTTP:
            _scheme = @"http";
            break;
        default:
            break;
    }
    
    _host = [host copy];
    _path = [path copy] ?: @"/";
    _port = [port copy] ?: @80;
    
    _session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    
    return self;
}

- (instancetype)initWithScheme:(FFCClientScheme)scheme host:(NSString *)host path:(NSString *)path
{
    self = [self initWithScheme:scheme host:host port:nil path:path];
    return self;
}

- (instancetype)initWithHost:(NSString *)host path:(NSString *)path
{
    self = [self initWithScheme:FFCClientSchemeHTTPS host:host path:path];
    return self;
}

- (NSURL *)URLForRelativePath:(NSString *)subpath
{
    NSURLComponents *components = [[NSURLComponents alloc] init];
    components.scheme = self.scheme;
    components.host = self.host;
    components.path = [self.path stringByAppendingPathComponent:subpath];
    components.port = self.port;
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
