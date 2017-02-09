//
//  DemoView.h
//  Demo
//
//  Created by apple on 17/2/8.
//  Copyright © 2017年 WeiHu. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DemoViewDelegate <NSObject>
- (void)didSelectedView:(NSString *)eventID;
@end

@interface DemoView : UIView
@property (nonatomic, weak) id<DemoViewDelegate> delegate;
@end
