//
//  FFCStore.h
//  FFCStorage
//
//  Created by Fabian Canas on 2/25/15.
//  Copyright (c) 2015 Fabian Canas. All rights reserved.
//

@import Foundation;
#import <FFCStorage/FFCStoreNullability.h>

@protocol FFCStoreModel;

FFC_ASSUME_NONNULL_BEGIN
@protocol FFCStore <NSObject>
- (void)getClass:(Class<FFCStoreModel>)class completion:(void(^)(NSArray *__ffc_nullable, NSError *__ffc_nullable))completion;
- (void)getClass:(Class)class atPath:(NSString *)path completion:(void(^)(NSArray *__ffc_nullable, NSError *__ffc_nullable))completion;

- (void)getModel:(NSObject<FFCStoreModel> *)instance completion:(void(^)(NSError *__ffc_nullable))completion;
- (void)saveModel:(NSObject<FFCStoreModel> *)model completion:(void(^)(NSObject<FFCStoreModel> *__ffc_nullable, NSError *__ffc_nullable))completion;
- (void)saveModel:(NSObject<FFCStoreModel> *)instance atPath:(NSString *)path completion:(void(^)(NSObject<FFCStoreModel> *__ffc_nullable, NSError *__ffc_nullable))completion;

- (void)deleteModel:(NSObject<FFCStoreModel> *)model;
@end
FFC_ASSUME_NONNULL_END
