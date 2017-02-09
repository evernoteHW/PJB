//
//  DemoView.m
//  Demo
//
//  Created by apple on 17/2/8.
//  Copyright © 2017年 WeiHu. All rights reserved.
//

#import "DemoView.h"

@implementation DemoView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(test:)];
        [self addGestureRecognizer:tap];
        
        
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 200, 50)];
        btn.backgroundColor = [UIColor yellowColor];
        [btn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
        //      [btn addTarget:self action:@selector(btnAction2:) forControlEvents:UIControlEventTouchDragInside];
        [self addSubview:btn];
        
    }
    return self;
}
- (void)btnAction:(UIButton *)btn{
    NSLog(@"Demo 按钮点击");
}

- (void)test:(UITapGestureRecognizer *)tap{
    [self.delegate didSelectedView:@"111"];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
