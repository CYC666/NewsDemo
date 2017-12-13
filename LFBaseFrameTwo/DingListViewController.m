//
//  DingListViewController.m
//  LFBaseFrameTwo
//
//  Created by 曹奕程 on 2017/12/1.
//  Copyright © 2017年 admin. All rights reserved.
//

#import "DingListViewController.h"
#import "DidAddListView.h"
#import "CanAddListView.h"
#import "DingModel.h"

@interface DingListViewController () <DidAddListViewDlegate, CanAddListViewDlegate> {
    
    NSMutableArray *_dataArray; // 所有网站
    
    DidAddListView *didView;    // 已订阅列表

    CanAddListView *canView;    // 未订阅列表
    
    BOOL isEdit;                // 是否编辑状态
    
    UIButton *rightItem;        // 导航栏按钮
    
}

@end

@implementation DingListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"订阅列表";
    self.view.backgroundColor = Background_Color;
    _dataArray = [NSMutableArray array];
    
    // 导航栏右边的添加按钮
    rightItem = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightItem setTitle:@"编辑" forState:UIControlStateNormal];
    [rightItem setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [rightItem setTintColor:[UIColor whiteColor]];
    rightItem.frame = CGRectMake(0, 0, 40, 22);
    [rightItem addTarget:self action:@selector(editButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightBarItem = [[UIBarButtonItem alloc] initWithCustomView:rightItem];
    self.navigationItem.rightBarButtonItem = rightBarItem;
    
    // 已订阅
    CGFloat startY = 0;
    if (kScreenHeight == 812) {
        startY = 88;    // iPhone X
    } else {
        startY = 64;    // 其他机型
    }
    didView = [[DidAddListView alloc] initWithFrame:CGRectMake(0, startY, kScreenWidth, (kScreenHeight - startY - 10) * 0.5)];
    didView.cellDelegate = self;
    [self.view addSubview:didView];
    
    // 未订阅
    canView = [[CanAddListView alloc] initWithFrame:CGRectMake(0, startY + (kScreenHeight - startY - 10) * 0.5 + 10, kScreenWidth, (kScreenHeight - startY - 10) * 0.5)];
    canView.cellDelegate = self;
    [self.view addSubview:canView];
    
    // 添加监听刷新的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(canEditNotificationAction:) name:@"canEditNotificationAction" object:nil];
    
    
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    [self loadAllWeb];
    
    
}

- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"canEditNotificationAction" object:nil];
    
}

#pragma mark - 编辑按钮响应
- (void)editButtonAction:(UIButton *)button {
    
    isEdit = !isEdit;
    
    if (isEdit) {
        [button setTitle:@"完成" forState:UIControlStateNormal];
    } else {
        [button setTitle:@"编辑" forState:UIControlStateNormal];
    }
    
    didView.isEdit = isEdit;
    canView.isEdit = isEdit;
    
    [didView.listCollectionView reloadData];
    [canView.listCollectionView reloadData];
    
    
}

#pragma mark - 监听单元格长按，执行可编辑
- (void)canEditNotificationAction:(NSNotification *)notifi {
    
    isEdit = !isEdit;
    
    if (isEdit) {
        [rightItem setTitle:@"完成" forState:UIControlStateNormal];
    } else {
        [rightItem setTitle:@"编辑" forState:UIControlStateNormal];
    }
    
    didView.isEdit = isEdit;
    canView.isEdit = isEdit;
    
    [didView.listCollectionView reloadData];
    [canView.listCollectionView reloadData];
    
}




#pragma mark - 改线显示的页码
- (void)DidAddListViewChangeIndex:(NSInteger)index {
    
    [_delegate DingListViewControllerIndexChange:index finishBlock:^{
        // 成功，返回上个页面
        [self.navigationController popViewControllerAnimated:YES];
    }];
    
}


