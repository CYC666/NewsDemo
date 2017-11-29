//
//  LoginViewCell.h
//  LFBaseFrameTwo
//
//  Created by 曹奕程 on 2017/11/29.
//  Copyright © 2017年 admin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginViewCell : UITableViewCell



//手机号
@property (weak, nonatomic) IBOutlet UITextField *phoneField;

//获取验证码按钮
@property (weak, nonatomic) IBOutlet UIButton *codeButton;

//验证码
@property (weak, nonatomic) IBOutlet UITextField *codeField;

//登录按钮
@property (weak, nonatomic) IBOutlet UIButton *loginButton;

//同意按钮
@property (weak, nonatomic) IBOutlet UIButton *agreeButton;

//服务协议按钮
@property (weak, nonatomic) IBOutlet UIButton *textButton;




@end
