//
//  WebListViewController.m
//  LFBaseFrameTwo
//
//  Created by 曹老师 on 2017/12/3.
//  Copyright © 2017年 admin. All rights reserved.
//

#import "WebListViewController.h"
#import "DListCell.h"
#import "DingModel.h"
#import "SearchViewController.h"
#import "SearchWithWebViewController.h"
#import "NewsListModel.h"

@interface WebListViewController () <UITableViewDelegate, UITableViewDataSource> {
    
    UITableView *_listTableView;
    
    NSMutableArray *dataArray;
    
    NSInteger currentPage;
    
}

@end

@implementation WebListViewController

#pragma mark ========================================生命周期========================================
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = Background_Color;
    dataArray = [NSMutableArray array];
    currentPage = 1;
    
    // 创建视图
    [self creatSubViewsAction];
    
    
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    // 获取数据
    [self loadHoyTypeAction:NO];
    
    
}


#pragma mark ========================================私有方法=============================================

#pragma mark - 创建视图
- (void)creatSubViewsAction {
    
    // 导航栏两个按钮
    UIButton *searchButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [searchButton setImage:[UIImage imageNamed:@"sou"]  forState:UIControlStateNormal];
    [searchButton setTintColor:[UIColor whiteColor]];
    searchButton.frame = CGRectMake(0, 0, 30, 30);
    [searchButton addTarget:self action:@selector(searchButtonAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightBarItemA = [[UIBarButtonItem alloc] initWithCustomView:searchButton];
    self.navigationItem.rightBarButtonItem = rightBarItemA;
    
    
    // 表视图
    CGFloat startY = 0;
    if (kScreenHeight == 812) {
        startY = 88;    // iPhone X
    } else {
        startY = 64;    // 其他机型
    }
    _listTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, startY, kScreenWidth, kScreenHeight - startY)
                                                  style:UITableViewStylePlain ];
    _listTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    _listTableView.backgroundColor = [UIColor clearColor];
    _listTableView.delegate = self;
    _listTableView.dataSource = self;
    [_listTableView registerNib:[UINib nibWithNibName:@"DListCell" bundle:[NSBundle mainBundle]]
         forCellReuseIdentifier:@"DListCell"];
    [self.view addSubview:_listTableView];
    
#ifdef __IPHONE_11_0
    if(@available(iOS 11.0, *)){
        _listTableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
#else
    
#endif
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        [self loadHoyTypeAction:NO];
        
        //关闭刷新
        [_listTableView.mj_header endRefreshing];
    }];
    header.stateLabel.font = [UIFont systemFontOfSize:12];
    header.lastUpdatedTimeLabel.font = [UIFont systemFontOfSize:11];
    _listTableView.mj_header = header;
    
    MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        
        [self loadHoyTypeAction:YES];
        
        //关闭刷新
        [_listTableView.mj_footer endRefreshing];
    }];
    footer.automaticallyHidden = YES;//自动根据有无数据来显示和隐藏
    footer.stateLabel.font = [UIFont systemFontOfSize:12];
    _listTableView.mj_footer = footer;
    
    
}

#pragma mark ========================================动作响应=============================================

#pragma mark - 搜索
- (void)searchButtonAction {
    
    SearchViewController *ctrl = [[SearchViewController alloc] init];
    ctrl.type = @"2";   // 搜索专栏
    [self.navigationController pushViewController:ctrl animated:YES];
    
    
}

