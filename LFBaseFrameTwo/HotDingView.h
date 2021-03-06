//
//  HotDingView.h
//  LFBaseFrameTwo
//
//  Created by 曹老师 on 2017/12/1.
//  Copyright © 2017年 admin. All rights reserved.
//

#import <UIKit/UIKit.h>
@class DingModel;

@protocol HotDingViewDlegate

// 点击订阅按钮
-(void)HotDingViewIndexSelect:(DingModel *)model;

// 点击了单元格
-(void)HotDingViewSelectCell:(DingModel *)model;

@end

@interface HotDingView : UIView

@property (strong, nonatomic) UIViewController *superCtrl;  // 父控制器

// 代理
@property (weak, nonatomic) id<HotDingViewDlegate> cellDelegate;


- (void)reloadDataWithArray:(NSMutableArray *)dataArray;
- (void)loadHoyTypeAction;  // 获取数据


@end
