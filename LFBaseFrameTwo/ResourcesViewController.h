//
//  ResourcesViewController.h
//  LFBaseFrameTwo
//
//  Created by 曹奕程 on 2017/11/2.
//  Copyright © 2017年 admin. All rights reserved.
//

#import <UIKit/UIKit.h>
@class DingModel;

@interface ResourcesViewController : UIViewController

// 要显示的类型，不赋予任何值，初始为全部
@property (strong, nonatomic) DingModel *selectModel;

@end
