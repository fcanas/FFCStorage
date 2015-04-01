//
//  FFCStore.h
//  FFCStorage
//
//  Created by Fabian Canas on 2/25/15.
//  Copyright (c) 2015 Fabian Canas. All rights reserved.
//

@import Foundation;

@protocol FFCStoreModel;

@protocol FFCStore <NSObject>
- (void)getClass:(Class<FFCStoreModel>)class completion:(void(^)(NSArray *, NSError *))completion;
- (void)getClass:(Class)class atPath:(NSString *)path completion:(void(^)(NSArray *, NSError *))completion;

- (void)getModel:(NSObject<FFCStoreModel> *)instance completion:(void(^)(NSError *))completion;
- (void)saveModel:(NSObject<FFCStoreModel> *)model completion:(void(^)(NSObject<FFCStoreModel> *, NSError *))completion;

- (void)deleteModel:(NSObject<FFCStoreModel> *)model;
@end
