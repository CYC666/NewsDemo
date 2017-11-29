//
//  CollectViewController.m
//  LFBaseFrameTwo
//
//  Created by 曹奕程 on 2017/11/2.
//  Copyright © 2017年 admin. All rights reserved.
//

#import "CollectViewController.h"
#import "PersonalListCell.h"
#import "PersonalListHeaderView.h"

@interface CollectViewController () <UITableViewDelegate, UITableViewDataSource> {
    
    UITableView *_listTableView;
    
    
}

@end

@implementation CollectViewController


#pragma mark ========================================生命周期========================================
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"我的";
    self.view.backgroundColor = Background_Color;
    
    // 创建视图
    [self creatSubViewsAction];
    
    
    
}


#pragma mark ========================================私有方法=============================================

#pragma mark - 创建视图
- (void)creatSubViewsAction {
    
    // 表视图
    _listTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - 49)
                                                  style:UITableViewStylePlain ];
    _listTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    _listTableView.backgroundColor = [UIColor clearColor];
    _listTableView.rowHeight = 60;
    _listTableView.delegate = self;
    _listTableView.dataSource = self;
    [_listTableView registerNib:[UINib nibWithNibName:@"PersonalListCell" bundle:[NSBundle mainBundle]]
         forCellReuseIdentifier:@"PersonalListCell"];
    [_listTableView registerNib:[UINib nibWithNibName:@"PersonalListHeaderView" bundle:[NSBundle mainBundle]] forHeaderFooterViewReuseIdentifier:@"PersonalListHeaderView"];
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
    
    return 2;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (section == 0) {
        return 4;
    } else {
        return 1;
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 60.0;
    
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    return 0.01;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    if (section == 0) {
        return kScreenWidth * 0.75;
    } else {
        return 10.0;
    }
    
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    if (section == 0) {
        PersonalListHeaderView *view = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"PersonalListHeaderView"];
        
        
        
        return view;
    } else {
        return [[UIView alloc] initWithFrame:CGRectZero];
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    PersonalListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PersonalListCell"
                                                            forIndexPath:indexPath];
    
    if (indexPath.section == 0) {
        
        if (indexPath.row == 0) {
            
            cell.iconImageView.image = [UIImage imageNamed:@"message"];
            cell.nameLabel.text = @"消息";
        } else if (indexPath.row == 1) {
            
            cell.iconImageView.image = [UIImage imageNamed:@"readSet"];
            cell.nameLabel.text = @"订阅设置";
        } else if (indexPath.row == 1) {
            
            cell.iconImageView.image = [UIImage imageNamed:@"yijian"];
            cell.nameLabel.text = @"意见反馈";
        } else {
            
            cell.iconImageView.image = [UIImage imageNamed:@"cookie"];
            cell.nameLabel.text = @"缓存清理";
        }
        
    } else {
        
        cell.iconImageView.image = [UIImage imageNamed:@"set"];
        cell.nameLabel.text = @"设置";
    }
    
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

#pragma mark ========================================通知================================================






































@end
