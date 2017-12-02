//
//  DiscoverViewController.m
//  LFBaseFrameTwo
//
//  Created by 曹奕程 on 2017/11/2.
//  Copyright © 2017年 admin. All rights reserved.
//

// 发现

#import "DiscoverViewController.h"
#import "MainBannerView.h"
#import "NewsListCell.h"
#import "TGWebViewController.h"
#import "NewsListModel.h"
#import "NewsListHeaderView.h"
#import "NewsEnumView.h"
#import "SearchViewController.h"
#import "SearchWithWebViewController.h"



@interface DiscoverViewController () <UITableViewDelegate, UITableViewDataSource, NewsEnumViewDlegate> {
    
    UITableView *_listTableView;    // 列表
    
    NSMutableArray *_dataArray;     // 数据列表
    
    NSInteger currentPage;          // 当前页
    
    NewsEnumView *enumView;         // 分类视图
    
    NSString *art_type;             // （文章类别：全部 -1 招标信息 1  中标公示 0）
    
}

@end

@implementation DiscoverViewController

#pragma mark ========================================生命周期========================================
- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 控制器的初始化
    self.title = @"主页";
    self.view.backgroundColor = Background_Color;
    _dataArray = [NSMutableArray array];
    currentPage = 1;
    art_type = @"-1";
    
    // 创建视图
    [self creatSubviewsAction];
    
    
    
    
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    // 加载数据
    [self loadNewsListAction:NO];
    
    
}


#pragma mark ========================================私有方法=============================================

