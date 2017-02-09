//
//  BaseViewController.m
//  StructureExample
//
//  Created by WeiHu on 6/21/16.
//  Copyright © 2016 WeiHu. All rights reserved.
//

#import "YTKChainRequestAgent.h"
#import "YTKChainRequest.h"

@interface YTKChainRequestAgent()

@property (strong, nonatomic) NSMutableArray<YTKChainRequest *> *requestArray;

@end

@implementation YTKChainRequestAgent

+ (YTKChainRequestAgent *)sharedAgent {
    static id sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _requestArray = [NSMutableArray array];
    }
    return self;
}

- (void)addChainRequest:(YTKChainRequest *)request {
    @synchronized(self) {
        [_requestArray addObject:request];
    }
}

- (void)removeChainRequest:(YTKChainRequest *)request {
    @synchronized(self) {
        [_requestArray removeObject:request];
    }
}

@end
