//
//  BaseViewController.m
//  StructureExample
//
//  Created by WeiHu on 6/21/16.
//  Copyright © 2016 WeiHu. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class YTKChainRequest;

@interface YTKChainRequestAgent : NSObject

- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)new NS_UNAVAILABLE;

+ (YTKChainRequestAgent *)sharedAgent;
- (void)addChainRequest:(YTKChainRequest *)request;
- (void)removeChainRequest:(YTKChainRequest *)request;

@end

NS_ASSUME_NONNULL_END
