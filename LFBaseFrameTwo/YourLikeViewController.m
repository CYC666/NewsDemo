//
//  YourLikeViewController.m
//  LFBaseFrameTwo
//
//  Created by 曹老师 on 2017/12/5.
//  Copyright © 2017年 admin. All rights reserved.
//

#import "YourLikeViewController.h"
#import "YourLikeCell.h"
#import "YourLikeModel.h"
#import "WebForCommonViewController.h"


@interface YourLikeViewController () <UITableViewDelegate, UITableViewDataSource> {
    
    UITableView *_listTableView;
    
    NSMutableArray *_dataArray;     // 数据列表
    
    NSInteger currentPage;          // 当前页
    
}

@end

@implementation YourLikeViewController

#pragma mark ========================================生命周期========================================
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"猜你喜欢";
    self.view.backgroundColor = Background_Color;
    _dataArray = [NSMutableArray array];
    currentPage = 1;
    
    // 创建视图
    [self creatSubViewsAction];
    
    // 加载数据
    [self loadNewsListAction:NO];
    
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
    [_listTableView registerNib:[UINib nibWithNibName:@"YourLikeCell" bundle:[NSBundle mainBundle]]
         forCellReuseIdentifier:@"YourLikeCell"];
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
    
    
}

#pragma mark ========================================动作响应=============================================


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
    [SOAPUrlSession yourLikeCur_Page:page success:^(id responseObject) {
        
        
        NSString *responseCode = [NSString stringWithFormat:@"%@",responseObject[@"code"]];
        
        if ([responseCode isEqualToString:@"0"]) {
            
            NSArray *list = responseObject[@"data"];
            
            // 封装数据
            for (NSDictionary *dic in list) {
                
                YourLikeModel *model = [[YourLikeModel alloc] init];
                model.gf_abstract = [NSString stringWithFormat:@"%@", dic[@"gf_abstract"]];
                model.gf_creation_date = [NSString stringWithFormat:@"%@", dic[@"gf_creation_date"]];
                model.gf_picurl = [NSString stringWithFormat:@"%@", dic[@"gf_picurl"]];
                model.gf_title = [NSString stringWithFormat:@"%@", dic[@"gf_title"]];
                model.gf_wsname = [NSString stringWithFormat:@"%@", dic[@"gf_wsname"]];
                model.ListId = [NSString stringWithFormat:@"%@", dic[@"id"]];
                
                
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

#pragma mark - 获取文章详情
- (void)loadDetial:(NSInteger)index {
    
    YourLikeModel *model = _dataArray[index];
    
    [SOAPUrlSession getYourLikeDetialId:model.ListId
                                success:^(id responseObject) {
                                    
                                    NSString *responseCode = [NSString stringWithFormat:@"%@",responseObject[@"code"]];
                                    
                                    if ([responseCode isEqualToString:@"0"]) {
                                        
                                        NSArray *list = responseObject[@"data"];
                                        NSDictionary *dic = list.firstObject;
                                        NSString *urlString = [NSString stringWithFormat:@"%@", dic[@"gf_oriurl"]];
                                        
                                        WebForCommonViewController *ctrl = [[WebForCommonViewController alloc] init];
                                        ctrl.naviTitle = @"信息详情";
                                        ctrl.urlString = urlString;
                                        [self.navigationController pushViewController:ctrl animated:YES];
                                        
                                        
                                    }
                                    
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
    
    return 100;
    
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    return 0.01;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 0.01;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    YourLikeCell *cell = [tableView dequeueReusableCellWithIdentifier:@"YourLikeCell"
                                                             forIndexPath:indexPath];
    
    if (_dataArray.count == 0) {
        
    } else {
        
        YourLikeModel *model = _dataArray[indexPath.row];
        
        // 图片
        NSString *path = [NSString stringWithFormat:@"%@Gf_Img/%@", Java_Image_URL, model.gf_picurl];
        [cell.iconImageView sd_setImageWithURL:[NSURL URLWithString:path]
                              placeholderImage:[UIImage imageNamed:@"loadfail-0"]
                                       options:SDWebImageRetryFailed];
        
        cell.nameLabel.text = model.gf_title;
        cell.contentLabel.text = model.gf_abstract;
        cell.signLabel.text = model.gf_wsname;
        cell.timeLabel.text = model.gf_creation_date;
        
        
    }
    
    
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (_dataArray.count == 0) {
        
    } else {
        
//        [self loadDetial:indexPath.row];
        
        YourLikeModel *model = _dataArray[indexPath.row];
        WebForCommonViewController *ctrl = [[WebForCommonViewController alloc] init];
        ctrl.naviTitle = @"信息详情";
        ctrl.urlString = [NSString stringWithFormat:@"http://47.92.86.242/bidapp_front/guessDetil.html?/id/%@", model.ListId];
        [self.navigationController pushViewController:ctrl animated:YES];
        
    }
    

    
}


#pragma mark ========================================通知================================================













@end
