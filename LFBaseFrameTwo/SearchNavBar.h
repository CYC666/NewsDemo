//
//  SearchNavBar.h
//  LFBaseFrameTwo
//
//  Created by 曹老师 on 2017/12/1.
//  Copyright © 2017年 admin. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SearchNavBarDlegate
-(void)SearchNavBarTipButtonAction;
@end

@interface SearchNavBar : UIView

@property (strong, nonatomic) UILabel *tipLabel;    // 左边的提示
@property (strong, nonatomic) UITextField *field;   // 输入框

// 代理
@property (weak, nonatomic) id<SearchNavBarDlegate> delegate;

@end
