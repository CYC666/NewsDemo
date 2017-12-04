//
//  CollectViewController.m
//  LFBaseFrameTwo
//
//  Created by 曹奕程 on 2017/11/2.
//  Copyright © 2017年 admin. All rights reserved.
//

#import "CollectViewController.h"
#import "PersonalListCell.h"
#import "PersonalListHeaderView.h"
#import "LoginViewController.h"
#import "SendIdeaViewController.h"
#import "DingSettingViewController.h"
#import "MessagewViewController.h"
#import "SettingViewController.h"
#import "PersonalInfoViewController.h"
#import "DListViewController.h"
#import "CollectListViewController.h"
#import "HistoryListViewController.h"

@interface CollectViewController () <UITableViewDelegate, UITableViewDataSource> {
    
    UITableView *_listTableView;
    
    UserInformation *userInfo;              // 用户信息单例
    
    SmallFunctionTool *smallFunc;           // 工具方法单例
    
    NSString *browsenum;                    // 历史浏览数量
    NSString *favoritenum;                  // 收藏数量
    NSString *mbrid;                        // ID
    NSString *member_img;                   // 头像
    NSString *member_nickname;              // 名字
    NSString *subscribenum;                 // 订阅数量
    NSString *unreadmsgnum;                 // 未读数量
    

    
}

@end

@implementation CollectViewController


#pragma mark ========================================生命周期========================================
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"我的";
    self.view.backgroundColor = Background_Color;
    userInfo = [UserInformation sharedInstance];
    smallFunc = [SmallFunctionTool sharedInstance];
    
    browsenum = @"0";
    favoritenum = @"0";
    mbrid = @"";
    member_img = @"";
    member_nickname = @"点击登录";
    subscribenum = @"0";
    unreadmsgnum = @"0";
    
    
    // 创建视图
    [self creatSubViewsAction];
    
    
    
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    // 获取个人信息
    [self loadPersonalInfonAction];
    
}

- (void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    
}

#pragma mark ========================================私有方法=============================================

#pragma mark - 创建视图
- (void)creatSubViewsAction {
    
    // 表视图
    _listTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - 49)
                                                  style:UITableViewStylePlain ];
    _listTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    _listTableView.backgroundColor = [UIColor clearColor];
    _listTableView.rowHeight = 60;
    _listTableView.delegate = self;
    _listTableView.dataSource = self;
    [_listTableView registerNib:[UINib nibWithNibName:@"PersonalListCell" bundle:[NSBundle mainBundle]]
         forCellReuseIdentifier:@"PersonalListCell"];
    [_listTableView registerNib:[UINib nibWithNibName:@"PersonalListHeaderView" bundle:[NSBundle mainBundle]] forHeaderFooterViewReuseIdentifier:@"PersonalListHeaderView"];
    [self.view addSubview:_listTableView];
    
#ifdef __IPHONE_11_0
    if(@available(iOS 11.0, *)){
        _listTableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
#else
    
#endif
    self.automaticallyAdjustsScrollViewInsets = NO;
    
}

