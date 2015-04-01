//
//  FFCNetworkStore.m
//  FFCStorage
//
//  Created by Fabian Canas on 2/21/15.
//  Copyright (c) 2015 Fabian Canas. All rights reserved.
//

#import "FFCNetworkStore.h"
#import "FFCNetworkClient.h"
#import "FFCStoreModel.h"

#import <SafeCast/SafeCast.h>

@interface FFCNetworkStore ()
@property (nonatomic, strong) FFCNetworkClient *client;
@end

@implementation FFCNetworkStore

- (instancetype)initWithNetworkClient:(FFCNetworkClient *)networkClient
{
    self = [super init];
    
    if (self == nil) {
        return nil;
    }
    
    _client = networkClient;
    
    return self;
}

- (instancetype)init
{
    self = [self initWithNetworkClient:[FFCNetworkClient sharedClient]];
    return self;
}

- (void)getClass:(Class)class completion:(void(^)(NSArray *, NSError *))completion
{
    [self getClass:class atPath:[class route] completion:completion];
}

- (void)getClass:(Class)class atPath:(NSString *)path completion:(void(^)(NSArray *, NSError *))completion
{
    NSAssert2([class conformsToProtocol:@protocol(FFCStoreModel)],
              @"%@ requires %@ to conform to FFCStoreModelProtocol",
              NSStringFromClass([self class]),
              NSStringFromClass(class));
    NSMutableURLRequest *request = [self.client baseRequestForSubpath:path];
    request.HTTPMethod = @"GET";
    NSURLSessionTask *task = [self.client.session dataTaskWithRequest:request
                                                    completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                        NSMutableArray *models = [NSMutableArray array];
                                                        [[NSArray safe_cast:[NSJSONSerialization JSONObjectWithData:data
                                                                                                            options:kNilOptions
                                                                                                              error:nil]] enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL *stop) {
                                                            [NSDictionary safe_cast:obj intoBlock:^(NSDictionary *mDict) {
                                                                NSObject *model = [[class alloc] init];
                                                                [model setValuesForKeysWithDictionary:mDict];
                                                                [models addObject:model];
                                                            }];
                                                        }];
                                                        completion(models, error);
                                                    }];
    [task resume];
}

- (void)getModel:(NSObject<FFCStoreModel> *)instance completion:(void(^)(NSError *))completion
{
    [self getModel:instance atPath:[instance route] completion:completion];
}

- (void)getModel:(NSObject<FFCStoreModel> *)instance atPath:(NSString *)path completion:(void(^)(NSError *))completion
{
    NSMutableURLRequest *request = [self.client baseRequestForSubpath:path];
    request.HTTPMethod = @"GET";
    NSURLSessionTask *task = [self.client.session dataTaskWithRequest:request
                                                    completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                        
                                                        NSError *serializationError = nil;
                                                        
                                                        [NSDictionary safe_cast:[NSJSONSerialization JSONObjectWithData:data
                                                                                                                options:kNilOptions
                                                                                                                  error:&serializationError]
                                                                      intoBlock:^(NSDictionary *mDict) {
                                                                          [instance setValuesForKeysWithDictionary:mDict];
                                                                      }];
                                                        
                                                        if (serializationError) {
                                                            completion(serializationError);
                                                            return;
                                                        }
                                                        
                                                        completion(error);
                                                    }];
    [task resume];
}

- (void)saveModel:(NSObject<FFCStoreModel> *)instance completion:(void(^)(NSObject<FFCStoreModel> *, NSError *))completion
{
    NSError *serializationError = nil;
    NSMutableURLRequest *request = [self.client baseRequestForSubpath:instance.route];
    request.HTTPMethod = ([instance id] == 0)?@"POST":@"PUT";
    request.HTTPBody = [NSJSONSerialization dataWithJSONObject:[instance asJSON]
                                                       options:kNilOptions
                                                         error:&serializationError];
    if (serializationError != nil) {
        NSLog(@"Encountered serialization error :: %@", serializationError);
        if (request.HTTPBody == nil) {
            NSLog(@"Aborting");
            completion(nil, serializationError);
            return;
        } else {
            NSLog(@"Continuing");
        }
    }
    
    NSURLSessionTask *task = [self.client.session dataTaskWithRequest:request
                                                    completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                        NSError *serializationError = nil;
                                                        NSObject<FFCStoreModel> * __block returnedInstance = nil;
                                                        
                                                        [NSDictionary safe_cast:[NSJSONSerialization JSONObjectWithData:data
                                                                                                                options:kNilOptions
                                                                                                                  error:&serializationError]
                                                                      intoBlock:^(NSDictionary *mDict) {
                                                                          returnedInstance = [[instance class] new];
                                                                          [returnedInstance setValuesForKeysWithDictionary:mDict];
                                                                      }];
                                                        
                                                        if (serializationError) {
                                                            completion(nil, serializationError);
                                                            return;
                                                        }
                                                        
                                                        completion(returnedInstance, error);
                                                    }];
    [task resume];
}

- (void)deleteModel:(NSObject<FFCStoreModel> *)model
{
    if (model == nil || model.id < 1) {
        return;
    }
    NSMutableURLRequest *request = [self.client baseRequestForSubpath:[model route]];
    request.HTTPMethod = @"DELETE";
    NSURLSessionTask *task = [self.client.session dataTaskWithRequest:request
                                                    completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                        NSString *r = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                                        NSLog(@"Model deleted ::\n%@", r);
                                                    }];
    [task resume];
}

@end
