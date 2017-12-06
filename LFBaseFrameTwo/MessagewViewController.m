//
//  MessagewViewController.m
//  LFBaseFrameTwo
//
//  Created by 曹老师 on 2017/11/29.
//  Copyright © 2017年 admin. All rights reserved.
//

#import "MessagewViewController.h"
#import "MessageListCell.h"
#import "MessageListModel.h"

@interface MessagewViewController ()<UITableViewDelegate, UITableViewDataSource> {
    
    UITableView *_listTableView;

    NSInteger currentPage;
    
    NSMutableArray *_dataArray;
    
}

@end

@implementation MessagewViewController


#pragma mark ========================================生命周期========================================
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"消息";
    self.view.backgroundColor = [UIColor whiteColor];
    currentPage = 1;
    _dataArray = [NSMutableArray array];
    
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
    [_listTableView registerNib:[UINib nibWithNibName:@"MessageListCell" bundle:[NSBundle mainBundle]]
         forCellReuseIdentifier:@"MessageListCell"];
    [self.view addSubview:_listTableView];
    
#ifdef __IPHONE_11_0
    if(@available(iOS 11.0, *)){
        _listTableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
#else
    
#endif
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        [self loadNewsListAction:NO];
        
        //关闭刷新
        [_listTableView.mj_header endRefreshing];
    }];
    header.stateLabel.font = [UIFont systemFontOfSize:12];
    header.lastUpdatedTimeLabel.font = [UIFont systemFontOfSize:11];
    _listTableView.mj_header = header;
    
    MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        
        [self loadNewsListAction:YES];
        
        //关闭刷新
        [_listTableView.mj_footer endRefreshing];
    }];
    footer.automaticallyHidden = YES;//自动根据有无数据来显示和隐藏
    footer.stateLabel.font = [UIFont systemFontOfSize:12];
    _listTableView.mj_footer = footer;
    
    [self loadNewsListAction:NO];
    
}
#pragma mark ========================================动作响应=============================================

#pragma mark ========================================网络请求=============================================

#pragma mark - 获取收藏列表(是否是上拉加载)
- (void)loadNewsListAction:(BOOL)isFooter {
    
    if (isFooter) {
        
        // 上拉加载
        currentPage++;
    } else {
        
        // 下拉刷新
        currentPage = 1;
        [_dataArray removeAllObjects];
    }
    
    NSString *page = [NSString stringWithFormat:@"%ld", currentPage];
    [SOAPUrlSession messageCur_Page:page success:^(id responseObject) {
        
        NSString *responseCode = [NSString stringWithFormat:@"%@",responseObject[@"code"]];
        
        if ([responseCode isEqualToString:@"0"]) {
            
            NSArray *list = responseObject[@"data"];
            
            // 封装数据
            for (NSDictionary *dic in list) {
                
                MessageListModel *model = [[MessageListModel alloc] init];
                model.listId = [NSString stringWithFormat:@"%@", dic[@"id"]];
                model.mmsg_readflg = [NSString stringWithFormat:@"%@", dic[@"mmsg_readflg"]];
                model.mmsg_type_pic_path = [NSString stringWithFormat:@"%@", dic[@"mmsg_type_pic_path"]];
                model.mmsg_title = [NSString stringWithFormat:@"%@", dic[@"mmsg_title"]];
                model.mmsg_remark = [NSString stringWithFormat:@"%@", dic[@"mmsg_remark"]];
                model.mmsg_content = [NSString stringWithFormat:@"%@", dic[@"mmsg_content"]];
                model.mmsg_creation_date = [NSString stringWithFormat:@"%@", dic[@"mmsg_creation_date"]];
                
                
                [_dataArray addObject:model];
            }
        } else if ([responseCode isEqualToString:@"1"]) {
            
            
            
        }
        
        
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [_listTableView reloadData];
            
        });
        
        
    } failure:^(NSError *error) {
        
        //主线程更新视图
        dispatch_async(dispatch_get_main_queue(), ^{
            
            FadeAlertView *showMessage = [[FadeAlertView alloc] init];
            [showMessage showAlertWith:@"请求失败"];
            
        });
        
        
    }];
    
    
}



#pragma mark ========================================代理方法=============================================

#pragma mark - 表视图代理方法
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return _dataArray.count;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 60.0;
    
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    return 0.01;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 0.01;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    MessageListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MessageListCell"
                                                            forIndexPath:indexPath];
    
    if (_dataArray.count == 0) {
        
    } else {
        
        MessageListModel *model = _dataArray[indexPath.row];
        
        // 图片
        NSString *path = [NSString stringWithFormat:@"http://47.92.86.242/bidapp_front/img/%@", model.mmsg_type_pic_path];
        [cell.iconImageView sd_setImageWithURL:[NSURL URLWithString:path]
                              placeholderImage:[UIImage imageNamed:@"loadfail-0"]
                                       options:SDWebImageRetryFailed];
        
        cell.nameLabel.text = model.mmsg_title;
        cell.contentLabel.text = model.mmsg_content;
        cell.timeLabel.text = model.mmsg_creation_date;
        
        if ([model.mmsg_readflg isEqualToString:@"1"]) {
            cell.redPoint.hidden = YES;
        } else {
            cell.redPoint.hidden = NO;
        }
    }
    
    
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (_dataArray.count == 0) {
        
    } else {
        
        MessageListModel *model = _dataArray[indexPath.row];
    
    
    
    
    }
    
}


#pragma mark ========================================通知================================================






































@end
