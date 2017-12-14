//
//  DingSettingViewController.m
//  LFBaseFrameTwo
//
//  Created by 曹老师 on 2017/11/29.
//  Copyright © 2017年 admin. All rights reserved.
//

#import "DingSettingViewController.h"
#import "SDCycleScrollView.h"
#import "HotDingView.h"
#import "LatestDingView.h"
#import "DListViewController.h"
#import "SearchViewController.h"
#import "DingModel.h"
#import "SearchWithWebViewController.h"
#import "NewsListModel.h"
#import "BannerModel.h"

@interface DingSettingViewController () <HotDingViewDlegate, LatestDingViewDlegate> {
    
    NSMutableArray *typeArray;
    HotDingView *hotView;           // 热门推荐
    LatestDingView *latestView;     // 最新加入
    SDCycleScrollView *bannerView;  // 轮播图
    
    
}

@end

@implementation DingSettingViewController


#pragma mark ========================================生命周期========================================
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"订阅设置";
    self.view.backgroundColor = Background_Color;
    typeArray = [NSMutableArray array];
    
    // 创建视图
    [self creatSubviewsAction];
    
    
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    if (hotView) {
        // 重新获取数据
        [hotView loadHoyTypeAction];
    }
    
    if (latestView) {
        [latestView loadNewTypeAction];
    }
    
    
    
    
}

#pragma mark ========================================私有方法=============================================

