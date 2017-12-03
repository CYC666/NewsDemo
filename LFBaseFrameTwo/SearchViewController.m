//
//  SearchViewController.m
//  LFBaseFrameTwo
//
//  Created by 曹老师 on 2017/12/1.
//  Copyright © 2017年 admin. All rights reserved.
//

#import "SearchViewController.h"
#import "SearchNavBar.h"
#import "NewsListCell.h"
#import "NewsListModel.h"
#import "DListCell.h"
#import "DingModel.h"
#import "SearchWithWebViewController.h"
#import "TGWebViewController.h"
#import "TipSelectView.h"

@interface SearchViewController () <UITableViewDelegate, UITableViewDataSource, SearchNavBarDlegate, TipSelectViewDlegate, SearchWithWebViewControllerDlegate> {
    
    UITableView *_listTableView;
    
    SearchNavBar *navBar;
    
    NSMutableArray *_dataArray;     // 数据列表
    
    TipSelectView *selectView;      // 选择文章还是专栏
    
    NSInteger currentPage;          // 当前页
    
    
}

@end

@implementation SearchViewController

#pragma mark ========================================生命周期========================================
- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.view.backgroundColor = Background_Color;
    _dataArray = [NSMutableArray array];
    currentPage = 1;
    
    // 创建视图
    [self creatSubViewsAction];
    
    
    
}


#pragma mark ========================================私有方法=============================================

#pragma mark - 创建视图
- (void)creatSubViewsAction {
    
    // 导航栏输入框
    navBar = [[SearchNavBar alloc] initWithFrame:CGRectMake(60, 27, kScreenWidth - 120, 30)];
    navBar.tipLabel.text = [_type isEqualToString:@"1"] ? @"文章" : @"专栏";
    navBar.field.placeholder = @"请输入内容";
    navBar.delegate = self;
    [navBar.field addTarget:self action:@selector(searchGoodsList) forControlEvents:UIControlEventEditingDidEndOnExit];
    self.navigationItem.titleView = navBar;
    
    // 导航栏右边的添加按钮
    UIButton *rightItem = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightItem setTitle:@"搜索" forState:UIControlStateNormal];
    [rightItem setTintColor:[UIColor whiteColor]];
    rightItem.frame = CGRectMake(0, 0, 40, 22);
    [rightItem addTarget:self action:@selector(searchGoodsList) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightBarItem = [[UIBarButtonItem alloc] initWithCustomView:rightItem];
    self.navigationItem.rightBarButtonItem = rightBarItem;
    
    
    // 表视图
    _listTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, kScreenWidth, kScreenHeight - 64)
                                                  style:UITableViewStylePlain ];
    _listTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    _listTableView.backgroundColor = [UIColor clearColor];
    _listTableView.delegate = self;
    _listTableView.dataSource = self;
    [_listTableView registerNib:[UINib nibWithNibName:@"NewsListCell" bundle:[NSBundle mainBundle]]
         forCellReuseIdentifier:@"NewsListCell"];
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
        
        if ([_type isEqualToString:@"1"]) {
            
            // 搜索文章
            [self loadNewsListAction:NO];
        } else {
            
            // 搜索网站
            [self searchWebAction:NO];
        }
        
        //关闭刷新
        [_listTableView.mj_header endRefreshing];
    }];
    header.stateLabel.font = [UIFont systemFontOfSize:12];
    header.lastUpdatedTimeLabel.font = [UIFont systemFontOfSize:11];
    _listTableView.mj_header = header;
    
    MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        
        if ([_type isEqualToString:@"1"]) {
            
            // 搜索文章
            [self loadNewsListAction:YES];
        } else {
            
            // 搜索网站
            [self searchWebAction:YES];
        }
        
        //关闭刷新
        [_listTableView.mj_footer endRefreshing];
    }];
    footer.automaticallyHidden = YES;//自动根据有无数据来显示和隐藏
    footer.stateLabel.font = [UIFont systemFontOfSize:12];
    _listTableView.mj_footer = footer;
    
}

#pragma mark ========================================动作响应=============================================

#pragma mark - 搜索
- (void)searchGoodsList {
    
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
    
    if ([_type isEqualToString:@"1"]) {
        
        // 搜索文章
        [self loadNewsListAction:NO];
    } else {
        
        // 搜索网站
        [self searchWebAction:NO];
    }
    
    
}

