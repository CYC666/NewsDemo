//
//  SellEnumView.h
//  LFBaseFrameTwo
//
//  Created by 曹奕程 on 2017/9/25.
//  Copyright © 2017年 admin. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SellEnumModel;

@protocol SellEnumViewDelegate <NSObject>

// 切换了类型
- (void)didChangeEnum:(SellEnumModel *)model indexPath:(NSInteger)index;

// 所有类型加载完毕
- (void)didLoadAllType:(NSArray<SellEnumModel *> *)typeArray;


@end


@interface SellEnumView : UICollectionView

// 代理
@property (weak, nonatomic) id<SellEnumViewDelegate> enumDelegate;

// 类别的个数
@property (assign, nonatomic, readonly) NSInteger typeCounts;

// 显示的类目（不设置就显示 全部）
@property (strong, nonatomic) SellEnumModel *selectModel;

// 重新设置单元格的显示，尤其是那根白线
- (void)setCellsDisplay:(NSInteger)index;

@end
