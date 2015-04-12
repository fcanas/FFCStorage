//
//  FFCStoreModel.h
//  FFCStorage
//
//  Created by Fabian Canas on 2/21/15.
//  Copyright (c) 2015 Fabian Canas. All rights reserved.
//

@import Foundation;

@protocol FFCStoreModel <NSObject>

@property (nonatomic, assign) NSInteger id;

/**
 Route for instance of the store model.
 */
- (nullable NSString *)route;

/**
 Route appropriate for a collection of instances of the store model class
 */
+ (nullable NSString *)route;

/**
 A JSON-equivalent representation of the receiving instance. This method is
 called by @p FFCStore for serialization.
 */
- (nullable NSDictionary *)asJSON;

@end
