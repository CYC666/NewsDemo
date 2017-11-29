//
//  LoginViewCell.m
//  LFBaseFrameTwo
//
//  Created by 曹奕程 on 2017/11/29.
//  Copyright © 2017年 admin. All rights reserved.
//

#import "LoginViewCell.h"

@implementation LoginViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    _loginButton.layer.cornerRadius = 5;
    _loginButton.layer.borderColor = Background_Color.CGColor;
    _loginButton.layer.borderWidth = 1;
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    // 收起键盘
    [_codeField addTarget:self action:@selector(hideKeyboard) forControlEvents:UIControlEventEditingDidEndOnExit];
    
}

- (void)hideKeyboard {
    
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
    
    
}

@end
