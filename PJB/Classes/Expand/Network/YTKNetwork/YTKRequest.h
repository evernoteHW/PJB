//
//  BaseViewController.m
//  StructureExample
//
//  Created by WeiHu on 6/21/16.
//  Copyright © 2016 WeiHu. All rights reserved.
//


#import "YTKBaseRequest.h"

NS_ASSUME_NONNULL_BEGIN

FOUNDATION_EXPORT NSString *const YTKRequestCacheErrorDomain;

NS_ENUM(NSInteger) {
    YTKRequestCacheErrorExpired = -1,
    YTKRequestCacheErrorVersionMismatch = -2,
    YTKRequestCacheErrorSensitiveDataMismatch = -3,
    YTKRequestCacheErrorAppVersionMismatch = -4,
    YTKRequestCacheErrorInvalidCacheTime = -5,
    YTKRequestCacheErrorInvalidMetadata = -6,
    YTKRequestCacheErrorInvalidCacheData = -7,
};

@interface YTKRequest : YTKBaseRequest

@property (nonatomic) BOOL ignoreCache;
- (BOOL)isDataFromCache;
- (BOOL)loadCacheWithError:(NSError * __autoreleasing *)error;
- (void)startWithoutCache;
- (void)saveResponseDataToCacheFile:(NSData *)data;

#pragma mark - Subclass Override
- (NSInteger)cacheTimeInSeconds;
- (long long)cacheVersion;
- (nullable id)cacheSensitiveData;
- (BOOL)writeCacheAsynchronously;

@end

NS_ASSUME_NONNULL_END
