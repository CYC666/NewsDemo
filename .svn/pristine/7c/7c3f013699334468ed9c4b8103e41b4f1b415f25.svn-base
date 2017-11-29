//
//  LFNavigationController.m
//  LFBaseFrameTwo
//
//  Created by admin on 16/12/16.
//  Copyright © 2016年 admin. All rights reserved.
//

#import "LFNavigationController.h"
#import "UINavigationController+FDFullscreenPopGesture.h"

@interface LFNavigationController ()

@end

@implementation LFNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //设置导航栏和文字的颜色
    self.navigationBar.barTintColor = Publie_Color;
    self.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationBar.titleTextAttributes = @{NSFontAttributeName:[UIFont systemFontOfSize:20],
                                               NSForegroundColorAttributeName:[UIColor whiteColor]};
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


//封装导航栏返回方法
-(void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    
    if (self.childViewControllers.count>0) {
        UIButton *button=[UIButton buttonWithType:UIButtonTypeCustom];
        [button setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
        [button sizeToFit];
        [button addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
        viewController.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc]initWithCustomView:button];
        //push方式隐藏底部的tabbar
        viewController.hidesBottomBarWhenPushed=YES;
    }
    [super pushViewController:viewController animated:animated];
    
}

-(void)back {
    
    //pop返回
    [self popViewControllerAnimated:YES];
    
}

@end
