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

@interface CollectViewController () <UITableViewDelegate, UITableViewDataSource> {
    
    UITableView *_listTableView;
    
    SmallFunctionTool *smallFunc;           // 工具方法单例
    
}

@end

@implementation CollectViewController


#pragma mark ========================================生命周期========================================
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"我的";
    self.view.backgroundColor = Background_Color;
    smallFunc = [SmallFunctionTool sharedInstance];
    
    // 创建视图
    [self creatSubViewsAction];
    
    
    
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



#pragma mark ========================================动作响应=============================================

#pragma mark - 点击头像
- (void)headButtonAction:(UIButton *)button {
    
    LoginViewController *ctrl = [[LoginViewController alloc] init];
    [self.navigationController pushViewController:ctrl animated:YES];
    
}

#pragma mark - 点击订阅
- (void)dingButtonAction:(UIButton *)button {
    
    FadeAlertView *showMessage = [[FadeAlertView alloc] init];
    [showMessage showAlertWith:@"点击订阅"];
    
}

#pragma mark - 点击收藏
- (void)collectButtonAction:(UIButton *)button {
    
    FadeAlertView *showMessage = [[FadeAlertView alloc] init];
    [showMessage showAlertWith:@"点击收藏"];
    
}

#pragma mark - 点击历史浏览
- (void)historyButtonAction:(UIButton *)button {
    
    FadeAlertView *showMessage = [[FadeAlertView alloc] init];
    [showMessage showAlertWith:@"点击历史浏览"];
    
}

#pragma mark - 清除缓存
- (void)clearAction {
    
    // 计算缓存大小
    float totalSize = 0;
    NSString * diskCachePath = NSSearchPathForDirectoriesInDomains ( NSCachesDirectory , NSUserDomainMask , YES )[0];
    NSDirectoryEnumerator *fileEnumerator = [[NSFileManager defaultManager] enumeratorAtPath:diskCachePath];
    for (NSString *fileName in fileEnumerator) {
        NSString *filePath = [diskCachePath stringByAppendingPathComponent:fileName];
        NSDictionary *attrs = [[NSFileManager defaultManager] attributesOfItemAtPath:filePath error:nil];
        unsigned long long length = [attrs fileSize];
        totalSize += length / 1024.0 / 1024.0;
    }
    
    if (totalSize < 1) {
        FadeAlertView *showMessage = [[FadeAlertView alloc] init];
        [showMessage showAlertWith:@"很干净，不需清理"];
        return;
    }
    
    //使用第三方框架SDWebImage缓存图片，才能对应的清除缓存图片
    [[SDImageCache sharedImageCache] clearDisk];
    
    //显示风火轮
    [smallFunc createActivityIndicator:self.view AndKey:@"CollectViewController"];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        //停止风火轮
        [smallFunc stopActivityIndicator:@"CollectViewController"];
        
        FadeAlertView *showMessage = [[FadeAlertView alloc] init];
        [showMessage showAlertWith:[NSString stringWithFormat:@"清除了%.2fM", totalSize]];
        
    });
    
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
    
    return 60.0;
    
    
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
        NSString *topImagePath = [NSString stringWithFormat:@"%@%@", Java_Image_URL, @""];
        [view.topImageView sd_setImageWithURL:[NSURL URLWithString:topImagePath]
                              placeholderImage:[UIImage imageNamed:@"loadfail-0"]
                                       options:SDWebImageRetryFailed];
        
        // 设置头像
        NSString *headImagePath = [NSString stringWithFormat:@"%@%@", Java_Image_URL, @""];
        [view.headImageView sd_setImageWithURL:[NSURL URLWithString:headImagePath]
                             placeholderImage:[UIImage imageNamed:@"loadfail-0"]
                                      options:SDWebImageRetryFailed];
        [view.headButton addTarget:self action:@selector(headButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        
        // 名字-前景色
        view.nameFrontLabel.text = @"侯尧";
        
        // 名字-背景色
        view.nameBackLabel.text = @"侯尧";
        
        // 订阅
        view.dingNumberLabel.text = @"99";
        [view.dingButton addTarget:self action:@selector(dingButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        
        // 收藏
        view.collectNumberLabel.text = @"88";
        [view.collectButton addTarget:self action:@selector(collectButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        
        // 历史浏览
        view.historyNumberLabel.text = @"77";
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
        } else if (indexPath.row == 1) {
            
            cell.iconImageView.image = [UIImage imageNamed:@"readSet"];
            cell.nameLabel.text = @"订阅设置";
        } else if (indexPath.row == 2) {
            
            cell.iconImageView.image = [UIImage imageNamed:@"yijian"];
            cell.nameLabel.text = @"意见反馈";
        } else {
            
            cell.iconImageView.image = [UIImage imageNamed:@"cookie"];
            cell.nameLabel.text = @"缓存清理";
        }
        
    } else {
        
        cell.iconImageView.image = [UIImage imageNamed:@"set"];
        cell.nameLabel.text = @"设置";
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
