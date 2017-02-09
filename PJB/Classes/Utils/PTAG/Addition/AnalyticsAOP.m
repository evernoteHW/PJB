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

typedef enum : NSUInteger {
    ControlEventIDs,
    PageEventIDs,
    TapEventIDs,
} AOPEventID;

const NSArray *___DPodRecordType;
#define cDPodRecordTypeGet (___DPodRecordType == nil ? ___DPodRecordType = [[NSArray alloc] initWithObjects:\
@"ControlEventIDs",\
@"PageEventIDs",\
@"TapEventIDs", nil] : ___DPodRecordType)

 #define cDPodRecordTypeEnum(string) ([cDPodRecordTypeGet indexOfObject:string])
 #define cDPodRecordTypeString(type) ([cDPodRecordTypeGet objectAtIndex:type])

@implementation AnalyticsAOP

+ (AnalyticsAOP *)manager{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        insatance = [[self alloc] init];
    });
    return insatance;
}
- (NSString *)eventType:(AOPEventID)type sel:(SEL)sel target:(id)target{
    NSString *SELName = NSStringFromSelector(sel);
    NSDictionary *configDict = [self dictionaryFromPJPtagConfig];
    
    NSString *className = NSStringFromClass([target class]);
    return configDict[className][cDPodRecordTypeString(type)][SELName];
}

- (NSDictionary *)dictionaryFromPJPtagConfig
{
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"PJPtagConfig" ofType:@"plist"];
    NSDictionary *dic = [NSDictionary dictionaryWithContentsOfFile:filePath];
    return dic;
}

@end

@implementation UIControl (AOP)

+ (void)load{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [SwizzleTool swizzleWithClass:[self class] originalSelector:@selector(sendAction:to:forEvent:) swizzleSelector:@selector(aop_sendAction:to:forEvent:)];
    });
}
- (void)aop_sendAction:(SEL)action to:(id)target forEvent:(UIEvent *)event{
    [self aop_sendAction:action to:target forEvent:event];
    NSLog(@"%@", [[AnalyticsAOP manager] eventType:ControlEventIDs sel:action target:target]);
}

@end

@implementation UIViewController (AOP)

+ (void)load{
    static dispatch_once_t dispatch_once_token;
    dispatch_once(&dispatch_once_token, ^{
        [SwizzleTool swizzleWithClass:[self class] originalSelector:@selector(viewWillAppear:) swizzleSelector:@selector(aop_viewWillAppear:)];
        [SwizzleTool swizzleWithClass:[self class] originalSelector:@selector(viewWillDisappear:) swizzleSelector:@selector(aop_viewWillDisAppear:)];
    });
}
- (void)aop_viewWillAppear:(BOOL)animated{
    NSLog(@"%@", [[AnalyticsAOP manager] eventType:PageEventIDs sel:@selector(viewWillAppear:) target:self]);
    [self aop_viewWillAppear:animated];
}
- (void)aop_viewWillDisAppear:(BOOL)animated{
    NSLog(@"%@", [[AnalyticsAOP manager] eventType:PageEventIDs sel:@selector(viewWillDisappear:) target:self]);
    [self aop_viewWillAppear:animated];
}
@end

@implementation UITapGestureRecognizer (AOP)

+ (void)load{
    static dispatch_once_t dispatch_once_token;
    dispatch_once(&dispatch_once_token, ^{
        
        SEL originSEL = @selector(initWithTarget:action:);
        SEL swizzleSEL = @selector(aop_initWithTarget:action:);
        [SwizzleTool swizzleWithClass:[self class] originalSelector:originSEL swizzleSelector:swizzleSEL];
        
    });
}

