//
//  BaseViewController.m
//  StructureExample
//
//  Created by WeiHu on 6/21/16.
//  Copyright © 2016 WeiHu. All rights reserved.
//


#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class YTKBaseRequest;

@interface YTKNetworkAgent : NSObject
- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)new NS_UNAVAILABLE;
+ (YTKNetworkAgent *)sharedAgent;
- (void)addRequest:(YTKBaseRequest *)request;
- (void)cancelRequest:(YTKBaseRequest *)request;
- (void)cancelAllRequests;
- (NSString *)buildRequestUrl:(YTKBaseRequest *)request;

@end

NS_ASSUME_NONNULL_END
