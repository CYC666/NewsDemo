//
//  SellCollectionView.m
//  LFBaseFrameTwo
//
//  Created by 曹奕程 on 2017/9/25.
//  Copyright © 2017年 admin. All rights reserved.
//

// 特卖商品列表集合视图

#import "SellCollectionView.h"
#import "SellGoodsCell.h"
#import "DingModel.h"
#import "NewsListModel.h"
#import "SearchWithWebViewController.h"
#import "TGWebViewController.h"


@interface SellCollectionView () <UICollectionViewDataSource, UICollectionViewDelegate, SearchWithWebViewControllerDlegate> {
    
    
    UserInformation *userInfo;              // 用户信息单例
    
    SmallFunctionTool *smallFunc;           // 工具方法单例
    
    NSMutableArray *_dataArray;             // 商品数组
    
    NSInteger currentPage;                  // 当前页
    
    UIView *noDataView;                     // 没有数据时显示的页面
    
}

@end

@implementation SellCollectionView







#pragma mark ========================================控制器生命周期========================================

- (instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout {

    if (self = [super initWithFrame:frame collectionViewLayout:layout]) {
        
        // 设置基本信息
        [self settingAction];
    }
    return self;

}

- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"art_type_change" object:nil];
    
    
}


#pragma mark ========================================私有方法=============================================

#pragma mark - 设置基本信息
- (void)settingAction {
    
    self.backgroundColor = [UIColor whiteColor];
    
    [self registerNib:[UINib nibWithNibName:@"SellGoodsCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:@"SellGoodsCell"];
    self.delegate = self;
    self.dataSource = self;
    
    //初始化
    userInfo = [UserInformation sharedInstance];
    smallFunc = [SmallFunctionTool sharedInstance];
    _dataArray = [NSMutableArray array];
    currentPage = 1;
    
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        [self loadNewsListAction:NO];
        
        //关闭刷新
        [self.mj_header endRefreshing];
    }];
    header.stateLabel.font = [UIFont systemFontOfSize:12];
    header.lastUpdatedTimeLabel.font = [UIFont systemFontOfSize:11];
    self.mj_header = header;
    
    MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        
        [self loadNewsListAction:YES];
        
        //关闭刷新
        [self.mj_footer endRefreshing];
    }];
    footer.automaticallyHidden = YES;//自动根据有无数据来显示和隐藏
    footer.stateLabel.font = [UIFont systemFontOfSize:12];
    self.mj_footer = footer;
    
    // 添加监听刷新的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(art_type_changeAction:) name:@"art_type_change" object:nil];
    
    
}

- (void)setEnumModel:(DingModel *)enumModel {

    _enumModel = enumModel;
    
    // 重新搜索
    [self loadNewsListAction:NO];

}

#pragma mark ========================================动作响应=============================================


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
                                              
                                              NSString *iconflg = [NSString stringWithFormat:@"%@", responseObject[@"data"][@"iconflg"]];
                                              if (iconflg.integerValue == 0) {
                                                  
                                                  // 取消成功
                                                  model.megmt_id = @"<null>";
                                                  
                                              } else {
                                                  
                                                  // 收藏成功
                                                  model.megmt_id = [NSString stringWithFormat:@"%@", responseObject[@"data"][@"resultid"]];
                                              }
                                              
                                          }
                                          
                                          //主线程更新视图
                                          dispatch_async(dispatch_get_main_queue(), ^{
                                              
                                              [self reloadItemsAtIndexPaths:@[[NSIndexPath indexPathForRow:button.tag - 1000 inSection:0]]];
                                              
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
    
    ctrl.delegate = self;
    ctrl.ctrlModel = model;
    
    [self.superCtrl.navigationController pushViewController:ctrl animated:YES];
    
}


#pragma mark ========================================网络请求=============================================

#pragma mark - 获取新闻列表(是否是上拉加载)
- (void)loadNewsListAction:(BOOL)isFooter {
    
    NSString *key;
    if ([_enumModel.ws_name isEqualToString:@"推荐"]) {
        
        key = @"-1";
    } else {
        
        key = _enumModel.ws_name;
    }
    
    
    
    if ([key isEqualToString:@""]) {
        return;
    }
    
    if (isFooter) {
        currentPage++;
        
    } else {
        currentPage = 1;
        [_dataArray removeAllObjects];
    }
    
    
    
    NSString *page = [NSString stringWithFormat:@"%ld", currentPage];
    
    [SOAPUrlSession getNewsWithArt_type:_art_type art_subwsid:_enumModel.mwsub_wsid  page:page success:^(id responseObject) {
        
        
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
            
            [self reloadData];
            
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
#pragma mark - 集合视图代理方法
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    
    return 1;
    
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return _dataArray.count;
//    return 20;
    
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    return CGSizeMake(kScreenWidth, 95);
    
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    SellGoodsCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"SellGoodsCell" forIndexPath:indexPath];
    
    if (_dataArray.count == 0) {
        
    } else {
        
        NewsListModel *model = _dataArray[indexPath.row];
        
        cell.nameLabel.text = model.art_title;              // 新闻标题
        cell.contentLabel.text = model.art_content;         // 新闻内容
        cell.collectLabel.text = model.ws_name;
//        [cell.signButton setTitle:model.ws_name forState:UIControlStateNormal];     // 网站名称
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
    
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
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
        
        [self.superCtrl.navigationController pushViewController:ctrl animated:YES];
        
    }
    
}

#pragma mark - 网址搜索页有响应
- (void)SearchWithWebViewControllerCollectChange:(NewsListModel *)model {
    
    for (NewsListModel *modelA in _dataArray) {
        
        if ([modelA.ws_name isEqualToString:model.ws_name]) {
            
            modelA.mwsub_id = model.mwsub_id;
            modelA.mwsub_webid = model.mwsub_webid;
            
        }
        
    }
    
    
    [self reloadData];
    
    
}

#pragma mark ========================================通知================================================

#pragma mark - 监听art_type改变的通知
- (void)art_type_changeAction:(NSNotification *)notifi {
    
    _art_type = (NSString *)notifi.object;
    
    [self loadNewsListAction:NO];
    
}





































@end
