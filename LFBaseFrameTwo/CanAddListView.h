//
//  CanAddListView.h
//  LFBaseFrameTwo
//
//  Created by 曹奕程 on 2017/12/1.
//  Copyright © 2017年 admin. All rights reserved.
//

#import <UIKit/UIKit.h>
@class DingModel;

@protocol CanAddListViewDlegate

// 点击了单元格
-(void)CanAddListViewIndexSelect:(DingModel *)model;
@end

@interface CanAddListView : UIView

// 列表
@property (strong, nonatomic) UICollectionView *listCollectionView;

// 是否是编辑状态
@property (assign, nonatomic) BOOL isEdit;

// 代理
@property (weak, nonatomic) id<CanAddListViewDlegate> cellDelegate;


- (void)reloadDataWithArray:(NSMutableArray *)dataArray;

@end
