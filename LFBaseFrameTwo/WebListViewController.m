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

@interface WebListViewController () <UITableViewDelegate, UITableViewDataSource> {
    
    UITableView *_listTableView;
    
    NSMutableArray *dataArray;
    
}

@end

@implementation WebListViewController

#pragma mark ========================================生命周期========================================
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = Background_Color;
    dataArray = [NSMutableArray array];
    
    // 创建视图
    [self creatSubViewsAction];
    
    
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    // 获取数据
    [self loadDingListAction];
    
    
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
    _listTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, kScreenWidth, kScreenHeight - 64)
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

#pragma mark - 获取订阅分类列表
- (void)loadDingListAction {
    
    [dataArray removeAllObjects];
    
    [SOAPUrlSession searchWebWithPage:@"1" web_keys:@"" success:^(id responseObject) {
        
        NSString *responseCode = [NSString stringWithFormat:@"%@",responseObject[@"code"]];
        
        if (responseCode.integerValue == 0) {
            
            [dataArray removeAllObjects];
            NSArray *list = responseObject[@"data"];
            
            for (NSDictionary *dic in list) {
                
                DingModel *model = [[DingModel alloc] init];
                model.mwsub_id = [NSString stringWithFormat:@"%@", dic[@"mwsub_id"]];
                model.mwsub_mbrid = [NSString stringWithFormat:@"%@", dic[@"mwsub_mbrid"]];
                model.mwsub_webid = [NSString stringWithFormat:@"%@", dic[@"id"]];
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
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
    
}


#pragma mark ========================================通知================================================




@end
