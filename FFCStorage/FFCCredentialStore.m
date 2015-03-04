//
//  FFCCredentialStore.m
//  FFCStorage
//
//  Created by Fabian Canas on 2/21/15.
//  Copyright (c) 2015 Fabian Canas. All rights reserved.
//

#import "FFCCredentialStore.h"

#import <SafeCast/SafeCast.h>
#import <FXKeychain/FXKeychain.h>

#import "FFCNetworkClient.h"
#import "FFCBearerCredentials.h"

NSString * const FFCBearerTokenKey = @"FFCBearerTokenKey";
NSString * const FFCBearerTokenExipryKey = @"FFCBearerTokenExipryKey";
NSString * const FFCCurrentUserEmailKey = @"FFCCurrentUserEmailKey";
NSString * const FFCCurrentUserPasswordKey = @"FFCCurrentUserPasswordKey";
NSString * const FFCClientKey = @"FFCClientKey";

@interface FFCKeychainCredentials : NSObject
@property (nonatomic, copy) NSString *email;
@property (nonatomic, copy) NSString *password;
+ (void)storeEmail:(NSString *)email password:(NSString *)password;
+ (instancetype)credentialsFromKeyChain;
@end

@interface FFCCredentialStore ()
@property (nonatomic, strong) FFCNetworkClient *client;
@end

@implementation FFCCredentialStore

- (instancetype)init { return [self initWithClient:[FFCNetworkClient sharedClient]]; }

- (instancetype)initWithClient:(FFCNetworkClient *)client
{
    self = [super init];
    if (self == nil) return nil;
    
    _client = client ?: [FFCNetworkClient sharedClient];
    
    return self;
}

- (void)restoreSession:(void(^)(NSDictionary *, NSError *))completion
{
    FFCKeychainCredentials *credentials = [FFCKeychainCredentials credentialsFromKeyChain];
    
    if (credentials == nil) {
        completion(nil, nil);
        return;
    }
    
    [self loginWithEmail:credentials.email
                password:credentials.password
              completion:^(NSDictionary *userData, NSString *errorString) {
                  completion(userData, nil);
              }];
}

- (void)loginWithEmail:(NSString *)email
              password:(NSString *)password
            completion:(void(^)(NSDictionary *userData, NSString *errorMessage))completion
{
    NSMutableURLRequest *request = [self.client baseRequestForSubpath:@"/auth/sign_in"];
    
    NSDictionary *body = @{@"email" : email,
                           @"password": password};
    NSData *bodyData = [NSJSONSerialization dataWithJSONObject:body options:kNilOptions error:nil];
    request.HTTPMethod = @"POST";
    [request setHTTPBody:bodyData];
    
    [self authenticateRequest:request password:password completion:completion];
}

- (void)authenticateRequest:(NSURLRequest *)request password:(NSString *)password completion:(void(^)(NSDictionary *userData, NSString *))completion
{
    NSURLSessionDataTask *task = [self.client.session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        NSLog(@"Response Received");
        if (error) {
            NSLog(@"error: %@", error);
        }
        
        NSDictionary *userDataDict = [NSDictionary safe_cast:[NSJSONSerialization JSONObjectWithData:data
                                                                                             options:kNilOptions
                                                                                               error:nil]];
        NSArray *errorsArray = [NSArray safe_cast:userDataDict[@"errors"]];
        userDataDict = [NSDictionary safe_cast:userDataDict[@"data"]];
        FXKeychain *keychain = [FXKeychain defaultKeychain];
        
        if (![NSHTTPURLResponse safe_cast:response intoBlock:^(NSHTTPURLResponse *response) {
            if (response.statusCode == 200) {
                __block BOOL validToken = NO;
                [NSString safe_cast:[response allHeaderFields][@"Access-Token"] intoBlock:^(NSString *tokenString) {
                    [keychain setObject:tokenString forKey:FFCBearerTokenKey];
                    validToken = YES;
                    [NSString safe_cast:[response allHeaderFields][@"Expiry"] intoBlock:^(NSString *expiry) {
                        NSDate *expiryDate = [NSDate dateWithTimeIntervalSince1970:[expiry doubleValue]];
                        [keychain setObject:expiryDate forKey:FFCBearerTokenExipryKey];
                        validToken = [expiryDate timeIntervalSinceNow] > 0;
                        FFCBearerCredentials *tokenCredentials = [[FFCBearerCredentials alloc] initWithToken:tokenString Uid:[response allHeaderFields][@"Uid"] expiry:expiryDate client:[response allHeaderFields][@"Client"]];
                        if (validToken) {
                            [FFCKeychainCredentials storeEmail:[response allHeaderFields][@"Uid"] password:password];
                            self.client.credentials = tokenCredentials;
                            completion(userDataDict, nil);
                        } else {
                            completion(nil, @"Something went wrong.");
                        }
                    }];
                }];
            } else if (response.statusCode == 401) {
                if ([errorsArray.firstObject isEqualToString:@"Invalid login credentials. Please try again."]) {
                    [[self class] clearCredentials];
                }
                
            } else {
                completion(nil, errorsArray.firstObject);
            }
        }]) {
            completion(nil, errorsArray.firstObject);
        };
    }];
    
    [task resume];
}

- (void)signupWithEmail:(NSString *)email
               password:(NSString *)password
             completion:(void(^)(NSDictionary *userData, NSString *errorMessage))completion
{
    NSMutableURLRequest *request = [self.client baseRequestForSubpath:@"/auth/"];
    
    NSDictionary *body = @{@"email" : email,
                           @"password": password};
    NSData *bodyData = [NSJSONSerialization dataWithJSONObject:body options:kNilOptions error:nil];
    request.HTTPMethod = @"POST";
    [request setHTTPBody:bodyData];
    
    [self authenticateRequest:request password:password completion:completion];
}

+ (void)clearCredentials
{
    FXKeychain *keychain = [FXKeychain defaultKeychain];
    keychain[FFCBearerTokenKey] = nil;
    keychain[FFCBearerTokenExipryKey] = nil;
    keychain[FFCCurrentUserEmailKey] = nil;
    keychain[FFCCurrentUserPasswordKey] = nil;
    keychain[FFCClientKey] = nil;
}

@end

@implementation FFCKeychainCredentials

+ (void)storeEmail:(NSString *)email password:(NSString *)password
{
    FXKeychain *keychain = [FXKeychain defaultKeychain];
    [keychain setObject:email forKey:FFCCurrentUserEmailKey];
    [keychain setObject:password forKey:FFCCurrentUserPasswordKey];
}

+ (instancetype)credentialsFromKeyChain
{
    FXKeychain *keychain = [FXKeychain defaultKeychain];
    __block FFCKeychainCredentials *credentials = nil;
    
    [NSString safe_cast:[keychain objectForKey:FFCCurrentUserEmailKey] intoBlock:^(NSString *email) {
        [NSString safe_cast:[keychain objectForKey:FFCCurrentUserPasswordKey] intoBlock:^(NSString *pasword) {
            credentials = [[self alloc] init];
            credentials.email = email;
            credentials.password = pasword;
        }];
    }];
    return credentials;
}

@end

