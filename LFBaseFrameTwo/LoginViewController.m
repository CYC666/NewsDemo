//
//  LoginViewController.m
//  LFBaseFrameTwo
//
//  Created by 曹奕程 on 2017/11/29.
//  Copyright © 2017年 admin. All rights reserved.
//

#import "LoginViewController.h"
#import "LoginViewCell.h"
#import <AFNetworking.h>



@interface LoginViewController () <UITableViewDelegate, UITableViewDataSource> {
    
    UITableView *_listTableView;
    
    UIButton *codeButton;           // 获取验证码按钮
    
    UITextField *phoneField;        // 手机号码输入框
    
    UITextField *codeField;         // 验证码输入框
    
    UIButton *loginButton;          // 登录按钮
    
    BOOL isAgree;                   // 是否同意
    
    UserInformation *userInfo;              // 用户信息单例
    
    SmallFunctionTool *smallFunc;           // 工具方法单例
    
}

@end

@implementation LoginViewController

#pragma mark ========================================生命周期========================================
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"登录";
    isAgree = YES;
    self.view.backgroundColor = [UIColor whiteColor];
    
    //初始化
    userInfo = [UserInformation sharedInstance];
    [userInfo clearData];
    
    smallFunc = [SmallFunctionTool sharedInstance];
    
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
    [_listTableView registerNib:[UINib nibWithNibName:@"LoginViewCell" bundle:[NSBundle mainBundle]]
         forCellReuseIdentifier:@"LoginViewCell"];
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

#pragma mark - 获取验证码
- (void)codeButtonAction:(UIButton *)button {
    
    // 验证是否是手机号码
    if (![SmallFunctionTool checkTelNumber:phoneField.text]) {
        FadeAlertView *showMessage = [[FadeAlertView alloc] init];
        [showMessage showAlertWith:@"请输入正确的手机号码"];
        return;
    }
    
    
    
    
    //发送soap请求
    [SOAPUrlSession getCodeAction:phoneField.text success:^(id responseObject) {
        
        NSString *responseCode = [NSString stringWithFormat:@"%@",responseObject[@"code"]];
        
        if (responseCode.integerValue == 0) {
            
            // 获取验证码成功
            //主线程更新视图
            dispatch_async(dispatch_get_main_queue(), ^{
                
                codeButton.userInteractionEnabled = NO;
                [codeButton setTitle:@"已发送验证码" forState:UIControlStateNormal];
                
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

#pragma mark - 登录
- (void)loginButtonAction:(UIButton *)button {
    
    // 查看是否已经同意了用户服务协议
    if (!isAgree) {
        FadeAlertView *showMessage = [[FadeAlertView alloc] init];
        [showMessage showAlertWith:@"需同意用户服务协议"];
        return;
    }
    
    // 验证是否是手机号码
    if (![SmallFunctionTool checkTelNumber:phoneField.text]) {
        FadeAlertView *showMessage = [[FadeAlertView alloc] init];
        [showMessage showAlertWith:@"请输入正确的手机号码"];
        return;
    }
    
    if ([codeField.text isEqualToString:@""]) {
        FadeAlertView *showMessage = [[FadeAlertView alloc] init];
        [showMessage showAlertWith:@"请填写验证码"];
        return;
    }
    
    [SOAPUrlSession loginAction:phoneField.text
                           code:codeField.text
                        success:^(id responseObject) {
                            
                            NSString *responseCode = [NSString stringWithFormat:@"%@",responseObject[@"code"]];
                            
                            if (responseCode.integerValue == 0) {
                                
                                // 登陆成功，数据缓存
                                NSString *mt_mbrid = [NSString stringWithFormat:@"%@", responseObject[@"data"][@"mt_mbrid"]];
                                NSString *mt_mobile = [NSString stringWithFormat:@"%@", responseObject[@"data"][@"mt_mobile"]];
                                NSString *mt_token = [NSString stringWithFormat:@"%@", responseObject[@"data"][@"mt_token"]];
                                NSString *visitor = [NSString stringWithFormat:@"%@", responseObject[@"visitor"]];
                                
                                //存入NSUserDefaults文件中
                                NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
                                [userDefaults setObject:mt_token forKey:@"mt_token"];
                                [userDefaults setObject:visitor forKey:@"visitor"];
                                [userDefaults synchronize]; //立即同步
                                
                                userInfo.member_id = mt_mbrid;
                                userInfo.member_mobile = mt_mobile;
                                userInfo.mt_token = mt_token;
                                userInfo.visitor = visitor;
                                
                                //主线程更新视图
                                dispatch_async(dispatch_get_main_queue(), ^{
                                    
                                    [self.navigationController popViewControllerAnimated:YES];
                                    
                                });
                                
                            } else {
                                
                                //主线程更新视图
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

#pragma mark - 同意按钮
- (void)agreeButtonAction:(UIButton *)button {
    
    isAgree = !isAgree;
    
    if (isAgree) {
        [button setImage:[UIImage imageNamed:@"agree"] forState:UIControlStateNormal];
    } else {
        [button setImage:[UIImage imageNamed:@"disagree"] forState:UIControlStateNormal];
    }
    
}

#pragma mark - 用户协议按钮
- (void)textButtonAction:(UIButton *)button {
    
    FadeAlertView *showMessage = [[FadeAlertView alloc] init];
    [showMessage showAlertWith:@"前往查看用户服务协议"];
    
}

#pragma mark - 输入验证码
- (void)codeFieldAction:(UITextField *)field {
    
    // 验证是否是手机号码
    if (![SmallFunctionTool checkTelNumber:phoneField.text]) {
        return;
    }
    
    if ([field.text isEqualToString:@""]) {
        
        [loginButton setBackgroundColor:[UIColor whiteColor]];
        [loginButton setTitleColor:Label_Color_C forState:UIControlStateNormal];
        
    } else {
        
        [loginButton setBackgroundColor:Publie_Color];
        [loginButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
    }
    
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
    
    LoginViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LoginViewCell"
                                                            forIndexPath:indexPath];
    
    phoneField = cell.phoneField;
    codeField = cell.codeField;
    codeButton = cell.codeButton;
    loginButton = cell.loginButton;
    
    [codeField addTarget:self action:@selector(codeFieldAction:) forControlEvents:UIControlEventEditingChanged];
    
    // 获取验证码
    [cell.codeButton addTarget:self action:@selector(codeButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    // 登录
    [cell.loginButton addTarget:self action:@selector(loginButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    // 同意
    [cell.agreeButton addTarget:self action:@selector(agreeButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    // 用户协议
    [cell.textButton addTarget:self action:@selector(textButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
    
}


#pragma mark ========================================通知================================================

































@end
