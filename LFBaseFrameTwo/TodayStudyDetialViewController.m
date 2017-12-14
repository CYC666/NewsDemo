//
//  TodayStudyDetialViewController.m
//  LFBaseFrameTwo
//
//  Created by 曹奕程 on 2017/12/7.
//  Copyright © 2017年 admin. All rights reserved.
//

#import "TodayStudyDetialViewController.h"
#import "TodayStudyDetialCell.h"


@interface TodayStudyDetialViewController () <UITableViewDelegate, UITableViewDataSource> {
    
    UITableView *_listTableView;
    
    
    
}

@end

@implementation TodayStudyDetialViewController

#pragma mark ========================================生命周期========================================
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"今日学习";
    self.view.backgroundColor = [UIColor whiteColor];
    // 创建视图
    [self creatSubViewsAction];
    
    
    
}


#pragma mark ========================================私有方法=============================================

#pragma mark - 创建视图
- (void)creatSubViewsAction {
    
    // 表视图
    CGFloat startY = 0;
    if (kScreenHeight == 812) {
        startY = 88;    // iPhone X
    } else {
        startY = 64;    // 其他机型
    }
    _listTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, startY, kScreenWidth, kScreenHeight - startY)
                                                  style:UITableViewStylePlain ];
    _listTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _listTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    _listTableView.backgroundColor = [UIColor clearColor];
    _listTableView.estimatedRowHeight = 300;
    _listTableView.rowHeight = UITableViewAutomaticDimension;
    _listTableView.delegate = self;
    _listTableView.dataSource = self;
    [_listTableView registerNib:[UINib nibWithNibName:@"TodayStudyDetialCell" bundle:[NSBundle mainBundle]]
         forCellReuseIdentifier:@"TodayStudyDetialCell"];
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
    
    return 1;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    return 0.01;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 0.01;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    TodayStudyDetialCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TodayStudyDetialCell"
                                                            forIndexPath:indexPath];
    
    cell.nameLabel.text = _ts_title;
    
    cell.fromLabel.text = @"鲣鸟科技  Gannetec.com";
    
    cell.timeLabel.text = _ts_creation_date;
    
    NSString *path = [NSString stringWithFormat:@"http://47.92.86.242/bidapp/Api/Public/%@", _ts_picurl];
    [cell.iconImageView sd_setImageWithURL:[NSURL URLWithString:path]
                          placeholderImage:[UIImage imageNamed:@"loadfail-0"]
                                   options:SDWebImageRetryFailed];
    
    cell.contentLabel.text = _ts_content;
    
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}


#pragma mark ========================================通知================================================



@end