#pragma mark - 点击订阅
- (void)dingButtonAction:(UIButton *)button {
    
    DingModel *model = dataArray[button.tag];
    
    NSString *art_subws_order;
    
    if ([model.mwsub_id isEqualToString:@"<null>"] ||
        [model.mwsub_id isEqualToString:@"(null)"] ||
        [model.mwsub_id isEqualToString:@""]) {
        
        // 执行收藏
        art_subws_order = @"0";
        
    } else {
        
        // 取消收藏
        art_subws_order = @"1";
    }
    
    
    
    [SOAPUrlSession setDingActionWithMwsub_wsid:model.mwsub_webid
                                       mwsub_id:model.mwsub_id
                                art_subws_order:art_subws_order
                                        success:^(id responseObject) {
                                            
                                            NSString *responseCode = [NSString stringWithFormat:@"%@",responseObject[@"code"]];
                                            
                                            if ([responseCode isEqualToString:@"0"]) {
                                                
                                                NSString *iconflg = [NSString stringWithFormat:@"%@", responseObject[@"data"][@"iconflg"]];
                                                if (iconflg.integerValue == 0) {
                                                    
                                                    // 取消成功
                                                    model.mwsub_id = @"<null>";
                                                    
                                                } else {
                                                    
                                                    // 收藏成功
                                                    model.mwsub_id = [NSString stringWithFormat:@"%@", responseObject[@"data"][@"resultid"]];
                                                }
                                                
                                            }
                                            
                                            
                                            //主线程更新视图
                                            dispatch_async(dispatch_get_main_queue(), ^{
                                                
                                                // 刷新单元格
                                                [_listTableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:button.tag inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
                                                
                                            });
                                            
                                        } failure:^(NSError *error) {
                                            
                                            //主线程更新视图
                                            dispatch_async(dispatch_get_main_queue(), ^{
                                                
                                                FadeAlertView *showMessage = [[FadeAlertView alloc] init];
                                                [showMessage showAlertWith:@"请求失败"];
                                                
                                            });
                                            
                                        }];
    
}

#pragma mark ========================================网络请求=============================================


#pragma mark - 获取热门推荐
- (void)loadHoyTypeAction:(BOOL)isFooter {
    
    if (isFooter) {
        currentPage++;
    } else {
        currentPage = 1;
        [dataArray removeAllObjects];
    }
    
    NSString *cur_page = [NSString stringWithFormat:@"%ld", currentPage];
    [SOAPUrlSession hotAneNewWebsType:_websType
                             cur_page:cur_page
                              success:^(id responseObject) {
                                  
                                  NSString *responseCode = [NSString stringWithFormat:@"%@",responseObject[@"code"]];
                                  
                                  if ([responseCode isEqualToString:@"0"]) {
                                      
                                      NSArray *list = responseObject[@"data"];
                                      
                                      // 封装数据
                                      for (NSInteger i = 0; i < list.count; i++) {
                                          
                                          NSDictionary *dic = list[i];
                                          
                                          DingModel *model = [[DingModel alloc] init];
                                          model.mwsub_id = [NSString stringWithFormat:@"%@", dic[@"subscribe_id"]];
                                          //                                              model.mwsub_mbrid = [NSString stringWithFormat:@"%@", dic[@"mwsub_mbrid"]];
                                          model.mwsub_webid = [NSString stringWithFormat:@"%@", dic[@"webid"]];
                                          model.ws_logo = [NSString stringWithFormat:@"%@", dic[@"ws_logo"]];
                                          model.ws_name = [NSString stringWithFormat:@"%@", dic[@"ws_name"]];
                                          
                                          [dataArray addObject:model];
                                          
                                      }
                                      
                                      
                                  }
                                  
                                  //主线程更新视图
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
    
    return dataArray.count;
    
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
    
    DListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DListCell"
                                                      forIndexPath:indexPath];
    
    if (dataArray.count == 0) {
        
    } else {
        
        DingModel *model = dataArray[indexPath.row];
        
        // 图片
        NSString *path = [NSString stringWithFormat:@"%@%@", Java_Image_URL, model.ws_logo];
        [cell.iconImageView sd_setImageWithURL:[NSURL URLWithString:path]
                              placeholderImage:[UIImage imageNamed:@"loadfail-0"]
                                       options:SDWebImageRetryFailed];
        
        // 名字
        cell.nameLabel.text = model.ws_name;
        
        if ([model.mwsub_id isEqualToString:@"<null>"] ||
            [model.mwsub_id isEqualToString:@"(null)"] ||
            [model.mwsub_id isEqualToString:@""]) {
            
            // 未订阅
            [cell.dingButton setTitle:@"订阅" forState:UIControlStateNormal];
            [cell.dingButton setTitleColor:Label_Color_B forState:UIControlStateNormal];
            [cell.dingButton setBackgroundColor:Background_Color];
        } else {
            
            [cell.dingButton setTitle:@"已订" forState:UIControlStateNormal];
            [cell.dingButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [cell.dingButton setBackgroundColor:Publie_Color];
            
        }
        
        
    }
    
    cell.dingButton.tag = indexPath.row;
    [cell.dingButton addTarget:self action:@selector(dingButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
    DingModel *modelA = dataArray[indexPath.row];
    
    NewsListModel *model = [[NewsListModel alloc] init];
    model.website_id = modelA.mwsub_webid;
    model.ws_name = modelA.ws_name;
    model.ws_logo = modelA.ws_logo;
    model.art_type = @"";
    model.mwsub_id = modelA.mwsub_id;
    model.megmt_id = @"";
    model.art_title = @"";
    model.megmt_artid = @"";
    model.listId = @"";
    model.art_creation_date = @"";
    model.mwsub_webid = modelA.mwsub_webid;
    model.art_content = @"";
    model.mwsub_mbrid = modelA.mwsub_mbrid;
    model.art_readnum = @"";
    
    
    
    SearchWithWebViewController *ctrl = [[SearchWithWebViewController alloc] init];
    
//    ctrl.delegate = self;
    ctrl.ctrlModel = model;
    
    [self.navigationController pushViewController:ctrl animated:YES];
    
    
    
}


#pragma mark ========================================通知================================================




@end
