//
//  SearchWithWebViewController.h
//  LFBaseFrameTwo
//
//  Created by 曹老师 on 2017/12/2.
//  Copyright © 2017年 admin. All rights reserved.
//

#import <UIKit/UIKit.h>
@class NewsListModel;

@protocol SearchWithWebViewControllerDlegate

// 收藏状态发生改变
-(void)SearchWithWebViewControllerCollectChange:(NewsListModel *)model;
@end

@interface SearchWithWebViewController : UIViewController

@property (strong, nonatomic) NewsListModel *ctrlModel;
@property (assign, nonatomic) NSInteger rowIndex;       // 单元格位置，用于返回给上一级，单个刷新

// 代理
@property (weak, nonatomic) id<SearchWithWebViewControllerDlegate> delegate;

@end
