//
//  SellCollectionView.h
//  LFBaseFrameTwo
//
//  Created by 曹奕程 on 2017/9/25.
//  Copyright © 2017年 admin. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SellEnumModel;


@interface SellCollectionView : UICollectionView

@property (strong, nonatomic) UIViewController *superCtrl;      // 父控制器，必须设置，不然push不行

@property (strong, nonatomic) SellEnumModel *enumModel;         // 搜索的类型

@end
