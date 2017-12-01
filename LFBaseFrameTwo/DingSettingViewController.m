//
//  DingSettingViewController.m
//  LFBaseFrameTwo
//
//  Created by 曹老师 on 2017/11/29.
//  Copyright © 2017年 admin. All rights reserved.
//

#import "DingSettingViewController.h"
#import "SDCycleScrollView.h"
#import "HotDingView.h"
#import "LatestDingView.h"
#import "DListViewController.h"
#import "SearchViewController.h"

@interface DingSettingViewController ()

@end

@implementation DingSettingViewController


#pragma mark ========================================生命周期========================================
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"订阅设置";
    self.view.backgroundColor = Background_Color;
    
    // 创建视图
    [self creatSubviewsAction];
    
    
}

#pragma mark ========================================私有方法=============================================

#pragma mark - 创建视图
- (void)creatSubviewsAction {
    
    // 导航栏两个按钮
    UIButton *searchButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [searchButton setImage:[UIImage imageNamed:@"sou"]  forState:UIControlStateNormal];
    [searchButton setTintColor:[UIColor whiteColor]];
    searchButton.frame = CGRectMake(0, 0, 30, 30);
    [searchButton addTarget:self action:@selector(searchButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightBarItemA = [[UIBarButtonItem alloc] initWithCustomView:searchButton];
    
    
    // 导航栏右边的添加按钮
    UIButton *rankButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [rankButton setTitle:@"我的订阅" forState:UIControlStateNormal];
    rankButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [rankButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [rankButton setTintColor:[UIColor whiteColor]];
    rankButton.frame = CGRectMake(0, 0, 50, 30);
    [rankButton addTarget:self action:@selector(myDingAction:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightBarItemB = [[UIBarButtonItem alloc] initWithCustomView:rankButton];
    self.navigationItem.rightBarButtonItems = @[rightBarItemB, rightBarItemA];
    
    // 轮播图
    SDCycleScrollView *bannerView = [[SDCycleScrollView alloc] initWithFrame:CGRectMake(0, 64, kScreenWidth, kScreenWidth * 0.35)];
    bannerView.pageControlAliment = SDCycleScrollViewPageContolAlimentCenter;
    bannerView.currentPageDotColor = Publie_Color;
    bannerView.pageDotColor=[UIColor whiteColor];
    bannerView.placeholderImage = [UIImage imageNamed:@"默认图"];
    bannerView.backgroundColor = Background_Color;
    bannerView.pageControlAliment = SDCycleScrollViewPageContolAlimentCenter;
    bannerView.localizationImageNamesGroup = @[@"banner1", @"banner2", @"banner3"];
    [self.view addSubview:bannerView];
    
    // 热门推荐
    HotDingView *hotView = [[HotDingView alloc] initWithFrame:CGRectMake(15, kScreenWidth * 0.35 + 64 + 10,
                                                                         kScreenWidth - 30,
                                                                         (kScreenHeight - (kScreenWidth * 0.35 + 64 + 30)) * 0.5)];
    hotView.layer.cornerRadius = 5;
    hotView.backgroundColor = [UIColor whiteColor];
    hotView.clipsToBounds = YES;
    [self.view addSubview:hotView];
    
    // 最新加入
    LatestDingView *latestView = [[LatestDingView alloc] initWithFrame:CGRectMake(15, kScreenWidth * 0.35 + 64 + 20 + (kScreenHeight - (kScreenWidth * 0.35 + 64 + 30)) * 0.5,
                                                                         kScreenWidth - 30,
                                                                         (kScreenHeight - (kScreenWidth * 0.35 + 64 + 30)) * 0.5)];
    latestView.layer.cornerRadius = 5;
    latestView.backgroundColor = [UIColor whiteColor];
    latestView.clipsToBounds = YES;
    [self.view addSubview:latestView];
    
    
}



#pragma mark ========================================动作响应=============================================

#pragma mark - 搜索
- (void)searchButtonAction:(UIButton *)button {
    
    SearchViewController *ctrl = [[SearchViewController alloc] init];
    ctrl.type = @"1";   // 搜索专栏
    [self.navigationController pushViewController:ctrl animated:YES];
    
}

#pragma mark - 我的订阅
- (void)myDingAction:(UIButton *)button {
    
    DListViewController *ctrl = [[DListViewController alloc] init];
    [self.navigationController pushViewController:ctrl animated:YES];
    
}


#pragma mark ========================================网络请求=============================================

#pragma mark ========================================代理方法=============================================

#pragma mark ========================================通知================================================





































@end