#pragma mark - 创建视图
- (void)creatSubviewsAction {
    
    // 导航栏右边的两个按钮
    UIButton *searchButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [searchButton setImage:[UIImage imageNamed:@"sou"]  forState:UIControlStateNormal];
    [searchButton setTintColor:[UIColor whiteColor]];
    searchButton.frame = CGRectMake(0, 0, 30, 30);
    [searchButton addTarget:self action:@selector(searchButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightBarItemA = [[UIBarButtonItem alloc] initWithCustomView:searchButton];
    
    
    // 导航栏右边的添加按钮
    UIButton *rankButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [rankButton setImage:[UIImage imageNamed:@"select"]  forState:UIControlStateNormal];
    [rankButton setTintColor:[UIColor whiteColor]];
    rankButton.frame = CGRectMake(0, 0, 30, 30);
    [rankButton addTarget:self action:@selector(rankButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightBarItemB = [[UIBarButtonItem alloc] initWithCustomView:rankButton];
    self.navigationItem.rightBarButtonItems = @[rightBarItemB, rightBarItemA];
    
    // 列表
    _listTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, kScreenWidth, kScreenHeight - 64 - 49)
                                                  style:UITableViewStyleGrouped];
    _listTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    _listTableView.backgroundColor = [UIColor clearColor];
    _listTableView.contentInset = UIEdgeInsetsMake(-35, 0, 0, 0);
    _listTableView.rowHeight = 60;
    _listTableView.delegate = self;
    _listTableView.dataSource = self;
    [_listTableView registerNib:[UINib nibWithNibName:@"NewsListCell" bundle:[NSBundle mainBundle]]
         forCellReuseIdentifier:@"NewsListCell"];
    [_listTableView registerNib:[UINib nibWithNibName:@"NewsListHeaderView" bundle:[NSBundle mainBundle]] forHeaderFooterViewReuseIdentifier:@"NewsListHeaderView"];
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
    
    // 分类视图
    enumView = [[NewsEnumView alloc] initWithFrame:CGRectMake(0, 24, kScreenWidth, 40)];
    enumView.delegate = self;
    [self.view addSubview:enumView];
    
}

#pragma mark ========================================动作响应=============================================

#pragma mark - 点击搜索
- (void)searchButtonAction:(UIButton *)button {
    
    SearchViewController *ctrl = [[SearchViewController alloc] init];
    ctrl.type = @"0";   // 搜索文章
    [self.navigationController pushViewController:ctrl animated:YES];
    
}

#pragma mark - 点击排序
- (void)rankButtonAction:(UIButton *)button {
    
    if (enumView.transform.ty == 40) {
        [UIView animateWithDuration:.2 animations:^{
            enumView.transform = CGAffineTransformMakeTranslation(0, 0);
            _listTableView.transform = CGAffineTransformMakeTranslation(0, 0);
        }];
    } else {
        [UIView animateWithDuration:.2 animations:^{
            enumView.transform = CGAffineTransformMakeTranslation(0, 40);
            _listTableView.transform = CGAffineTransformMakeTranslation(0, 40);
        }];
    }
    
    
}



#pragma mark - 收藏
- (void)collectButtonAction:(UIButton *)button {
    
    NewsListModel *model = _dataArray[button.tag - 1000];
    
    
    NSString *favorite;
    
    
    if ([model.megmt_id isEqualToString:@"<null>"] ||
        [model.megmt_id isEqualToString:@"(null)"] ||
        [model.megmt_id isEqualToString:@""]) {

        // 执行收藏
        favorite = @"0";

    } else {

        // 取消收藏
        favorite = @"1";
    }

    [SOAPUrlSession collectActionWithMegmt_id:model.megmt_id
                                  megmt_artid:model.megmt_artid
                                  mwsub_webid:model.mwsub_webid
                                     favorite:favorite
                                      success:^(id responseObject) {
                                          
                                          NSString *responseCode = [NSString stringWithFormat:@"%@",responseObject[@"code"]];
                                          
                                          if ([responseCode isEqualToString:@"0"]) {
                                          
                                          
                                          }
                                          
                                          //主线程更新视图
                                          dispatch_async(dispatch_get_main_queue(), ^{
                                              
                                              FadeAlertView *showMessage = [[FadeAlertView alloc] init];
                                              [showMessage showAlertWith:[NSString stringWithFormat:@"%@", responseObject[@"msg"]]];
                                              
                                              // 重新获取列表
                                              [self loadNewsListAction:NO];
                                              
                                          });
                                          
                                          
                                      } failure:^(NSError *error) {
                                          
                                          dispatch_async(dispatch_get_main_queue(), ^{
                                              
                                              FadeAlertView *showMessage = [[FadeAlertView alloc] init];
                                              [showMessage showAlertWith:@"请求失败"];
                                              
                                          });
                                          
                                      }];
    
    
    
    
}


#pragma mark - 跳转到该网站下的列表
- (void)signButtonAction:(UIButton *)button {
    
    NewsListModel *model = _dataArray[button.tag - 2000];
    
    SearchWithWebViewController *ctrl = [[SearchWithWebViewController alloc] init];
    
    ctrl.name = model.ws_name;
    ctrl.art_subwsid = model.megmt_artid;
    
    [self.navigationController pushViewController:ctrl animated:YES];
    
}



#pragma mark ========================================网络请求=============================================

#pragma mark - 获取新闻列表(是否是上拉加载)
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
    [SOAPUrlSession getNewsWithArt_type:art_type art_subwsid:@"-1" page:page success:^(id responseObject) {
        
        
        NSString *responseCode = [NSString stringWithFormat:@"%@",responseObject[@"code"]];
        
        if ([responseCode isEqualToString:@"0"]) {
            
            NSArray *list = responseObject[@"data"];
            
            // 封装数据
            for (NSDictionary *dic in list) {
                
                NewsListModel *model = [[NewsListModel alloc] init];
                model.website_id = [NSString stringWithFormat:@"%@", dic[@"website_id"]];
                model.ws_name = [NSString stringWithFormat:@"%@", dic[@"ws_name"]];
                model.ws_logo = [NSString stringWithFormat:@"%@", dic[@"ws_logo"]];
                model.art_type = [NSString stringWithFormat:@"%@", dic[@"art_type"]];
                model.mwsub_id = [NSString stringWithFormat:@"%@", dic[@"mwsub_id"]];
                model.megmt_id = [NSString stringWithFormat:@"%@", dic[@"megmt_id"]];
                model.art_title = [NSString stringWithFormat:@"%@", dic[@"art_title"]];
                model.megmt_artid = [NSString stringWithFormat:@"%@", dic[@"id"]];
                model.listId = [NSString stringWithFormat:@"%@", dic[@"id"]];
                model.art_creation_date = [NSString stringWithFormat:@"%@", dic[@"art_creation_date"]];
                model.mwsub_webid = [NSString stringWithFormat:@"%@", dic[@"website_id"]];
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
    
    return 95.0;
    
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    return 0.01;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return kScreenWidth * 0.35;
    
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    NewsListHeaderView *view = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"NewsListHeaderView"];
    
    
    return view;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    

    NewsListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NewsListCell"
                                                          forIndexPath:indexPath];
    
    if (_dataArray.count == 0) {
        
    } else {
        
        NewsListModel *model = _dataArray[indexPath.row];
        
        cell.nameLabel.text = model.art_title;              // 新闻标题
        cell.contentLabel.text = model.art_content;         // 新闻内容
        [cell.signButton setTitle:model.ws_name forState:UIControlStateNormal];     // 网站名称
        cell.timeLabel.text = model.art_creation_date;      // 日期
        cell.seeLabel.text = model.art_readnum;             // 阅读量
        
        NSString *path = [NSString stringWithFormat:@"%@%@", Java_Image_URL, model.ws_logo];    // 标识
        [cell.signImageView sd_setImageWithURL:[NSURL URLWithString:path]
                              placeholderImage:[UIImage imageNamed:@"loadfail-0"]
                                       options:SDWebImageRetryFailed];
        
        if ([model.megmt_id isEqualToString:@"<null>"] ||
            [model.megmt_id isEqualToString:@"(null)"] ||
            [model.megmt_id isEqualToString:@""]) {
            // 未收藏
            [cell.collectButton setImage:[UIImage imageNamed:@"uncollect_s"] forState:UIControlStateNormal];
        } else {
            [cell.collectButton setImage:[UIImage imageNamed:@"collect_s"] forState:UIControlStateNormal];
        }
        
        cell.collectButton.tag = 1000 + indexPath.row;
        [cell.collectButton addTarget:self action:@selector(collectButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        
        
        if ([model.mwsub_webid isEqualToString:@"<null>"] ||
            [model.mwsub_webid isEqualToString:@"(null)"] ||
            [model.mwsub_webid isEqualToString:@""]) {
            // 未订阅
            [cell.dingImageView setImage:[UIImage imageNamed:@""]];
        } else {
            [cell.dingImageView setImage:[UIImage imageNamed:@"ding"]];
        }
        
        cell.signButton.tag = 2000 + indexPath.row;
        [cell.signButton addTarget:self action:@selector(signButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        
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
        ctrl.visitor = @"3980e5cfdf171758202aa29b58e3de3f";     // CYC666
        ctrl.token = @"eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJodHRwOlwvXC9iaWRhcHAuY29tIiwibW9iaWxlIjoiMTM3MDUwMzg0MjgiLCJtYnJfaWQiOiIzOCIsImV4cCI6MTUxNDQzMDI2NCwiaWF0IjoxNTExODM4MjY0fQ.w5lNmDoaVUQDDU6E-5MGymkI9J5R4Gbj0Ysyj4EYVEQ";
        ctrl.webid = model.website_id;
        ctrl.artid = model.listId;
        
        [self.navigationController pushViewController:ctrl animated:YES];
        
    }
    
    
    
}

#pragma mark - 分类选了类目
- (void)TopSearchViewIndexChange:(NSInteger)index {
    
    [UIView animateWithDuration:.2 animations:^{
        enumView.transform = CGAffineTransformMakeTranslation(0, 0);
        _listTableView.transform = CGAffineTransformMakeTranslation(0, 0);
    } completion:^(BOOL finished) {
        
        if (index == 0) {
            
            // 全部文章
            art_type = @"-1";
        } else if (index == 1) {
            
            // 招标信息
            art_type = @"1";
        } else {
            
            // 中标信息
            art_type = @"0";
        }
        
        // 重新获取数据
        [self loadNewsListAction:NO];
//        [_listTableView.mj_header beginRefreshing];
        
    }];
    
    
    
    

    
}



#pragma mark ========================================通知================================================
















//{
//    // Request (POST http://47.92.86.242/bidapp/Api/index.php/Articles/selectArticles)
//    
//    // Create manager
//    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
//    
//    // Create request
//    NSMutableURLRequest* request = [[AFHTTPRequestSerializer serializer] requestWithMethod:@"POST" URLString:@"http://47.92.86.242/bidapp/Api/index.php/Articles/selectArticles" parameters:nil error:NULL];
//    
//    // Form URL-Encoded Body
//    NSDictionary* bodyParameters = @{
//                                     @"art_type":@"1",
//                                     };
//    
//    NSMutableURLRequest* request = [[AFHTTPRequestSerializer serializer] requestWithMethod:@"POST" URLString:@"http://47.92.86.242/bidapp/Api/index.php/Articles/selectArticles" parameters:bodyParameters error:NULL];
//    
//    // Add Headers
//    [request setValue:@"7d73e1a3747f32f36154cdfc5b6a5b56" forHTTPHeaderField:@"VISITOR"];
//    [request setValue:@"PHPSESSID=1s6bb92bmfjtp7p7lnu2h6h4g3" forHTTPHeaderField:@"Cookie"];
//    [request setValue:@"multipart/form-data" forHTTPHeaderField:@"enctype"];
//    [request setValue:@"eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJodHRwOlwvXC9iaWRhcHAuY29tIiwibW9iaWxlIjoiMTUwMTA4NDg5NDAiLCJtYnJfaWQiOiI0MCIsImV4cCI6MTUxNDc4NDc0MiwiaWF0IjoxNTEyMTkyNzQyfQ.dvEKQUpio-_7L0bEGUwBqjS_CVR7nBFznl2QCbjhj5Y" forHTTPHeaderField:@"TKID"];
//    [request setValue:@"application/x-www-form-urlencoded; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
//    
//    // Fetch Request
//    AFHTTPRequestOperation *operation = [manager HTTPRequestOperationWithRequest:request
//                                                                         success:^(AFHTTPRequestOperation *operation, id responseObject) {
//                                                                             NSLog(@"HTTP Response Status Code: %ld", [operation.response statusCode]);
//                                                                             NSLog(@"HTTP Response Body: %@", responseObject);
//                                                                         } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//                                                                             NSLog(@"HTTP Request failed: %@", error);
//                                                                         }];
//    
//    [manager.operationQueue addOperation:operation]
//}






















@end
