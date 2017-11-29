//
//  MainTabBarController.m
//  LFBaseFrameTwo
//
//  Created by admin on 16/12/16.
//  Copyright © 2016年 admin. All rights reserved.
//

#import "MainTabBarController.h"

@interface MainTabBarController () {

    //用户信息单例
    UserInformation *userInfo;
    
    //工具方法单例
    SmallFunctionTool *smallFunc;

}

@end

@implementation MainTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //初始化
    userInfo = [UserInformation sharedInstance];
    smallFunc = [SmallFunctionTool sharedInstance];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    //设置分页的标签
    NSArray *titleName = @[@"主页", @"订阅",@"发现", @"我的"];
    NSArray *imageOn = @[@"part11-0", @"part22-0" ,@"part33-0", @"part44-0"];
    NSArray *imageOff = @[@"part11-1", @"part22-1", @"part33-1",@"part44-1"];
    
    //设置
    for (int i = 0; i < self.viewControllers.count; i++)
    {
        
        UIViewController *vc = self.viewControllers[i];
        
        vc.title = titleName[i];
        vc.tabBarItem.image = [[UIImage imageNamed:imageOff[i]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        vc.tabBarItem.selectedImage = [[UIImage imageNamed:imageOn[i]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        
        // 图片偏移量:
        //vc.tabBarItem.imageInsets = UIEdgeInsetsMake(5, 0, 0, 0);
        
        // 设置title在选择状态下的颜色:
        [vc.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName:Publie_Color} forState:UIControlStateSelected];
        
        //设置title的偏移量:
        [vc.tabBarItem setTitlePositionAdjustment:UIOffsetMake(0, -1)];
        
    }

    
}






































@end
