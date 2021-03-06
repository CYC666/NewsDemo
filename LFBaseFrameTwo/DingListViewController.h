//
//  DingListViewController.h
//  LFBaseFrameTwo
//
//  Created by 曹奕程 on 2017/12/1.
//  Copyright © 2017年 admin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DingModel.h"

typedef void(^DingListViewControllerBlock)();


@protocol DingListViewControllerDelegate

// 切换了显示的类目
-(void)DingListViewControllerIndexChange:(NSInteger)index finishBlock:(DingListViewControllerBlock)finishBlock;

// 添加/删除了类目
- (void)DingListViewControllerAddModel:(DingModel *)model;



@end

@interface DingListViewController : UIViewController

// 代理
@property (weak, nonatomic) id<DingListViewControllerDelegate> delegate;

@end
