//
//  SwizzleTool.h
//  PJB
//
//  Created by apple on 17/2/8.
//  Copyright © 2017年 WeiHu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SwizzleTool : NSObject

+ (void)swizzleWithClass:(Class)processedClass originalSelector:(SEL)originSelector swizzleSelector:(SEL)swizzlSelector;
    
@end
