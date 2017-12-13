//
//  DidAddListView.h
//  LFBaseFrameTwo
//
//  Created by 曹奕程 on 2017/12/1.
//  Copyright © 2017年 admin. All rights reserved.
//

#import <UIKit/UIKit.h>
@class DingModel;

@protocol DidAddListViewDlegate

// 点击了单元格
-(void)DidAddListViewIndexSelect:(DingModel *)model;
@end

@interface DidAddListView : UIView

// 列表
@property (strong, nonatomic) UICollectionView *listCollectionView;

// 是否编辑状态
@property (assign, nonatomic) BOOL isEdit;

// 代理
@property (weak, nonatomic) id<DidAddListViewDlegate> cellDelegate;

- (void)reloadDataWithArray:(NSMutableArray *)dataArray;


@end
