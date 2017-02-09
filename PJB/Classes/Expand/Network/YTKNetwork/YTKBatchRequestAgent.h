//
//  BaseViewController.m
//  StructureExample
//
//  Created by WeiHu on 6/21/16.
//  Copyright © 2016 WeiHu. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class YTKBatchRequest;

@interface YTKBatchRequestAgent : NSObject

- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)new NS_UNAVAILABLE;
+ (YTKBatchRequestAgent *)sharedAgent;
- (void)addBatchRequest:(YTKBatchRequest *)request;
- (void)removeBatchRequest:(YTKBatchRequest *)request;

@end

NS_ASSUME_NONNULL_END
