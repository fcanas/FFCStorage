//
//  FFCRealmStore.m
//  FFCStorage
//
//  Created by Fabian Canas on 4/4/15.
//  Copyright (c) 2015 Fabian Canas. All rights reserved.
//

#import "FFCRealmStore.h"
#import <FFCStorage/FFCStoreModel.h>
#import <Realm/Realm.h>
#import <Realm/RLMObjectStore.h>
#import <SafeCast/SafeCast.h>
#import <objc/objc-class.h>

@interface FFCRealmStore ()
@property (nonatomic, retain) RLMRealm *realm;
@end

@implementation FFCRealmStore

- (instancetype)init
{
    self = [self initWithRealm:[RLMRealm defaultRealm]];
    return self;
}

- (instancetype)initWithRealm:(RLMRealm *)realm
{
    self = [super init];
    
    return self;
}

- (void)getClass:(Class)objectClass atPath:(NSString *)path
      completion:(void (^)(NSArray *, NSError *))completion
{
    [self getClass:objectClass completion:completion];
}

- (void)getClass:(Class<FFCStoreModel>)class
      completion:(void (^)(NSArray *, NSError *))completion
{
    RLMResults *results = RLMGetObjects(self.realm, NSStringFromClass(class), nil);
    NSMutableArray *resultsArray = [NSMutableArray arrayWithCapacity:results.count];
    for (int i = 0; i<results.count; i++) {
        [resultsArray addObject:results[i]];
    }
    
    if (completion) {
        completion(resultsArray, nil);
    }
}

- (void)saveModel:(NSObject<FFCStoreModel> *)model
       completion:(void (^)(NSObject<FFCStoreModel> *, NSError *))completion
{
    [RLMObject safe_cast:model intoBlock:^(RLMObject *model) {
        [self.realm beginWriteTransaction];
        [[model class] createOrUpdateInRealm:self.realm withObject:model];
        [self.realm commitWriteTransaction];
    }];
}

- (void)getModel:(NSObject<FFCStoreModel> *)instance
      completion:(void (^)(NSError *))completion
{
    RLMGetObject(self.realm, NSStringFromClass([instance class]), [instance id]);
}

- (void)deleteModel:(NSObject<FFCStoreModel> *)model
{
    [RLMObject safe_cast:model intoBlock:^(RLMObject *model) {
        [self.realm beginWriteTransaction];
        [self.realm deleteObject:model];
        [self.realm commitWriteTransaction];
    }];
}

@end
