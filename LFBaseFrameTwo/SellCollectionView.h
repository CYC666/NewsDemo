//
//  SellCollectionView.h
//  LFBaseFrameTwo
//
//  Created by 曹奕程 on 2017/9/25.
//  Copyright © 2017年 admin. All rights reserved.
//

#import <UIKit/UIKit.h>
@class DingModel;


@interface SellCollectionView : UICollectionView

@property (strong, nonatomic) UIViewController *superCtrl;      // 父控制器，必须设置，不然push不行

@property (strong, nonatomic) DingModel *enumModel;
@property (copy, nonatomic) NSString *art_type;                 //（文章类别：全部 -1 招标信息 1  中标公示 0）

@end