#pragma mark - 获取个人信息
- (void)loadPersonalInfonAction {
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *mt_token = [userDefaults objectForKey:@"mt_token"];
    userInfo.mt_token = mt_token;
    
    if (userInfo.mt_token == nil || [userInfo.mt_token isEqualToString:@""]) {
        
        browsenum = @"0";
        favoritenum = @"0";
        mbrid = @"";
        member_img = @"";
        member_nickname = @"点击登录";
        subscribenum = @"0";
        unreadmsgnum = @"0";
        
        [userInfo clearData];
        
        [_listTableView reloadData];
        
    } else {
        
        // 已经登录，获取个人信息
        [SOAPUrlSession loadPersonalInfoActionSuccess:^(id responseObject) {
            
            NSString *responseCode = [NSString stringWithFormat:@"%@",responseObject[@"code"]];
            
            if (responseCode.integerValue == 0) {
                
                browsenum = [NSString stringWithFormat:@"%@", responseObject[@"data"][@"browsenum"]];
                favoritenum = [NSString stringWithFormat:@"%@", responseObject[@"data"][@"favoritenum"]];
                mbrid = [NSString stringWithFormat:@"%@", responseObject[@"data"][@"mbrid"]];
                member_img = [NSString stringWithFormat:@"%@", responseObject[@"data"][@"member_img"]];
                member_nickname = [NSString stringWithFormat:@"%@", responseObject[@"data"][@"member_nickname"]];
                subscribenum = [NSString stringWithFormat:@"%@", responseObject[@"data"][@"subscribenum"]];
                unreadmsgnum = [NSString stringWithFormat:@"%@", responseObject[@"data"][@"unreadmsgnum"]];
                
                //主线程更新视图
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    [_listTableView reloadData];
                    
                });
                
            } else {
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    FadeAlertView *showMessage = [[FadeAlertView alloc] init];
                    [showMessage showAlertWith:[NSString stringWithFormat:@"%@", responseObject[@"msg"]]];
                    
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
    
    
    
}

#pragma mark ========================================动作响应=============================================

#pragma mark - 点击头像
- (void)headButtonAction:(UIButton *)button {
    
    if (userInfo.mt_token == nil || [userInfo.mt_token isEqualToString:@""]) {
    
        // 尚未登录，前往登录
        LoginViewController *ctrl = [[LoginViewController alloc] init];
        [self.navigationController pushViewController:ctrl animated:YES];
        
    } else {

        // 跳转到个人信息页
        PersonalInfoViewController *ctrl = [[PersonalInfoViewController alloc] init];
        [self.navigationController pushViewController:ctrl animated:YES];
    }

}

#pragma mark - 点击订阅
- (void)dingButtonAction:(UIButton *)button {
    
    DListViewController *ctrl = [[DListViewController alloc] init];
    [self.navigationController pushViewController:ctrl animated:YES];
    
}

#pragma mark - 点击收藏
- (void)collectButtonAction:(UIButton *)button {
    
    CollectListViewController *ctrl = [[CollectListViewController alloc] init];
    [self.navigationController pushViewController:ctrl animated:YES];
    
}

#pragma mark - 点击历史浏览
- (void)historyButtonAction:(UIButton *)button {
    
    HistoryListViewController *ctrl = [[HistoryListViewController alloc] init];
    [self.navigationController pushViewController:ctrl animated:YES];
    
}

#pragma mark - 清除缓存
- (void)clearAction {
    
    CGFloat size = [self folderSizeAtPath:NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).lastObject] + [self folderSizeAtPath:NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES).lastObject] + [self folderSizeAtPath:NSTemporaryDirectory()];
    
    
    if (size < 1) {
        FadeAlertView *showMessage = [[FadeAlertView alloc] init];
        [showMessage showAlertWith:@"很干净，不需清理"];
        return;
    }
    
    [self cleanCaches:NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).lastObject];
    [self cleanCaches:NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES).lastObject];
    [self cleanCaches:NSTemporaryDirectory()];
    
    
    //显示风火轮
    [smallFunc createActivityIndicator:self.view AndKey:@"CollectViewController"];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        //停止风火轮
        [smallFunc stopActivityIndicator:@"CollectViewController"];
        
        FadeAlertView *showMessage = [[FadeAlertView alloc] init];
        [showMessage showAlertWith:[NSString stringWithFormat:@"清除了%.2fM", size]];
        
    });
    
}

// 计算目录大小
- (CGFloat)folderSizeAtPath:(NSString *)path{
    // 利用NSFileManager实现对文件的管理
    NSFileManager *manager = [NSFileManager defaultManager];
    CGFloat size = 0;
    if ([manager fileExistsAtPath:path]) {
        // 获取该目录下的文件，计算其大小
        NSArray *childrenFile = [manager subpathsAtPath:path];
        for (NSString *fileName in childrenFile) {
            NSString *absolutePath = [path stringByAppendingPathComponent:fileName];
            size += [manager attributesOfItemAtPath:absolutePath error:nil].fileSize;
        }
        // 将大小转化为M
        return size / 1024.0 / 1024.0;
    }
    return 0;
}

// 根据路径删除文件
- (void)cleanCaches:(NSString *)path{
    // 利用NSFileManager实现对文件的管理
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:path]) {
        // 获取该路径下面的文件名
        NSArray *childrenFiles = [fileManager subpathsAtPath:path];
        for (NSString *fileName in childrenFiles) {
            // 拼接路径
            NSString *absolutePath = [path stringByAppendingPathComponent:fileName];
            // 将文件删除
            [fileManager removeItemAtPath:absolutePath error:nil];
        }
    }
}