#pragma mark - 创建视图
- (void)creatSubviewsAction {
    
    // 导航栏两个按钮
    UIButton *searchButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [searchButton setImage:[UIImage imageNamed:@"sou"]  forState:UIControlStateNormal];
    [searchButton setTintColor:[UIColor whiteColor]];
    searchButton.frame = CGRectMake(0, 0, 30, 30);
    [searchButton addTarget:self action:@selector(searchButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightBarItemA = [[UIBarButtonItem alloc] initWithCustomView:searchButton];
    
    
    // 导航栏右边的添加按钮
    UIButton *rankButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [rankButton setTitle:@"我的订阅" forState:UIControlStateNormal];
    rankButton.titleLabel.font = [UIFont systemFontOfSize:15];
    rankButton.titleLabel.adjustsFontSizeToFitWidth = YES;
    [rankButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [rankButton setTintColor:[UIColor whiteColor]];
    rankButton.frame = CGRectMake(0, 0, 60, 30);
    [rankButton addTarget:self action:@selector(myDingAction:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightBarItemB = [[UIBarButtonItem alloc] initWithCustomView:rankButton];
    self.navigationItem.rightBarButtonItems = @[rightBarItemB, rightBarItemA];
    
    // 轮播图
    CGFloat startY = 0;
    if (kScreenHeight == 812) {
        startY = 88;    // iPhone X
    } else {
        startY = 64;    // 其他机型
    }
    bannerView = [[SDCycleScrollView alloc] initWithFrame:CGRectMake(0, startY, kScreenWidth, kScreenWidth * 0.35)];
    bannerView.pageControlAliment = SDCycleScrollViewPageContolAlimentCenter;
    bannerView.currentPageDotColor = Publie_Color;
    bannerView.pageDotColor=[UIColor whiteColor];
    bannerView.placeholderImage = [UIImage imageNamed:@"默认图"];
    bannerView.backgroundColor = Background_Color;
    bannerView.pageControlAliment = SDCycleScrollViewPageContolAlimentCenter;
    bannerView.localizationImageNamesGroup = @[@"banner1", @"banner2", @"banner3"];     // 写死
    [self.view addSubview:bannerView];
    
    // 热门推荐
    hotView = [[HotDingView alloc] initWithFrame:CGRectMake(15, kScreenWidth * 0.35 + startY + 10,
                                                                         kScreenWidth - 30,
                                                                         (kScreenHeight - (kScreenWidth * 0.35 + startY + 30)) * 0.5)];
    hotView.layer.cornerRadius = 5;
    hotView.backgroundColor = [UIColor whiteColor];
    hotView.clipsToBounds = YES;
    hotView.cellDelegate = self;
    hotView.superCtrl = self;
    [self.view addSubview:hotView];
    
    // 最新加入
    latestView = [[LatestDingView alloc] initWithFrame:CGRectMake(15, kScreenWidth * 0.35 + startY + 20 + (kScreenHeight - (kScreenWidth * 0.35 + startY + 30)) * 0.5,
                                                                         kScreenWidth - 30,
                                                                         (kScreenHeight - (kScreenWidth * 0.35 + startY + 30)) * 0.5)];
    latestView.layer.cornerRadius = 5;
    latestView.backgroundColor = [UIColor whiteColor];
    latestView.clipsToBounds = YES;
    latestView.cellDelegate = self;
    latestView.superCtrl = self;
    [self.view addSubview:latestView];
    
    // 获取轮播图
//    [self loadNewTypeAction];
    
}



#pragma mark ========================================动作响应=============================================

#pragma mark - 搜索
- (void)searchButtonAction:(UIButton *)button {
    
    SearchViewController *ctrl = [[SearchViewController alloc] init];
    ctrl.type = @"2";   // 搜索专栏
    [self.navigationController pushViewController:ctrl animated:YES];
    
}

#pragma mark - 我的订阅
- (void)myDingAction:(UIButton *)button {
    
    DListViewController *ctrl = [[DListViewController alloc] init];
    [self.navigationController pushViewController:ctrl animated:YES];
    
}


#pragma mark ========================================网络请求=============================================

#pragma mark - 获取轮播图
- (void)loadNewTypeAction {
    
    [SOAPUrlSession hotAneNewWebsHeaderType:@"0"
                                    success:^(id responseObject) {
                                        
                                        NSString *responseCode = [NSString stringWithFormat:@"%@",responseObject[@"code"]];
                                        
                                        if ([responseCode isEqualToString:@"0"]) {
                                            
                                            [typeArray removeAllObjects];
                                            NSDictionary *dic = responseObject[@"data"];
                                            
                                            NSArray *hotList = dic[@"banner_data"];
                                            // 封装数据
                                            for (NSInteger i = 0; i < hotList.count; i++) {
                                                
                                                NSDictionary *d = hotList[i];
                                                BannerModel *model = [[BannerModel alloc] init];
                                                model.webid = [NSString stringWithFormat:@"%@", d[@"webid"]];
                                                model.ws_banner = [NSString stringWithFormat:@"%@%@", Java_Image_URL, d[@"ws_banner"]];
                                                model.ws_isbanner = [NSString stringWithFormat:@"%@", d[@"ws_isbanner"]];
                                                
                                                [typeArray addObject:model];
                                                
                                            }
                                            
                                            
                                        }
                                        
                                        //主线程更新视图
                                        dispatch_async(dispatch_get_main_queue(), ^{
                                            
                                            bannerView.imageURLStringsGroup = typeArray;
                                            
                                        });
                                        
                                    } failure:^(NSError *error) {
                                        
                                        //主线程更新视图
                                        dispatch_async(dispatch_get_main_queue(), ^{
                                            
                                            FadeAlertView *showMessage = [[FadeAlertView alloc] init];
                                            [showMessage showAlertWith:@"请求失败"];
                                            
                                        });
                                        
                                    }];
    
}




#pragma mark - 订阅/取消订阅
- (void)dingButtonAction:(DingModel *)model {
    
    NSString *art_subws_order;
    
    if ([model.mwsub_id isEqualToString:@"<null>"] || [model.mwsub_id isEqualToString:@"(null)"] || [model.mwsub_id isEqualToString:@""]) {
        art_subws_order = @"0";
    } else {
        art_subws_order = @"1";
    }
    
    [SOAPUrlSession setDingActionWithMwsub_wsid:model.mwsub_webid
                                       mwsub_id:model.mwsub_id
                                art_subws_order:art_subws_order
                                        success:^(id responseObject) {
                                            
                                            //主线程更新视图
                                            dispatch_async(dispatch_get_main_queue(), ^{
                                                
                                                // 重新获取数据
                                                [hotView loadHoyTypeAction];
                                                [latestView loadNewTypeAction];
                                                
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

#pragma mark - 点击了订阅、取消订阅
- (void)HotDingViewIndexSelect:(DingModel *)model {
    
    [self dingButtonAction:model];
    
    
}

- (void)LatestDingViewIndexSelect:(DingModel *)model {
    
    [self dingButtonAction:model];
    
    
}


#pragma mark - 点击了单元格，跳转到网站内部搜索页
- (void)HotDingViewSelectCell:(DingModel *)model {
    
//    DingModel *modelA = typeArray[index];
    
    NewsListModel *modelA = [[NewsListModel alloc] init];
    modelA.website_id = model.mwsub_webid;
    modelA.ws_name = model.ws_name;
    modelA.ws_logo = model.ws_logo;
    modelA.art_type = @"";
    modelA.mwsub_id = model.mwsub_id;
    modelA.megmt_id = @"";
    modelA.art_title = @"";
    modelA.megmt_artid = @"";
    modelA.listId = @"";
    modelA.art_creation_date = @"";
    modelA.mwsub_webid = model.mwsub_webid;
    modelA.art_content = @"";
    modelA.mwsub_mbrid = model.mwsub_mbrid;
    modelA.art_readnum = @"";
    
    SearchWithWebViewController *ctrl = [[SearchWithWebViewController alloc] init];
    
//    ctrl.delegate = self;     // 每次打开这个控制器都会刷新，所以不用代理提醒了
    ctrl.ctrlModel = modelA;
    
    [self.navigationController pushViewController:ctrl animated:YES];
    
    
}

- (void)LatestDingViewSelectCell:(DingModel *)model {
    
    //    DingModel *modelA = typeArray[index];
    
    NewsListModel *modelA = [[NewsListModel alloc] init];
    modelA.website_id = model.mwsub_webid;
    modelA.ws_name = model.ws_name;
    modelA.ws_logo = model.ws_logo;
    modelA.art_type = @"";
    modelA.mwsub_id = model.mwsub_id;
    modelA.megmt_id = @"";
    modelA.art_title = @"";
    modelA.megmt_artid = @"";
    modelA.listId = @"";
    modelA.art_creation_date = @"";
    modelA.mwsub_webid = model.mwsub_webid;
    modelA.art_content = @"";
    modelA.mwsub_mbrid = model.mwsub_mbrid;
    modelA.art_readnum = @"";
    
    SearchWithWebViewController *ctrl = [[SearchWithWebViewController alloc] init];
    
    //    ctrl.delegate = self;     // 每次打开这个控制器都会刷新，所以不用代理提醒了
    ctrl.ctrlModel = modelA;
    
    [self.navigationController pushViewController:ctrl animated:YES];
    
    
}


#pragma mark ========================================通知================================================





































@end
