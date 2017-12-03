//
//  HotDingView.h
//  LFBaseFrameTwo
//
//  Created by 曹老师 on 2017/12/1.
//  Copyright © 2017年 admin. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol HotDingViewDlegate

// 点击了单元格
-(void)HotDingViewIndexSelect:(NSInteger)index;
@end

@interface HotDingView : UIView

@property (strong, nonatomic) UIViewController *superCtrl;  // 父控制器

// 代理
@property (weak, nonatomic) id<HotDingViewDlegate> cellDelegate;


- (void)reloadDataWithArray:(NSMutableArray *)dataArray;


@end
