//
//  LatestDingView.h
//  LFBaseFrameTwo
//
//  Created by 曹老师 on 2017/12/1.
//  Copyright © 2017年 admin. All rights reserved.
//

#import <UIKit/UIKit.h>



@protocol LatestDingViewDlegate

// 点击了单元格
-(void)LatestDingViewIndexSelect:(NSInteger)index;
@end

@interface LatestDingView : UIView

@property (strong, nonatomic) UIViewController *superCtrl;  // 父控制器

// 代理
@property (weak, nonatomic) id<LatestDingViewDlegate> cellDelegate;


- (void)reloadDataWithArray:(NSMutableArray *)dataArray;

@end
