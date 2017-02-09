//
//  AnalyticsAOP.m
//  Demo
//
//  Created by apple on 17/2/8.
//  Copyright © 2017年 WeiHu. All rights reserved.
//

#import "AnalyticsAOP.h"
#import "Aspects.h"
#import "SwizzleTool.h"
#import <objc/runtime.h>
#import <objc/message.h>

static AnalyticsAOP *insatance = nil;

@implementation AnalyticsAOP

+ (AnalyticsAOP *)manager{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        insatance = [[self alloc] init];
    });
    return insatance;
}

- (NSString *)pageSel:(SEL)sel target:(id)target
{
    NSString *SELName = NSStringFromSelector(sel);
    NSDictionary *configDict = [self dictionaryFromPJPtagConfig];
    
    NSString *className = NSStringFromClass([target class]);
    return configDict[className][@"ControlEventIDs"][SELName];
}

- (NSString *)pageEventID:(SEL)sel target:(id)target
{
    NSString *SELName = NSStringFromSelector(sel);
    NSDictionary *configDict = [self dictionaryFromPJPtagConfig];
    
    NSString *className = NSStringFromClass([target class]);
    return configDict[className][@"PageEventIDs"][SELName];
}

- (NSDictionary *)dictionaryFromPJPtagConfig
{
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"PJPtagConfig" ofType:@"plist"];
    NSDictionary *dic = [NSDictionary dictionaryWithContentsOfFile:filePath];
    return dic;
}

@end

//@implementation UIControl (AOP)
//+ (void)load{
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
//        
//        id<AspectToken> control_token = [UIControl aspect_hookSelector:@selector(sendAction:to:forEvent:) withOptions:AspectPositionAfter usingBlock:^(id<AspectInfo> info){
//            
//            UIButton *button = info.instance;
//            if (![button isKindOfClass:[UIControl class]]) {
//                return;
//            }
//            NSArray *targetsArray = button.allTargets.allObjects;
//            if (!targetsArray.firstObject || [targetsArray.firstObject isKindOfClass:[NSNull class]]) {
//                return;
//            }
//            id target = targetsArray.firstObject;
//            NSArray *arr = [button actionsForTarget:targetsArray.firstObject forControlEvent:UIControlEventTouchUpInside];
//            
//            if (!arr.firstObject || [arr.firstObject isKindOfClass:[NSNull class]]) {
//                return;
//            }
//            if (![arr.firstObject isKindOfClass:[NSString class]]) {
//                return;
//            }
//            SEL sel = NSSelectorFromString(arr.firstObject);
//            
//            NSLog(@"%@", [[AnalyticsAOP manager] pageSel:sel target:target]);
//            
////            id retValue;
////            [info.originalInvocation getReturnValue:&retValue];
////            NSLog(@"%@",retValue);
////            
//        } error:nil];
//        
//        //可以容灾
//        if (/* DISABLES CODE */ (NO)) {
//            [control_token remove];
//        }
//    });
//}
//@end

@implementation UIViewController (AOP)

+ (void)load{
    static dispatch_once_t dispatch_once_token;
    dispatch_once(&dispatch_once_token, ^{
        [SwizzleTool swizzleWithClass:[self class] originalSelector:@selector(viewWillAppear:) swizzleSelector:@selector(aop_viewWillAppear:)];
//       id<AspectToken> viewWillAppear_token = [UIViewController aspect_hookSelector:@selector(viewWillAppear:) withOptions:AspectPositionInstead usingBlock:^(id<AspectInfo> info){
//            
//            NSRange range = [NSStringFromSelector(info.originalInvocation.selector) rangeOfString:@"aspects__"];
//            NSString *selName = [NSStringFromSelector(info.originalInvocation.selector) substringFromIndex:range.length];
//            SEL sel = NSSelectorFromString(selName);
//            UIViewController *vc = info.originalInvocation.target;
//            NSLog(@"%@", [[AnalyticsAOP manager] pageEventID:sel target:vc]);
//
//        } error:nil];
//        //可以容灾
//        if (/* DISABLES CODE */ (NO)) {
//            [viewWillAppear_token remove];
//        }
        

//        id<AspectToken> viewWillDisappear_token = [UIViewController aspect_hookSelector:@selector(viewWillDisappear:) withOptions:AspectPositionInstead usingBlock:^(id<AspectInfo> info){
//            
//            NSRange range = [NSStringFromSelector(info.originalInvocation.selector) rangeOfString:@"aspects__"];
//            NSString *selName = [NSStringFromSelector(info.originalInvocation.selector) substringFromIndex:range.length];
//            SEL sel = NSSelectorFromString(selName);
//            UIViewController *vc = info.originalInvocation.target;
//            NSLog(@"%@", [[AnalyticsAOP manager] pageEventID:sel target:vc]);
//    
//            
//        } error:nil];
        
//        if (/* DISABLES CODE */ (NO)) {
////            [viewWillDisappear_token remove];
//        }
    });
}
- (void)aop_viewWillAppear:(BOOL)animated{

    
    NSLog(@"23223");
    [self aop_viewWillAppear:animated];
    
//    self.view.backgroundColor = [UIColor orangeColor];
    
    
}
@end

//@implementation UIGestureRecognizer (AOP)
//
//+ (void)load{
//    static dispatch_once_t dispatch_once_token;
//    dispatch_once(&dispatch_once_token, ^{
//        
//        SEL originSEL0 = @selector(initWithTarget:action:);
//        SEL swizzleSEL0 = @selector(aop_initWithTarget:action:);
//        [SwizzleTool swizzleWithClass:[self class] originalSelector:originSEL0 swizzleSelector:swizzleSEL0];
//        
//    });
//}
//
//- (instancetype)aop_initWithTarget:(id)target action:(SEL)action{
//    
//    UIGestureRecognizer *gestureRecognizer = [self aop_initWithTarget:target action:action];
//    if (!target && !action) {
//        return gestureRecognizer;
//    }
//    if ([target isKindOfClass:[UIScrollView class]]) {
//        return gestureRecognizer;
//    }
//    id<AspectToken> action_token = [[target class] aspect_hookSelector:action withOptions:AspectPositionBefore usingBlock:^(id<AspectInfo> info){
////        NSLog(@"----------------");
//     
//        UIView *target = info.instance;
//        if (![target isKindOfClass:[UIView class]]) {
//            return;
//        }
//
//        UITapGestureRecognizer *tap = info.arguments.firstObject;
//        
//        Ivar targetsIvar = class_getInstanceVariable([UIGestureRecognizer class], "_targets");
//        id targetActionPairs = object_getIvar(tap, targetsIvar);
//        
//        Class targetActionPairClass = NSClassFromString(@"UIGestureRecognizerTarget");
//        Ivar targetIvar = class_getInstanceVariable(targetActionPairClass, "_target");
//        Ivar actionIvar = class_getInstanceVariable(targetActionPairClass, "_action");
//        
//        for (id targetActionPair in targetActionPairs)
//        {
//            id target = object_getIvar(targetActionPair, targetIvar);
//            SEL action = (__bridge void *)object_getIvar(targetActionPair, actionIvar);
//            
//            NSLog(@"target=%@; action=%@", target, NSStringFromSelector(action));
//        }
//        //测试阶段专用
//        
//    } error:nil];
//    
//    if (/* DISABLES CODE */ (NO)) {
//        [action_token remove];
//    }
//    
//    return gestureRecognizer;
//}
//
//
//
//@end
