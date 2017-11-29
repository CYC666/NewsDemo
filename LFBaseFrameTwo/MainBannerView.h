//
//  MainBannerView.h
//  LFBaseFrameTwo
//
//  Created by 曹奕程 on 2017/9/21.
//  Copyright © 2017年 admin. All rights reserved.
//

#import "SDCycleScrollView.h"

@interface MainBannerView : SDCycleScrollView

@property (strong, nonatomic) UIViewController *superStrl;  // 父控制器，必须要设置，不然PUSH不能

@end
