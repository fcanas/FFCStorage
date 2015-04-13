//
//  FFCNetworkClient.h
//  FFCStorage
//
//  Created by Fabian Canas on 2/21/15.
//  Copyright (c) 2015 Fabian Canas. All rights reserved.
//

@import Foundation;

#import <FFCStorage/FFCStoreNullability.h>

typedef NS_ENUM(NSUInteger, FFCClientScheme) {
    FFCClientSchemeHTTP,
    FFCClientSchemeHTTPS
};

@class FFCBearerCredentials;

FFC_ASSUME_NONNULL_BEGIN
@interface FFCNetworkClient : NSObject

#pragma mark - Creating a Network Client

- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)new NS_UNAVAILABLE;

/**
 Initializes the receiver and configures network requests to go over @p https on port 80.

 @param scheme Configures the client to use either http or https when generating URLs
 @param host The hostname for the server the network client will communicate with. The hostname is a string betwen the scheme (<i>e.g.</i> https) and the first @p / in the path
 @param path The path prefix that will be prepended to each URL the network client generates. This is useful for namespacing an API, <i>e.g.</i>  @p \@"/v1" . The @p path should include a preceeding @p /
 */
- (ffc_nullable instancetype)initWithHost:( NSString * )host path:( ffc_nullable NSString  * )path;

/**
 The designated initializer for @p FFCNetworkClient

 @param scheme Configures the client to use either http or https when generating URLs
 @param host The hostname for the server the network client will communicate with. The hostname is a string betwen the scheme (<i>e.g.</i> https) and the first @p / in the path
 @param path The path prefix that will be prepended to each URL the network client generates. This is useful for namespacing an API, <i>e.g.</i>  @p \@"/v1" . The @p path should include a preceeding @p /
 */
- (ffc_nullable instancetype)initWithScheme:(FFCClientScheme)scheme host:( NSString * )host port:( ffc_nullable NSNumber * )port path:( ffc_nullable NSString  * )path NS_DESIGNATED_INITIALIZER;

/**
 Initializes the receiver and configures network requests to go over port 80

 @param scheme Configures the client to use either http or https when generating URLs
 @param host The hostname for the server the network client will communicate with. The hostname is a string betwen the scheme (<i>e.g.</i> https) and the first @p / in the path
 @param path The path prefix that will be prepended to each URL the network client generates. This is useful for namespacing an API, <i>e.g.</i>  @p \@"/v1" . The @p path should include a preceeding @p /
 */
- (ffc_nullable instancetype)initWithScheme:(FFCClientScheme)scheme host:( NSString * )host path:( ffc_nullable NSString  * )path;

#pragma mark - Credentials

/**
 A credential model that will be used to configure headers on authenticated network requests initiated from the network client.
 */
@property (nonatomic, strong, ffc_nullable) FFCBearerCredentials *credentials;

#pragma mark - Shared Client

/**
 Returns an FFCNetworkClient that is intended to be shared.
 
 A network client can be promoted to the shared client by calling @p -makeSharedClient.
 Until an instance of @p FFCNetworkClient is promoted to the shared client, this method
 will return @p nil

 @see -makeSharedClient
 */
+ (ffc_nullable instancetype)sharedClient;

/**
 Promotes the receiving instance of @p FFCNetworkClient to the @p sharedClient accessible
 via the @p +sharedClient class method.

 @see -sharedClient
 */
- (void)makeSharedClient;

#pragma mark - Custom Requests

/**
 Returns an @p NSMutableURLRequest configured with all the URL components of the 
 network client with the subpath appended. If the network client is configured with
 credentials, that URL request will also be authenticated.

 @see session
 */
- (ffc_nullable NSMutableURLRequest *)baseRequestForSubpath:( ffc_nullable NSString * )subpath;

/**
 The @p NSURLSession used by the network client to make network requests. It may be used
 to make custom requests.

 @see -baseRequestForSubPath:
 */
@property (nonatomic, readonly, strong) NSURLSession *session;

@end

FFC_ASSUME_NONNULL_END
