//
//  SettingViewController.m
//  LFBaseFrameTwo
//
//  Created by 曹老师 on 2017/11/30.
//  Copyright © 2017年 admin. All rights reserved.
//

#import "SettingViewController.h"
#import "WebForCommonViewController.h"
#import "AboutWeViewController.h"

@interface SettingViewController ()<UITableViewDelegate, UITableViewDataSource> {
    
    UITableView *_listTableView;
    
    UILabel *versionLabel;      // 版本标签
    
    NSString *versionString;    // 版本标题
    
    
    
}

@end

@implementation SettingViewController


#pragma mark ========================================生命周期========================================
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"设置";
    self.view.backgroundColor = [UIColor whiteColor];
    versionString = @"当前版本";
    
    
    // 创建视图
    [self creatSubViewsAction];
    
    // 加载当前版本是否需要检测，从而修改标题----审核要用
    [self loadVersionAction];
    
}




#pragma mark ========================================私有方法=============================================

#pragma mark - 创建视图
- (void)creatSubViewsAction {
    
    
    
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



#pragma mark ========================================网络请求=============================================

#pragma mark - 检测版本是否最新，如果已经是最新版本，那么现实 “当前版本”-----因评估审核而修改，否则会被拒
- (void)loadVersionAction {
    
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *app_Version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    
    [SOAPUrlSession updateVersionVer_info:app_Version
                                  success:^(id responseObject) {
                                      
                                      if (responseObject == nil) {
                                          return;
                                      }
                                      NSDictionary *dic =responseObject[@"data"];
                                      NSString *version = [NSString stringWithFormat:@"%@", dic[@"version"]];
                                      if ([version isEqualToString:@"1.0.0"]) {
                                          
                                          
                                          
                                      } else {
                                          
                                          //主线程更新视图
                                          dispatch_async(dispatch_get_main_queue(), ^{
                                              
                                              versionString = @"检查更新";
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
    
}


#pragma mark - 检测版本更新
- (void)updateVersionAction {
    
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *app_Version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    
    [SOAPUrlSession updateVersionVer_info:app_Version
                                  success:^(id responseObject) {
                                      
                                      NSString *responseCode = [NSString stringWithFormat:@"%@",responseObject[@"code"]];
                                      NSString *msg = [NSString stringWithFormat:@"%@",responseObject[@"msg"]];
                                      
                                      if (responseCode.integerValue == 0) {
                                          
                                          NSString *turnUrl = [NSString stringWithFormat:@"%@",responseObject[@"data"][@"turnUrl"]];
                                          NSString *varsion = [NSString stringWithFormat:@"%@",responseObject[@"data"][@"version"]];
                                          
                                          // 提示有需要更新
                                          dispatch_async(dispatch_get_main_queue(), ^{
                                              
                                              // 弹框提示是否执行
                                              UIAlertController *alert = [UIAlertController alertControllerWithTitle:[NSString stringWithFormat:@"最新版本v%@", varsion]
                                                                                                             message:msg
                                                                                                      preferredStyle:UIAlertControllerStyleAlert];
                                              
                                              [alert addAction:[UIAlertAction actionWithTitle:@"取消"
                                                                                        style:UIAlertActionStyleDefault
                                                                                      handler:^(UIAlertAction * _Nonnull action) {
                                                                                          
                                                                                      }]];
                                              [alert addAction:[UIAlertAction actionWithTitle:@"前往更新"
                                                                                        style:UIAlertActionStyleDefault
                                                                                      handler:^(UIAlertAction * _Nonnull action) {
                                                                                          
                                                                                          NSURL *iTunesURL = [NSURL URLWithString:turnUrl];
                                                                                          [[UIApplication sharedApplication] openURL:iTunesURL];
                                                                                          
                                                                                      }]];
                                              
                                              [self presentViewController:alert animated:YES completion:nil];
                                              
                                          });
                                          
                                      } else {
                                          
                                          //主线程更新视图
                                          dispatch_async(dispatch_get_main_queue(), ^{
                                              
                                              FadeAlertView *showMessage = [[FadeAlertView alloc] init];
                                              [showMessage showAlertWith:msg];
                                              
                                          });
                                          
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
    
    return 2;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 60.0;
    
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    return 0.01;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 0.01;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"SettingCell"];
    
    if (indexPath.row == 0) {
        
        // 检查更新
        cell.textLabel.text = versionString;
        
        if ([versionString isEqualToString:@"当前版本"]) {
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        } else {
            cell.selectionStyle = UITableViewCellSelectionStyleDefault;
        }
        
        if (versionLabel == nil) {
            // 版本标签
            versionLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 60, 20)];
            versionLabel.textAlignment = NSTextAlignmentRight;
            versionLabel.adjustsFontSizeToFitWidth = YES;
            versionLabel.textColor = Label_Color_B;
            versionLabel.font = [UIFont systemFontOfSize:17];
            NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
            NSString *app_Version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
            versionLabel.text = [NSString stringWithFormat:@"v%@", app_Version];
        }
        
        cell.accessoryView = versionLabel;
        
    } else {
        
        // 关于
        cell.textLabel.text = @"关于";
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.selectionStyle = UITableViewCellSelectionStyleDefault;
        
    }
    
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.row == 0) {
        
        // 如果已经死最新版本v1.0.0，那么不给予点击功能
        if ([versionString isEqualToString:@"检查更新"]) {
            
            // 版本更新检测
            [self updateVersionAction];
            
        }
        
        
        
    } else {
        
        AboutWeViewController *ctrl = [[AboutWeViewController alloc] init];
        [self.navigationController pushViewController:ctrl animated:YES];
        
    }
    
}


#pragma mark ========================================通知================================================





































@end