#pragma mark ========================================网络请求=============================================

#pragma mark ========================================代理方法=============================================

#pragma mark - 表视图代理方法
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 2;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (section == 0) {
        return 4;
    } else {
        return 1;
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 50;
    
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    return 0.01;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    if (section == 0) {
        return kScreenWidth * 0.75;
    } else {
        return 10.0;
    }
    
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    if (section == 0) {
        PersonalListHeaderView *view = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"PersonalListHeaderView"];
        
        // 设置头部背景CYC666
        NSString *topImagePath = [NSString stringWithFormat:@"%@%@", Java_Head_Image_URL, member_img];
        [view.topImageView sd_setImageWithURL:[NSURL URLWithString:topImagePath]
                              placeholderImage:[UIImage imageNamed:@"noLogin"]
                                       options:SDWebImageRetryFailed];
        
        // 设置头像
        NSString *headImagePath = [NSString stringWithFormat:@"%@%@", Java_Head_Image_URL, member_img];
        [view.headImageView sd_setImageWithURL:[NSURL URLWithString:headImagePath]
                             placeholderImage:[UIImage imageNamed:@"noLogin"]
                                      options:SDWebImageRetryFailed];
        [view.headButton addTarget:self action:@selector(headButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        
        // 名字-前景色
        view.nameFrontLabel.text = member_nickname;
        
        // 名字-背景色
        view.nameBackLabel.text = member_nickname;
        
        // 订阅
        view.dingNumberLabel.text = subscribenum;
        [view.dingButton addTarget:self action:@selector(dingButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        
        // 收藏
        view.collectNumberLabel.text = favoritenum;
        [view.collectButton addTarget:self action:@selector(collectButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        
        // 历史浏览
        view.historyNumberLabel.text = browsenum;
        [view.historyButton addTarget:self action:@selector(historyButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        
        return view;
    } else {
        return [[UIView alloc] initWithFrame:CGRectZero];
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    PersonalListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PersonalListCell"
                                                            forIndexPath:indexPath];
    
    if (indexPath.section == 0) {
        
        if (indexPath.row == 0) {
            
            cell.iconImageView.image = [UIImage imageNamed:@"message"];
            cell.nameLabel.text = @"消息";
            cell.unreadNumber = unreadmsgnum;
            
        } else if (indexPath.row == 1) {
            
            cell.iconImageView.image = [UIImage imageNamed:@"readSet"];
            cell.nameLabel.text = @"订阅设置";
            cell.unreadNumber = @"0";
            
        } else if (indexPath.row == 2) {
            
            cell.iconImageView.image = [UIImage imageNamed:@"yijian"];
            cell.nameLabel.text = @"意见反馈";
            cell.unreadNumber = @"0";
            
        } else {
            
            cell.iconImageView.image = [UIImage imageNamed:@"cookie"];
            cell.nameLabel.text = @"缓存清理";
            cell.unreadNumber = @"0";
            
        }
        
    } else {
        
        cell.iconImageView.image = [UIImage imageNamed:@"set"];
        cell.nameLabel.text = @"设置";
        cell.unreadNumber = @"0";
        
    }
    
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 0) {
        
        if (indexPath.row == 0) {
            
            // 消息
            MessagewViewController *ctrl = [[MessagewViewController alloc] init];
            [self.navigationController pushViewController:ctrl animated:YES];
            
        } else if (indexPath.row == 1) {
            
            // 订阅设置
            DingSettingViewController *ctrl = [[DingSettingViewController alloc] init];
            [self.navigationController pushViewController:ctrl animated:YES];
            
        } else if (indexPath.row == 2) {
            
            // 意见反馈
            SendIdeaViewController *ctrl = [[SendIdeaViewController alloc] init];
            [self.navigationController pushViewController:ctrl animated:YES];
            
        } else {
            
            // 清除缓存
            [self clearAction];
            
        }
        
    } else {
        
        // 设置
        SettingViewController *ctrl = [[SettingViewController alloc] init];
        [self.navigationController pushViewController:ctrl animated:YES];
    }
    
    
    
}

#pragma mark ========================================通知================================================






































@end
