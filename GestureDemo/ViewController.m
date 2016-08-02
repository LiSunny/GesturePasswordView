//
//  ViewController.m
//  GestureDemo
//
//  Created by HeavenLi on 16/7/29.
//  Copyright © 2016年 HeavenLi. All rights reserved.
//

#import "ViewController.h"

#import "GestureView.h"

@interface ViewController ()<GestureViewDelegate>
{
    
    GestureView * view;
    
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor lightGrayColor];
    
    UISegmentedControl * segControl = [[UISegmentedControl alloc] initWithItems:@[@"设定密码",@"登录"]];
    segControl.frame = CGRectMake(50, 64, CGRectGetWidth(self.view.frame) - 100, 30);
    [segControl addTarget:self action:@selector(valueChange:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:segControl];
    
    
    
    
    
    view = [[GestureView alloc] initWithFrame:CGRectMake((CGRectGetWidth(self.view.frame) - 300)/2., CGRectGetHeight(self.view.frame) - 380, 300, 300)];
    view.delegate = self;
    view.isSingleNode = NO;
//    view.isVerify = YES;
    [self.view addSubview:view];
    
    
}
- (void)valueChange:(UISegmentedControl *)controll
{
    
    if (controll.selectedSegmentIndex) {
        view.isVerify = NO;
    }else{
        view.isVerify = YES;
    }
    
}


/**
 *  回调代理方法
 *  {resCode:0000,message:"验证成功"}
 *  resCode 0000 -- 成功
 *                 0001 -- 两次密码不一致
 *                 0002 -- 密码错误
 */
- (void)gestureResult:(NSMutableDictionary *)resultDic
{
    NSLog(@" vc -- %@",resultDic);
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
