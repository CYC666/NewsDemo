//
//  NoCopyTextField.m
//  YiYanYunGou
//
//  Created by admin on 16/7/21.
//  Copyright © 2016年 admin. All rights reserved.
//

#import "NoCopyTextField.h"

@implementation NoCopyTextField

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

//长按或者双击时不弹出复制粘贴菜单
-(BOOL)canPerformAction:(SEL)action withSender:(id)sender {
    UIMenuController *menuController = [UIMenuController sharedMenuController];
    if (menuController) {
        [UIMenuController sharedMenuController].menuVisible = NO;
    }
    return NO;
}



@end
