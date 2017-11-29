//
//  SendIdeaViewController.m
//  LFBaseFrameTwo
//
//  Created by 曹奕程 on 2017/11/29.
//  Copyright © 2017年 admin. All rights reserved.
//

#import "SendIdeaViewController.h"
#import "SendIdeaCell.h"

@interface SendIdeaViewController () <UITableViewDelegate, UITableViewDataSource> {
    
    UITableView *_listTableView;
    
    UITextField *messageField;        // 意见文本输入框
    
    UILabel *tipLabel;                // 提示文本
    
    
    
    
}

@end

@implementation SendIdeaViewController

#pragma mark ========================================生命周期========================================
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"意见反馈";
    self.view.backgroundColor = Background_Color;
    // 创建视图
    [self creatSubViewsAction];
    
    
    
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
    [_listTableView registerNib:[UINib nibWithNibName:@"SendIdeaCell" bundle:[NSBundle mainBundle]]
         forCellReuseIdentifier:@"SendIdeaCell"];
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

#pragma mark - 网点追加
- (void)zhuijiaAction:(UIButton *)button {
    

    
}

#pragma mark - 点子
- (void)ideaAction:(UIButton *)button {
    
    
    
}

#pragma mark - 信息错误
- (void)errorAction:(UIButton *)button {
    
    
    
}

#pragma mark - 闪退
- (void)shantuiAction:(UIButton *)button {
    
    
    
}

#pragma mark - 其他
- (void)otherButtonAction:(UIButton *)button {
    
    
    
}

#pragma mark - 提交
- (void)commitButtonAction:(UIButton *)button {
    
    
    
}


#pragma mark ========================================网络请求=============================================

#pragma mark ========================================代理方法=============================================

#pragma mark - 表视图代理方法
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 1;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return kScreenHeight - 64;
    
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    return 0.01;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 0.01;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    SendIdeaCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SendIdeaCell"
                                                          forIndexPath:indexPath];
    
    //phoneField = cell.phoneField;
    //codeField = cell.codeField;
    
    // 获取验证码
    //[cell.codeButton addTarget:self action:@selector(codeButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    // 登录
    //[cell.loginButton addTarget:self action:@selector(loginButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    // 同意
    //[cell.agreeButton addTarget:self action:@selector(agreeButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    // 用户协议
    //[cell.textButton addTarget:self action:@selector(textButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
    
}


#pragma mark ========================================通知================================================



@end
