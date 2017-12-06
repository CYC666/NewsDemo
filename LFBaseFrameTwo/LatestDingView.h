//
//  LatestDingView.h
//  LFBaseFrameTwo
//
//  Created by 曹老师 on 2017/12/1.
//  Copyright © 2017年 admin. All rights reserved.
//

#import <UIKit/UIKit.h>
@class DingModel;


@protocol LatestDingViewDlegate

// 点击了订阅
-(void)LatestDingViewIndexSelect:(DingModel *)model;

// 点击了单元格
-(void)HotDingViewSelectCell:(NSInteger)index;

@end

@interface LatestDingView : UIView

@property (strong, nonatomic) UIViewController *superCtrl;  // 父控制器

// 代理
@property (weak, nonatomic) id<LatestDingViewDlegate> cellDelegate;


- (void)reloadDataWithArray:(NSMutableArray *)dataArray;
- (void)loadNewTypeAction;  // 获取数据

@end
