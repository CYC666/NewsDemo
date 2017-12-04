//
//  HistoryListViewController.m
//  LFBaseFrameTwo
//
//  Created by 曹奕程 on 2017/12/1.
//  Copyright © 2017年 admin. All rights reserved.
//

#import "HistoryListViewController.h"
#import "CollectListCell.h"
#import "NewsListModel.h"
#import "LoginViewController.h"
#import "TGWebViewController.h"

@interface HistoryListViewController () <UITableViewDelegate, UITableViewDataSource> {
    
    UserInformation *userInfo;              // 用户信息单例
    
    SmallFunctionTool *smallFunc;           // 工具方法单例
    
    UITableView *_listTableView;
    
    NSInteger currentPage;
    
    NSMutableArray *_dataArray;
    
}

@end

@implementation HistoryListViewController

#pragma mark ========================================生命周期========================================
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"历史浏览";
    self.view.backgroundColor = Background_Color;
    //初始化
    userInfo = [UserInformation sharedInstance];
    smallFunc = [SmallFunctionTool sharedInstance];
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
    _listTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _listTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    _listTableView.backgroundColor = [UIColor clearColor];
    _listTableView.delegate = self;
    _listTableView.dataSource = self;
    [_listTableView registerNib:[UINib nibWithNibName:@"CollectListCell" bundle:[NSBundle mainBundle]]
         forCellReuseIdentifier:@"CollectListCell"];
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

