//
//  ViewController.m
//  Demo
//
//  Created by apple on 17/2/8.
//  Copyright © 2017年 WeiHu. All rights reserved.
//

#import "ViewController.h"
#import "DemoView.h"
#import "FirstViewController.h"

@interface ViewController () <DemoViewDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    //继续熟悉IOS业务代码  并开始整理埋点框架
    DemoView *view = [[DemoView alloc] initWithFrame:CGRectMake(20, 100, 200, 100)];
    view.backgroundColor = [UIColor orangeColor];
    view.delegate = self;
    [self.view addSubview:view];
    
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(20, 250, 200, 100)];
    btn.backgroundColor = [UIColor orangeColor];
    [btn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
    //      [btn addTarget:self action:@selector(btnAction2:) forControlEvents:UIControlEventTouchDragInside];
    [self.view addSubview:btn];
    
}
- (void)didSelectedView:(NSString *)eventID{
    
    [self presentViewController:[[FirstViewController alloc] init] animated:YES completion:^{

    }];
    NSLog(@"%@",eventID);
}

- (void)btnAction:(UIButton *)btn{
    NSLog(@"按钮点击");
}
- (void)btnAction2:(UIButton *)btn{
    NSLog(@",,,,,,");
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
