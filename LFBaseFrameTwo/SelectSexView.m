//
//  SelectSexView.m
//  LFBaseFrameTwo
//
//  Created by 曹奕程 on 2017/11/30.
//  Copyright © 2017年 admin. All rights reserved.
//

#import "SelectSexView.h"

@implementation SelectSexView


//简单封装了创建xib的方法
+ (instancetype)viewFromXIB {
    
    return [[[NSBundle mainBundle] loadNibNamed:@"SelectSexView" owner:nil options:nil] firstObject];
    
}

- (void)awakeFromNib {
    
    [super awakeFromNib];
    
    _sexString = @"男";
    
    // 阴影
    _littleView.layer.shadowColor = Label_Color_A.CGColor;
    _littleView.layer.shadowOffset = CGSizeMake(0, 0);
    _littleView.layer.shadowRadius = 5;
    _littleView.layer.shadowOpacity = 0.5;
    
}


#pragma mark - 退出
- (IBAction)backAction:(id)sender {
    
    [_delegate viewDismiss:self];
    
}
- (IBAction)backAction2:(id)sender {
    
    [_delegate viewDismiss:self];
    
}


#pragma mark - 男
- (IBAction)boyButtonAction:(id)sender {
    
    _sexString = @"男";
    
    _boyButton.backgroundColor = Publie_Color;
    [_boyButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    _girlButton.backgroundColor = [UIColor whiteColor];
    [_girlButton setTitleColor:Publie_Color forState:UIControlStateNormal];
    
}


#pragma mark - 女
- (IBAction)girlButtonAction:(id)sender {
    
    _sexString = @"女";
    
    _boyButton.backgroundColor = [UIColor whiteColor];
    [_boyButton setTitleColor:Publie_Color forState:UIControlStateNormal];
    
    _girlButton.backgroundColor = Publie_Color;
    [_girlButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    
}


#pragma mark - 确认
- (IBAction)sureButtonAction:(id)sender {
    
    [_delegate SelectSexView:_sexString];
    
}































@end
