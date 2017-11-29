//
//  NewsEnumView.h
//  LFBaseFrameTwo
//
//  Created by 曹老师 on 2017/11/29.
//  Copyright © 2017年 admin. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol NewsEnumViewDlegate
-(void)TopSearchViewIndexChange:(NSInteger)index;
@end


@interface NewsEnumView : UIView


@property (strong, nonatomic) UIButton *AllButton;      // 全部
@property (strong, nonatomic) UIButton *zhaoButton;     // 招标
@property (strong, nonatomic) UIButton *zhongButton;    // 中标

// 代理
@property (weak, nonatomic) id<NewsEnumViewDlegate> delegate;

@end
