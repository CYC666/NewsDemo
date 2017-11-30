//
//  SelectSexView.h
//  LFBaseFrameTwo
//
//  Created by 曹奕程 on 2017/11/30.
//  Copyright © 2017年 admin. All rights reserved.
//

// 修改性别

#import <UIKit/UIKit.h>
@class SelectSexView;


@protocol SelectSexViewDlegate
-(void)SelectSexView:(NSString *)sex;
-(void)viewDismiss:(SelectSexView *)selectView;
@end

@interface SelectSexView : UIView

// 小背景
@property (weak, nonatomic) IBOutlet UIView *littleView;

// 返回按钮
@property (weak, nonatomic) IBOutlet UIButton *backButton;
@property (weak, nonatomic) IBOutlet UIButton *backButton2;

// 男
@property (weak, nonatomic) IBOutlet UIButton *boyButton;

// 女
@property (weak, nonatomic) IBOutlet UIButton *girlButton;

// 确定
@property (weak, nonatomic) IBOutlet UIButton *sureButton;



@property (copy, nonatomic) NSString *sexString;

// 代理
@property (weak, nonatomic) id<SelectSexViewDlegate> delegate;



+ (instancetype)viewFromXIB;


@end
