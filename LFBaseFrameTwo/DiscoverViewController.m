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



@interface DiscoverViewController () <UITableViewDelegate, UITableViewDataSource, NewsEnumViewDlegate> {
    
    UITableView *_listTableView;    // 列表
    
    NSMutableArray *_dataArray;     // 数据列表
    
    NSInteger currentPage;          // 当前页
    
    NewsEnumView *enumView;         // 分类视图
    
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
    
    // 创建视图
    [self creatSubviewsAction];
    
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
    _listTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, kScreenWidth, kScreenHeight - 64)
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
    
    FadeAlertView *showMessage = [[FadeAlertView alloc] init];
    [showMessage showAlertWith:@"搜索"];
    
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
    
    NSString *method;
    NSDictionary *dic;
    
    if ([model.megmt_id isEqualToString:@"<null>"] ||
        [model.megmt_id isEqualToString:@"(null)"] ||
        [model.megmt_id isEqualToString:@""]) {

        // 执行收藏
        method = [NSString stringWithFormat:@"Engagements/addToFavorite"];
        dic = [NSDictionary dictionaryWithObjectsAndKeys:
                             @"megmt_id", model.megmt_id,
                             @"favorite", @"0",
                             nil];

    } else {

        // 取消收藏
        method = [NSString stringWithFormat:@"Engagements/addToFavorite"];
        dic = [NSDictionary dictionaryWithObjectsAndKeys:
                             @"megmt_webid", model.mwsub_webid,
                             @"favorite", @"1",
                             @"megmt_artid", model.megmt_artid,
                             nil];
    }


    //发送soap请求
    [SOAPUrlSession SOAPDataWithMethod:method parameter:dic success:^(id responseObject) {

        //返回的Code字段：200-成功，300-失败，400-无数据，500-内部服务异常
        NSString *responseCode = [NSString stringWithFormat:@"%@",responseObject[@"code"]];

        if ([responseCode isEqualToString:@"0"]) {

            



            dispatch_async(dispatch_get_main_queue(), ^{

                
                [_listTableView reloadData];

            });


        } else {
            
            //主线程更新视图
            dispatch_async(dispatch_get_main_queue(), ^{
                
                FadeAlertView *showMessage = [[FadeAlertView alloc] init];
                [showMessage showAlertWith:[NSString stringWithFormat:@"%@", responseObject[@"msg"]]];
                
            });
            
        }

    } failure:^(NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{

            //后台连接直接不成功，弹出“连接服务器失败”
            FadeAlertView *showMessage = [[FadeAlertView alloc] init];
            [showMessage showAlertWith:@"连接服务器失败"];
        });

    }];
    
    
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
    
    // CYC666 分页
    NSString *cur_page = [NSString stringWithFormat:@"%ld", currentPage];
    NSString *method = [NSString stringWithFormat:@"Articles/selectArticles"];
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:             // CYC666 分页 token
                         @"cur_page", cur_page,
                         nil];
    
    [SOAPUrlSession postWithBody:dic method:method success:^(id responseObject) {
        
        //返回的Code字段：200-成功，300-失败，400-无数据，500-内部服务异常
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
                model.megmt_artid = [NSString stringWithFormat:@"%@", dic[@"website_megmt_artidid"]];
                model.listId = [NSString stringWithFormat:@"%@", dic[@"id"]];
                model.art_creation_date = [NSString stringWithFormat:@"%@", dic[@"art_creation_date"]];
                model.mwsub_webid = [NSString stringWithFormat:@"%@", dic[@"mwsub_webid"]];
                model.art_content = [NSString stringWithFormat:@"%@", dic[@"art_content"]];
                model.mwsub_mbrid = [NSString stringWithFormat:@"%@", dic[@"mwsub_mbrid"]];
                model.art_readnum = [NSString stringWithFormat:@"%@", dic[@"art_readnum"]];

                [_dataArray addObject:model];
            }



            dispatch_async(dispatch_get_main_queue(), ^{

                [_listTableView reloadData];

            });


        }
        
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
    
    return 90.0;
    
    
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
            [cell.collectButton setImage:[UIImage imageNamed:@"Uncollect"] forState:UIControlStateNormal];
        } else {
            [cell.collectButton setImage:[UIImage imageNamed:@"Uncollect"] forState:UIControlStateNormal];
        }
        
        cell.collectButton.tag = 1000 + indexPath.row;
        [cell.collectButton addTarget:self action:@selector(collectButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        
        
        if ([model.mwsub_webid isEqualToString:@"<null>"] ||
            [model.mwsub_webid isEqualToString:@"(null)"] ||
            [model.mwsub_webid isEqualToString:@""]) {
            // 订阅
            [cell.dingImageView setImage:[UIImage imageNamed:@"ding"]];
        } else {
            [cell.dingImageView setImage:[UIImage imageNamed:@""]];
        }
        
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
    }];
    
    FadeAlertView *showMessage = [[FadeAlertView alloc] init];
    [showMessage showAlertWith:[NSString stringWithFormat:@"%ld", index]];

    
    
}



#pragma mark ========================================通知================================================






































@end
