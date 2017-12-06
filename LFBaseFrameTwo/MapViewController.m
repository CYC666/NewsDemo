//
//  MapViewController.m
//  LFBaseFrameTwo
//
//  Created by 曹奕程 on 2017/11/2.
//  Copyright © 2017年 admin. All rights reserved.
//

// 地图

#import "MapViewController.h"
#import "DiscoverListCell.h"
#import "YourLikeViewController.h"
#import "WebForCommonViewController.h"
#import "TodayStudyViewController.h"



@interface MapViewController () <UITableViewDelegate, UITableViewDataSource> {
    
    UITableView *_listTableView;
    
    
    
}

@end

@implementation MapViewController

#pragma mark ========================================生命周期========================================
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"发现";
    self.view.backgroundColor = Background_Color;
    // 创建视图
    [self creatSubViewsAction];
    
    
    
}


#pragma mark ========================================私有方法=============================================

#pragma mark - 创建视图
- (void)creatSubViewsAction {
    
    // 表视图
    _listTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, kScreenWidth, kScreenHeight - 64)
                                                  style:UITableViewStylePlain ];
    _listTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    _listTableView.backgroundColor = [UIColor clearColor];
    _listTableView.delegate = self;
    _listTableView.dataSource = self;
    [_listTableView registerNib:[UINib nibWithNibName:@"DiscoverListCell" bundle:[NSBundle mainBundle]]
         forCellReuseIdentifier:@"DiscoverListCell"];
    [self.view addSubview:_listTableView];
    
#ifdef __IPHONE_11_0
    if(@available(iOS 11.0, *)){
        _listTableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
#else
    
#endif
    self.automaticallyAdjustsScrollViewInsets = NO;
    
}

#pragma mark ========================================动作响应=============================================


#pragma mark ========================================网络请求=============================================

#pragma mark ========================================代理方法=============================================

#pragma mark - 表视图代理方法
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 3;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 50;
    
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    return 0.01;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 0.01;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    DiscoverListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DiscoverListCell"
                                                            forIndexPath:indexPath];
    
    if (indexPath.row == 0) {
        
        cell.imageView.image = [UIImage imageNamed:@"todstu"];
        cell.nameLabel.text = @"今日学习";
        
    } else if (indexPath.row == 1) {
        
        cell.imageView.image = [UIImage imageNamed:@"guefav"];
        cell.nameLabel.text = @"猜你喜欢";
        
    } else {
        
        cell.imageView.image = [UIImage imageNamed:@"calculator"];
        cell.nameLabel.text = @"开标计算器";
        
    }
    
    
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.row == 0) {
        
        
        
        TodayStudyViewController *ctrl = [[TodayStudyViewController alloc] init];
        [self.navigationController pushViewController:ctrl animated:YES];
        
    } else if (indexPath.row == 1) {
        
        YourLikeViewController *ctrl = [[YourLikeViewController alloc] init];
        [self.navigationController pushViewController:ctrl animated:YES];
        
    } else {
        
        
        
    }
    

    
}


#pragma mark ========================================通知================================================





































@end
