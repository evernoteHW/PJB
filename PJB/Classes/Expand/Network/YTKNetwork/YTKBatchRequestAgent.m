//
//  YTKBatchRequestAgent.m
//
//  Copyright (c) 2012-2016 YTKNetwork https://github.com/yuantiku
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//
//  BaseViewController.m
//  StructureExample
//
//  Created by WeiHu on 6/21/16.
//  Copyright © 2016 WeiHu. All rights reserved.
//

#import "YTKBatchRequestAgent.h"
#import "YTKBatchRequest.h"

@interface YTKBatchRequestAgent()

@property (strong, nonatomic) NSMutableArray<YTKBatchRequest *> *requestArray;

@end

@implementation YTKBatchRequestAgent

+ (YTKBatchRequestAgent *)sharedAgent {
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

- (void)addBatchRequest:(YTKBatchRequest *)request {
    @synchronized(self) {
        [_requestArray addObject:request];
    }
}

- (void)removeBatchRequest:(YTKBatchRequest *)request {
    @synchronized(self) {
        [_requestArray removeObject:request];
    }
}

@end
