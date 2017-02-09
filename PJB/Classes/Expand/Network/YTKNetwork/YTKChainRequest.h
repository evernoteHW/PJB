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
@class YTKBaseRequest;
@protocol YTKRequestAccessory;

@protocol YTKChainRequestDelegate <NSObject>

@optional
- (void)chainRequestFinished:(YTKChainRequest *)chainRequest;
- (void)chainRequestFailed:(YTKChainRequest *)chainRequest failedBaseRequest:(YTKBaseRequest*)request;
@end

typedef void (^YTKChainCallback)(YTKChainRequest *chainRequest, YTKBaseRequest *baseRequest);
@interface YTKChainRequest : NSObject

- (NSArray<YTKBaseRequest *> *)requestArray;
@property (nonatomic, weak, nullable) id<YTKChainRequestDelegate> delegate;
@property (nonatomic, strong, nullable) NSMutableArray<id<YTKRequestAccessory>> *requestAccessories;
- (void)addAccessory:(id<YTKRequestAccessory>)accessory;
- (void)start;
- (void)stop;
- (void)addRequest:(YTKBaseRequest *)request callback:(nullable YTKChainCallback)callback;

@end

NS_ASSUME_NONNULL_END
