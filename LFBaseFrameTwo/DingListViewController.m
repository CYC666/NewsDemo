//
//  DingListViewController.m
//  LFBaseFrameTwo
//
//  Created by 曹奕程 on 2017/12/1.
//  Copyright © 2017年 admin. All rights reserved.
//

#import "DingListViewController.h"
#import "DidAddListView.h"
#import "CanAddListView.h"

@interface DingListViewController () <DidAddListViewDlegate, CanAddListViewDlegate>

@end

@implementation DingListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"订阅列表";
    self.view.backgroundColor = Background_Color;
    
    DidAddListView *didView = [[DidAddListView alloc] initWithFrame:CGRectMake(0, 64, kScreenWidth, (kScreenHeight - 64 - 10) * 0.5)];
    didView.cellDelegate = self;
    [self.view addSubview:didView];
    
    CanAddListView *canView = [[CanAddListView alloc] initWithFrame:CGRectMake(0, 64 + (kScreenHeight - 64 - 10) * 0.5 + 10, kScreenWidth, (kScreenHeight - 64 - 10) * 0.5)];
    canView.cellDelegate = self;
    [self.view addSubview:canView];
    
}


#pragma mark - 点击了切换网站的单元格
- (void)DidAddListViewIndexSelect:(NSInteger)index {
    
    FadeAlertView *showMessage = [[FadeAlertView alloc] init];
    [showMessage showAlertWith:[NSString stringWithFormat:@"%ld", index]];
    
}


#pragma mark - 点击了添加更多网站的单元格
- (void)CanAddListViewIndexSelect:(NSInteger)index {
    
    FadeAlertView *showMessage = [[FadeAlertView alloc] init];
    [showMessage showAlertWith:[NSString stringWithFormat:@"%ld", index]];
    
    
}


































@end