#pragma mark - 点击订阅
- (void)dingButtonAction:(UIButton *)button {
    
    DingModel *model = _dataArray[button.tag];
    
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
    
    
    
    [SOAPUrlSession setDingActionWithMwsub_wsid:model.mwsub_webid       // 网站id
                                       mwsub_id:model.mwsub_id          // 订阅id
                                art_subws_order:art_subws_order
                                        success:^(id responseObject) {
                                            
                                            NSString *responseCode = [NSString stringWithFormat:@"%@",responseObject[@"code"]];
                                            
                                            if ([responseCode isEqualToString:@"0"]) {
                                                
                                                NSString *iconflg = [NSString stringWithFormat:@"%@", responseObject[@"data"][@"iconflg"]];
                                                if (iconflg.integerValue == 0) {
                                                    
                                                    // 取消成功
                                                    model.mwsub_mbrid = @"<null>";
                                                    
                                                } else {
                                                    
                                                    // 收藏成功
                                                    model.mwsub_mbrid = [NSString stringWithFormat:@"%@", responseObject[@"data"][@"resultid"]];
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

#pragma mark - 收藏
- (void)collectButtonAction:(UIButton *)button {
    
    __block NewsListModel *model = _dataArray[button.tag - 1000];
    
    
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
                                  mwsub_webid:model.website_id  // 这两个字段一个意思
                                     favorite:favorite
                                      success:^(id responseObject) {
                                          
                                          NSString *responseCode = [NSString stringWithFormat:@"%@",responseObject[@"code"]];
                                          
                                          if ([responseCode isEqualToString:@"0"]) {
                                              
                                              
                                              
                                          }
                                          
                                          //主线程更新视图
                                          dispatch_async(dispatch_get_main_queue(), ^{
                                              
                                              //                                              FadeAlertView *showMessage = [[FadeAlertView alloc] init];
                                              //                                              [showMessage showAlertWith:[NSString stringWithFormat:@"%@", responseObject[@"msg"]]];
                                              
                                              
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
    
    ctrl.ctrlModel = model;
    
    [self.navigationController pushViewController:ctrl animated:YES];
    
}

#pragma mark ========================================网络请求=============================================

#pragma mark - 搜索网站
- (void)searchWebAction:(BOOL)isFooter {
    
    NSString *key = navBar.field.text;
    
//    if ([key isEqualToString:@""]) {
//        return;
//    }
    
    if (isFooter) {
        currentPage++;
    } else {
        currentPage = 1;
        [_dataArray removeAllObjects];
    }
    
    NSString *page = [NSString stringWithFormat:@"%ld", currentPage];
    
    [SOAPUrlSession searchWebWithPage:page web_keys:key success:^(id responseObject) {
        
        NSString *responseCode = [NSString stringWithFormat:@"%@",responseObject[@"code"]];
        
        if ([responseCode isEqualToString:@"0"]) {
            
            
            NSArray *list = responseObject[@"data"];
            
            // 封装数据
            for (NSDictionary *dic in list) {
                
                DingModel *model = [[DingModel alloc] init];
                model.mwsub_id = [NSString stringWithFormat:@"%@", dic[@"mwsub_id"]];
                model.mwsub_mbrid = [NSString stringWithFormat:@"%@", dic[@"mwsub_mbrid"]];
                model.mwsub_webid = [NSString stringWithFormat:@"%@", dic[@"id"]];
                model.ws_logo = [NSString stringWithFormat:@"%@", dic[@"ws_logo"]];
                model.ws_name = [NSString stringWithFormat:@"%@", dic[@"ws_name"]];
                
                [_dataArray addObject:model];
            }
            
//            NSArray *list2 = orderDic[@"unorder_data"];
//
//            // 封装数据
//            for (NSDictionary *dic in list2) {
//
//                DingModel *model = [[DingModel alloc] init];
//                model.mwsub_id = [NSString stringWithFormat:@"%@", dic[@"id"]];
//                model.mwsub_mbrid = [NSString stringWithFormat:@"%@", dic[@"mwsub_mbrid"]];
//                model.mwsub_webid = [NSString stringWithFormat:@"%@", dic[@"mwsub_webid"]];
//                model.ws_logo = [NSString stringWithFormat:@"%@", dic[@"ws_logo"]];
//                model.ws_name = [NSString stringWithFormat:@"%@", dic[@"ws_name"]];
//
//                [_dataArray addObject:model];
//            }
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

#pragma mark - 获取新闻列表(是否是上拉加载)
- (void)loadNewsListAction:(BOOL)isFooter {
    
    NSString *key = navBar.field.text;
    
//    if ([key isEqualToString:@""]) {
//        return;
//    }
    
    if (isFooter) {
        currentPage++;
    } else {
        currentPage = 1;
        [_dataArray removeAllObjects];
    }
    
    NSString *page = [NSString stringWithFormat:@"%ld", currentPage];
    
    [SOAPUrlSession searchArtWithPage:page keys:key success:^(id responseObject) {
        
        
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
                model.mwsub_webid = [NSString stringWithFormat:@"%@", dic[@"mwsub_webid"]];
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
    
    if ([_type isEqualToString:@"1"]) {
        
        return 95;
    } else {
        return 50;
    }
    
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    return 0.01;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 0.01;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([_type isEqualToString:@"1"]) {
        
        // 网页
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
            
            
            if ([model.mwsub_id isEqualToString:@"<null>"] ||
                [model.mwsub_id isEqualToString:@"(null)"] ||
                [model.mwsub_id isEqualToString:@""]) {
                // 未订阅
                [cell.dingImageView setImage:[UIImage imageNamed:@""]];
            } else {
                [cell.dingImageView setImage:[UIImage imageNamed:@"ding"]];
            }
            
            cell.signButton.tag = 2000 + indexPath.row;
            [cell.signButton addTarget:self action:@selector(signButtonAction:) forControlEvents:UIControlEventTouchUpInside];
            
        }
        
        return cell;
    } else {
        
        // 网站
        DListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DListCell" forIndexPath:indexPath];
        if (_dataArray.count == 0) {
            
        } else {
            
            DingModel *model = _dataArray[indexPath.row];
            
            // 图片
            NSString *path = [NSString stringWithFormat:@"%@%@", Java_Image_URL, model.ws_logo];
            [cell.iconImageView sd_setImageWithURL:[NSURL URLWithString:path]
                                  placeholderImage:[UIImage imageNamed:@"loadfail-0"]
                                           options:SDWebImageRetryFailed];
            
            // 名字
            cell.nameLabel.text = model.ws_name;
            
            if ([model.mwsub_mbrid isEqualToString:@"<null>"] ||
                [model.mwsub_mbrid isEqualToString:@"(null)"] ||
                [model.mwsub_mbrid isEqualToString:@""]) {
                
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
        
    
    
    
    
    
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
    if (_dataArray.count == 0) {
        
    } else {
        
        if ([_type isEqualToString:@"1"]) {
            
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
            
        } else {
            
            DingModel *dingModel = _dataArray[indexPath.row];
            
            NewsListModel *model = [[NewsListModel alloc] init];
            model.website_id = dingModel.mwsub_webid;
            model.ws_name = dingModel.ws_name;
            model.ws_logo = dingModel.ws_logo;
            model.art_type = @"-1";
            model.mwsub_id = dingModel.mwsub_id;
            model.megmt_id = @"";
            model.art_title = @"";
            model.megmt_artid = @"";
            model.listId = @"";
            model.art_creation_date = @"";
            model.mwsub_webid = dingModel.mwsub_webid;
            model.art_content = @"";
            model.mwsub_mbrid = @"";
            model.art_readnum = @"";
            
            SearchWithWebViewController *ctrl = [[SearchWithWebViewController alloc] init];
            
            ctrl.delegate = self;
            ctrl.ctrlModel = model;
            
            [self.navigationController pushViewController:ctrl animated:YES];
        }
        
        
        
        
    }
    
    
}


#pragma mark - 点击修改文章、专栏
- (void)SearchNavBarTipButtonAction {
    
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
    
    if (selectView == nil) {
        selectView = [[TipSelectView alloc] initWithFrame:CGRectMake(0, kScreenHeight, kScreenWidth, 300)];
        selectView.delegate = self;
        [self.view addSubview:selectView];
    }
    
    if (selectView.transform.ty == 0) {
        [UIView animateWithDuration:0.2 animations:^{
            selectView.transform = CGAffineTransformMakeTranslation(0, -300);
        }];
    } else {
        [UIView animateWithDuration:0.2 animations:^{
            selectView.transform = CGAffineTransformMakeTranslation(0, 0);
        }];
    }
    
    
}

#pragma mark - 选择了文章、专栏
- (void)TipSelectViewIndexChange:(NSString *)tip {
    
    [UIView animateWithDuration:0.2 animations:^{
        selectView.transform = CGAffineTransformMakeTranslation(0, 0);
    } completion:^(BOOL finished) {
        if (![tip isEqualToString:@""]) {
            navBar.tipLabel.text = tip;
            
            if ([tip isEqualToString:@"文章"]) {
                _type = @"1";
            } else {
                _type = @"2";
            }
            
            // 重新选择之后要清空数据
            [_dataArray removeAllObjects];
            [_listTableView reloadData];
            
        }
    }];
    
}


#pragma mark - 网站搜索页订阅参数改变
- (void)SearchWithWebViewControllerCollectChange:(NSInteger)index {
    
    DingModel *modelA = _dataArray[index];
    
    for (DingModel *model in _dataArray) {
        
        if ([model.ws_name isEqualToString:modelA.ws_name]) {
            
            model.mwsub_id = modelA.mwsub_webid;
            model.mwsub_webid = modelA.mwsub_webid;
            model.mwsub_mbrid = modelA.mwsub_mbrid;
            
        }
        
    }
    
    
    [_listTableView reloadData];
    
    
}

#pragma mark ========================================通知================================================




@end
