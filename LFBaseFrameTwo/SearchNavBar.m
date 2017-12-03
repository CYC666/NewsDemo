//
//  SearchNavBar.m
//  LFBaseFrameTwo
//
//  Created by 曹老师 on 2017/12/1.
//  Copyright © 2017年 admin. All rights reserved.
//

#import "SearchNavBar.h"

@implementation SearchNavBar

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        
        [self creatSubViewsAction];
        
    }
    return self;
    
    
}


#pragma mark - 创建视图
- (void)creatSubViewsAction {
    
    CGFloat wid = self.frame.size.width;
    CGFloat hei = self.frame.size.height;
    
    _tipLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 40, hei)];
    _tipLabel.textAlignment = NSTextAlignmentCenter;
    _tipLabel.adjustsFontSizeToFitWidth = YES;
    _tipLabel.textColor = Publie_Color;
    _tipLabel.font = [UIFont systemFontOfSize:13];
    [self addSubview:_tipLabel];
    
    UIButton *tipButton = [UIButton buttonWithType:UIButtonTypeCustom];
    tipButton.frame = CGRectMake(0, 0, 40, hei);
    [tipButton addTarget:self action:@selector(tipButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:tipButton];
    
    _field = [[UITextField alloc] initWithFrame:CGRectMake(40, 0, wid - 40 - 10, hei)];
    _field.textColor = Publie_Color;
    _field.tintColor = Publie_Color;
    _field.font = [UIFont systemFontOfSize:13];
    _field.textAlignment = NSTextAlignmentCenter;
    _field.returnKeyType = UIReturnKeySend;
    _field.clearButtonMode = UITextFieldViewModeWhileEditing;
    [self addSubview:_field];
    
    self.layer.cornerRadius = 5;
    self.clipsToBounds = YES;
    self.backgroundColor = [UIColor whiteColor];
    

    
}



#pragma mark - 点击提示名称按钮
- (void)tipButtonAction:(UIButton *)button {
    
    [_delegate SearchNavBarTipButtonAction];
    
}




































@end
