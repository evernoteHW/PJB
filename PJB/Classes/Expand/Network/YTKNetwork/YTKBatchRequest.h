//
//  BaseViewController.m
//  StructureExample
//
//  Created by WeiHu on 6/21/16.
//  Copyright © 2016 WeiHu. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class YTKRequest;
@class YTKBatchRequest;
@protocol YTKRequestAccessory;

@protocol YTKBatchRequestDelegate <NSObject>

@optional
- (void)batchRequestFinished:(YTKBatchRequest *)batchRequest;
- (void)batchRequestFailed:(YTKBatchRequest *)batchRequest;

@end
@interface YTKBatchRequest : NSObject
@property (nonatomic, strong, readonly) NSArray<YTKRequest *> *requestArray;
@property (nonatomic, weak, nullable) id<YTKBatchRequestDelegate> delegate;
@property (nonatomic, copy, nullable) void (^successCompletionBlock)(YTKBatchRequest *);
@property (nonatomic, copy, nullable) void (^failureCompletionBlock)(YTKBatchRequest *);
@property (nonatomic) NSInteger tag;
@property (nonatomic, strong, nullable) NSMutableArray<id<YTKRequestAccessory>> *requestAccessories;
@property (nonatomic, strong, readonly, nullable) YTKRequest *failedRequest;

- (instancetype)initWithRequestArray:(NSArray<YTKRequest *> *)requestArray;

- (void)setCompletionBlockWithSuccess:(nullable void (^)(YTKBatchRequest *batchRequest))success
                              failure:(nullable void (^)(YTKBatchRequest *batchRequest))failure;
- (void)clearCompletionBlock;
- (void)addAccessory:(id<YTKRequestAccessory>)accessory;
- (void)start;
- (void)stop;
- (void)startWithCompletionBlockWithSuccess:(nullable void (^)(YTKBatchRequest *batchRequest))success
                                    failure:(nullable void (^)(YTKBatchRequest *batchRequest))failure;

- (BOOL)isDataFromCache;

@end

NS_ASSUME_NONNULL_END
