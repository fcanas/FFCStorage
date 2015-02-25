//
//  FFCStoreModel.h
//  FFCStorage
//
//  Created by Fabian Canas on 2/21/15.
//  Copyright (c) 2015 Fabian Canas. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol FFCStoreModel <NSObject>

@property (nonatomic, assign) NSInteger id;

- (NSString *)route;
+ (NSString *)route;

- (NSDictionary *)asJSON;

@end