#pragma mark - 点击了删除网站的单元格
- (void)DidAddListViewIndexSelect:(DingModel *)model {
    
    [self cancelDingButtonAction:model];
    
}


#pragma mark - 点击了添加更多网站的单元格
- (void)CanAddListViewIndexSelect:(DingModel *)model {
    
    [self dingButtonAction:model];
    
    
}





#pragma mark - 获取所有网站
- (void)loadAllWeb {
    
    
    
    [SOAPUrlSession searchWebWithPage:@"1" web_keys:@"" success:^(id responseObject) {
        
        NSString *responseCode = [NSString stringWithFormat:@"%@",responseObject[@"code"]];
        
        if ([responseCode isEqualToString:@"0"]) {
            
            [_dataArray removeAllObjects];
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
            
            if (_dataArray.count != 0) {
                // 去重复
                NSMutableDictionary *mDic = [NSMutableDictionary dictionary];
                
                for (DingModel *model in _dataArray) {
                    
                    [mDic setObject:model forKey:model.ws_name];
                    
                }
                _dataArray = [mDic.allValues mutableCopy];
            }
            
            
//            {
//                id = 3;
//                "mwsub_creation_date" = "<null>";
//                "mwsub_id" = "<null>";
//                "mwsub_mbrid" = "<null>";
//                "mwsub_webid" = "<null>";
//                "ws_logo" = "bjzfcg_logo.png";
//                "ws_name" = "北京市政府采购网";
//            },
            
            
        }
        
        
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [didView reloadDataWithArray:_dataArray];
            [canView reloadDataWithArray:_dataArray];
            
            
            
        });
        
    } failure:^(NSError *error) {
        
        //主线程更新视图
        dispatch_async(dispatch_get_main_queue(), ^{
            
            FadeAlertView *showMessage = [[FadeAlertView alloc] init];
            [showMessage showAlertWith:@"请求失败"];
            
            
            
        });
        
    }];
    
    
}

#pragma mark - 取消订阅
- (void)cancelDingButtonAction:(DingModel *)model {
    
    
    [SOAPUrlSession setDingActionWithMwsub_wsid:model.mwsub_webid
                                       mwsub_id:model.mwsub_id
                                art_subws_order:@"1"
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
                                                
                                                
                                                // 传达model，上个页面添加显示
                                                [_delegate DingListViewControllerAddModel:model];
                                                
                                            }
                                            
                                            //主线程更新视图
                                            dispatch_async(dispatch_get_main_queue(), ^{
                                                
                                                // 重新加载所有网站
                                                [self loadAllWeb];
                                                
                                            });
                                            
                                        } failure:^(NSError *error) {
                                            
                                            //主线程更新视图
                                            dispatch_async(dispatch_get_main_queue(), ^{
                                                
                                                FadeAlertView *showMessage = [[FadeAlertView alloc] init];
                                                [showMessage showAlertWith:@"请求失败"];
                                                
                                            });
                                            
                                        }];
    
}


#pragma mark - 订阅
- (void)dingButtonAction:(DingModel *)model {
    
    
    [SOAPUrlSession setDingActionWithMwsub_wsid:model.mwsub_webid
                                       mwsub_id:model.mwsub_id
                                art_subws_order:@"0"
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
                                                
                                                
                                                // 传达model，上个页面添加显示
                                                [_delegate DingListViewControllerAddModel:model];
                                                
                                            }
                                            
                                            //主线程更新视图
                                            dispatch_async(dispatch_get_main_queue(), ^{
                                                
                                                // 重新加载所有网站
                                                [self loadAllWeb];
                                                
                                            });
                                            
                                        } failure:^(NSError *error) {
                                            
                                            //主线程更新视图
                                            dispatch_async(dispatch_get_main_queue(), ^{
                                                
                                                FadeAlertView *showMessage = [[FadeAlertView alloc] init];
                                                [showMessage showAlertWith:@"请求失败"];
                                                
                                            });
                                            
                                        }];
    
}
























@end
