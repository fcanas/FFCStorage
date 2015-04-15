//
//  FFCStoreModel.h
//  FFCStorage
//
//  Created by Fabian Canas on 2/21/15.
//  Copyright (c) 2015 Fabian Canas. All rights reserved.
//

@import Foundation;
#import <FFCStorage/FFCStoreNullability.h>

@protocol FFCStoreModel <NSObject>

/*
 Primary key for storage
 */
@property (nonatomic, copy, ffc_nullable) NSString *id;

/**
 Route for instance of the store model.
 */
- (ffc_nullable NSString *)route;

/**
 Route appropriate for a collection of instances of the store model class
 */
+ (ffc_nullable NSString *)route;

/**
 A JSON-equivalent representation of the receiving instance. This method is
 called by @p FFCStore for serialization.
 */
- (ffc_nullable NSDictionary *)asJSON;

@end