#pragma mark - 获取历史浏览列表(是否是上拉加载)
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
    [SOAPUrlSession getCollectWithPage:page megmt_type:@"1" success:^(id responseObject) {
        
        NSString *responseCode = [NSString stringWithFormat:@"%@",responseObject[@"code"]];
        
        if ([responseCode isEqualToString:@"0"]) {
            
            NSArray *list = responseObject[@"data"];
            
            // 封装数据
            for (NSDictionary *dic in list) {
                
                NewsListModel *model = [[NewsListModel alloc] init];
                model.website_id = [NSString stringWithFormat:@"%@", dic[@"webid"]];
                model.ws_name = [NSString stringWithFormat:@"%@", dic[@"ws_name"]];
                model.ws_logo = [NSString stringWithFormat:@"%@", dic[@"ws_logo"]];
                model.art_type = [NSString stringWithFormat:@"%@", dic[@"art_type"]];
                model.mwsub_id = [NSString stringWithFormat:@"%@", dic[@"mwsub_id"]];
                model.megmt_id = [NSString stringWithFormat:@"%@", dic[@"megmt_id"]];
                model.art_title = [NSString stringWithFormat:@"%@", dic[@"art_title"]];
                model.megmt_artid = [NSString stringWithFormat:@"%@", dic[@"megmt_artid"]];
                model.listId = [NSString stringWithFormat:@"%@", dic[@"art_id"]];
                model.art_creation_date = [NSString stringWithFormat:@"%@", dic[@"art_creation_date"]];
                model.mwsub_webid = [NSString stringWithFormat:@"%@", dic[@"webid"]];
                model.art_content = [NSString stringWithFormat:@"%@", dic[@"art_content"]];
                model.mwsub_mbrid = [NSString stringWithFormat:@"%@", dic[@"mwsub_mbrid"]];
                model.art_readnum = [NSString stringWithFormat:@"%@", dic[@"art_readnum"]];
                
                [_dataArray addObject:model];
            }
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
    
    
    
    
    
    
    
    //返回数据
    /*
     "website_id" : "1",
     "ws_name" : "中国政府采购网",
     "ws_logo" : "zfcg_logo.jpg",
     "art_type" : "0",
     "mwsub_id" : null,
     "megmt_id" : null,
     "art_title" : "中山大学南校园游泳池及网球场改造工程中标公告",
     "megmt_artid" : null,
     "id" : "12219",
     "art_creation_date" : "2017-11-14 09:36:00",
     "mwsub_webid" : null,
     "art_content" : "中山大学南校园游泳池及网球场改造工程项目（项目编号：中大招（工）[2017]133号 ） 组织评标工作已经结束，现将评标结果公示如下： 一、项目信息项目编号：中大招（工）[2017]133号 项",
     "mwsub_mbrid" : null,
     "art_readnum" : "1"
     */
    
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
    
    return 95;
    
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    return 0.01;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 0.01;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CollectListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CollectListCell"
                                                            forIndexPath:indexPath];
    
    if (_dataArray.count == 0) {
        
    } else {
        
        NewsListModel *model = _dataArray[indexPath.row];
        
        cell.nameLabel.text = model.art_title;              // 新闻标题
        cell.contentLabel.text = model.art_content;         // 新闻内容
        [cell.signButton setTitle:model.ws_name forState:UIControlStateNormal];     // 网站名称
        cell.timeLabel.text = model.art_creation_date;      // 日期

        
        NSString *path = [NSString stringWithFormat:@"%@%@", Java_Image_URL, model.ws_logo];    // 标识
        [cell.signImageView sd_setImageWithURL:[NSURL URLWithString:path]
                              placeholderImage:[UIImage imageNamed:@"loadfail-0"]
                                       options:SDWebImageRetryFailed];
        

    }
    
    
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (_dataArray.count == 0) {
        
    } else {
        
        NewsListModel *model = _dataArray[indexPath.row];
        
        // 跳转网页
        TGWebViewController *ctrl = [[TGWebViewController alloc] init];
        ctrl.webTitle = @"信息详情";
        ctrl.url = [NSString stringWithFormat:@"%@%@", Java_H5_URL, model.listId];
        if ([model.megmt_id isEqualToString:@"<null>"] ||
            [model.megmt_id isEqualToString:@"(null)"] ||
            [model.megmt_id isEqualToString:@""]) {
            
            ctrl.megmt_id = 0;
        } else {
            
            ctrl.megmt_id = model.megmt_id.integerValue;
        }
        
        ctrl.progressColor = [UIColor lightGrayColor];
        
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        NSString *mt_token = [userDefaults objectForKey:@"mt_token"];
        NSString *mt_visitor = [userDefaults objectForKey:@"mt_visitor"];
        
        if (mt_token == nil || [mt_token isEqualToString:@""]) {
            mt_token = @"";
            mt_visitor = @"";
            
        }
        
        ctrl.visitor = mt_visitor;
        ctrl.token = mt_token;
        ctrl.webid = model.website_id;
        ctrl.artid = model.listId;
        
        [self.navigationController pushViewController:ctrl animated:YES];
        
    }
    
    
    
}

#pragma mark - 允许左划编辑
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return YES;
    
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    return @"删除历史";
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (_dataArray.count == 0) {
        
    } else {
        
        NewsListModel *model = _dataArray[indexPath.row];
        
        [SOAPUrlSession deleteSeeActionWithartid:model.megmt_id webid:model.megmt_id success:^(id responseObject) {
                                              
                                              NSString *responseCode = [NSString stringWithFormat:@"%@",responseObject[@"code"]];
                                              NSString *msg = [NSString stringWithFormat:@"%@",responseObject[@"msg"]];
                                              
                                              if ([responseCode isEqualToString:@"0"]) {
                                                  
                                                  [_dataArray removeObject:model];
                                                  
                                                  //主线程更新视图
                                                  dispatch_async(dispatch_get_main_queue(), ^{
                                                      
                                                      [_listTableView reloadData];
                                                      
                                                  });
                                                  
                                              } else if ([msg isEqualToString:@"此操作必须登录"]) {
                                                  
                                                  //主线程更新视图
                                                  dispatch_async(dispatch_get_main_queue(), ^{
                                                      
                                                      // 清除数据
                                                      [userInfo clearData];
                                                      
                                                      // 跳转登录页面
                                                      LoginViewController *ctrl = [[LoginViewController alloc] init];
                                                      [self.navigationController pushViewController:ctrl animated:YES];
                                                      
                                                  });
                                                  
                                              }
                                              
                                              
                                              
                                          } failure:^(NSError *error) {
                                              
                                              dispatch_async(dispatch_get_main_queue(), ^{
                                                  
                                                  FadeAlertView *showMessage = [[FadeAlertView alloc] init];
                                                  [showMessage showAlertWith:@"请求失败"];
                                                  
                                              });
                                              
                                          }];
        
        
        
        
    }
    
}

#pragma mark ========================================通知================================================






































@end
