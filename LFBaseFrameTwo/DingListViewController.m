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
    
    NSMutableArray *_dataArray;
    
    DidAddListView *didView;

    CanAddListView *canView;
    
}

@end

@implementation DingListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"订阅列表";
    self.view.backgroundColor = Background_Color;
    _dataArray = [NSMutableArray array];
    
    didView = [[DidAddListView alloc] initWithFrame:CGRectMake(0, 64, kScreenWidth, (kScreenHeight - 64 - 10) * 0.5)];
    didView.cellDelegate = self;
    [self.view addSubview:didView];
    
    canView = [[CanAddListView alloc] initWithFrame:CGRectMake(0, 64 + (kScreenHeight - 64 - 10) * 0.5 + 10, kScreenWidth, (kScreenHeight - 64 - 10) * 0.5)];
    canView.cellDelegate = self;
    [self.view addSubview:canView];
    
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    [self loadAllWeb];
    
    
}


#pragma mark - 点击了切换网站的单元格
- (void)DidAddListViewIndexSelect:(NSInteger)index {
    
    [_delegate DingListViewControllerIndexChange:index];
    
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
                model.mwsub_id = [NSString stringWithFormat:@"%@", dic[@"mwsub_webid"]];
                model.mwsub_mbrid = [NSString stringWithFormat:@"%@", dic[@"mwsub_mbrid"]];
                model.mwsub_webid = [NSString stringWithFormat:@"%@", dic[@"id"]];
                model.ws_logo = [NSString stringWithFormat:@"%@", dic[@"ws_logo"]];
                model.ws_name = [NSString stringWithFormat:@"%@", dic[@"ws_name"]];
                
                [_dataArray addObject:model];
            }
            
            
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
