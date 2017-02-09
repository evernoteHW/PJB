//
//  SwizzleTool.m
//  PJB
//
//  Created by apple on 17/2/8.
//  Copyright © 2017年 WeiHu. All rights reserved.
//

#import "SwizzleTool.h"
#import <objc/runtime.h>

@implementation SwizzleTool

+ (void)swizzleWithClass:(Class)processedClass originalSelector:(SEL)originSelector swizzleSelector:(SEL)swizzlSelector{
    
    Method originMethod = class_getInstanceMethod(processedClass, originSelector);
    Method swizzleMethod = class_getInstanceMethod(processedClass, swizzlSelector);
    BOOL didAddMethod = class_addMethod(processedClass, originSelector, method_getImplementation(swizzleMethod), method_getTypeEncoding(swizzleMethod));
    if (didAddMethod) {
        class_replaceMethod(processedClass, swizzlSelector, method_getImplementation(originMethod), method_getTypeEncoding(originMethod));
    }else{
        method_exchangeImplementations(originMethod, swizzleMethod);
    }
    
}

@end