- (instancetype)aop_initWithTarget:(id)target action:(SEL)action{
    
    UITapGestureRecognizer *gestureRecognizer = [self aop_initWithTarget:target action:action];
    if (!target && !action) {
        return gestureRecognizer;
    }
    if ([target isKindOfClass:[UIScrollView class]]) {
        return gestureRecognizer;
    }
    
    Class class = [target class];
    SEL originalSEL = action;
    SEL swizzledSEL = NSSelectorFromString([NSString stringWithFormat:@"aop_%@", NSStringFromSelector(action)]);
    BOOL isAddMethod = class_addMethod(class, swizzledSEL, (IMP)aop_gestureAction, "v@:@");
    if (isAddMethod) {
        Method originalMethod = class_getInstanceMethod(class, originalSEL);
        Method swizzledMethod = class_getInstanceMethod(class, swizzledSEL);
        method_exchangeImplementations(originalMethod, swizzledMethod);
    }
    
    return gestureRecognizer;
}
void aop_gestureAction(id self, SEL _cmd, id sender) {
    SEL swizzledSEL = NSSelectorFromString([NSString stringWithFormat:@"aop_%@", NSStringFromSelector(_cmd)]);
    ((void(*)(id, SEL, id))objc_msgSend)(self, swizzledSEL, sender);
    NSLog(@"%@", [[AnalyticsAOP manager] eventType:TapEventIDs sel:_cmd target:self]);
}

@end

@implementation UITableView (AOP)

+ (void)load
{
    static dispatch_once_t dispatch_once_token;
    dispatch_once(&dispatch_once_token, ^{
        [SwizzleTool swizzleWithClass:[self class] originalSelector:@selector(setDelegate:) swizzleSelector:@selector(aop_setDelegate:)];
    });
}

- (void)aop_setDelegate:(id<UITableViewDelegate>)delegate
{
    [self aop_setDelegate:delegate];
    
    if (class_addMethod([delegate class], NSSelectorFromString(@"aop_didSelectRowAtIndexPath"), (IMP)vi_didSelectRowAtIndexPath, "v@:@@")) {
        Method didSelectOriginalMethod = class_getInstanceMethod([delegate class], NSSelectorFromString(@"aop_didSelectRowAtIndexPath"));
        Method didSelectSwizzledMethod = class_getInstanceMethod([delegate class], @selector(tableView:didSelectRowAtIndexPath:));
        
        method_exchangeImplementations(didSelectOriginalMethod, didSelectSwizzledMethod);
    }
}

void vi_didSelectRowAtIndexPath(id self, SEL _cmd, id tableView, id indexPath)
{
    SEL selector = NSSelectorFromString(@"aop_didSelectRowAtIndexPath");
    ((void(*)(id, SEL, id, id))objc_msgSend)(self, selector, tableView, indexPath);
}

@end


@implementation UICollectionView (AOP)

+ (void)load
{
    static dispatch_once_t dispatch_once_token;
    dispatch_once(&dispatch_once_token, ^{
        [SwizzleTool swizzleWithClass:[self class] originalSelector:@selector(setDelegate:) swizzleSelector:@selector(aop_setDelegate:)];
    });
}

- (void)aop_setDelegate:(id<UICollectionViewDelegate>)delegate
{
    [self aop_setDelegate:delegate];
    
    if (class_addMethod([delegate class], NSSelectorFromString(@"aop_didSelectItemAtIndexPath"), (IMP)vi_didSelectItemAtIndexPath, "v@:@@")) {
        Method didSelectOriginalMethod = class_getInstanceMethod([delegate class], NSSelectorFromString(@"aop_didSelectItemAtIndexPath"));
        Method didSelectSwizzledMethod = class_getInstanceMethod([delegate class], @selector(collectionView:didSelectItemAtIndexPath:));
        
        method_exchangeImplementations(didSelectOriginalMethod, didSelectSwizzledMethod);
    }
}

void vi_didSelectItemAtIndexPath(id self, SEL _cmd, id collectionView, id indexPath)
{
    SEL selector = NSSelectorFromString(@"aop_didSelectItemAtIndexPath");
    ((void(*)(id, SEL, id, id))objc_msgSend)(self, selector, collectionView, indexPath);
}

@end
