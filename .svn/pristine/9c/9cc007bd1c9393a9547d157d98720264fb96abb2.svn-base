//
//  LFChangeTextView.h
//  YiYanYunGou
//
//  Created by admin on 16/9/30.
//  Copyright © 2016年 admin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RollLabelInfo.h"

//通过宏定义用printf()函数来替换原来的NSLog，（该修改仅针对开发模式生效）
#ifndef __OPTIMIZE__
#define NSLog(...) printf("%f %s\n",[[NSDate date]timeIntervalSince1970],[[NSString stringWithFormat:__VA_ARGS__]UTF8String]);
#endif

@class LFChangeTextView;

@protocol LFChangeTextViewDelegate <NSObject>

//代理方法中加了点击操作，返回点击的label对应的index
- (void)changeTextView:(LFChangeTextView *)textView didTapedAtIndex:(NSInteger)index;

@end

@interface LFChangeTextView : UIView

@property (nonatomic, assign) id<LFChangeTextViewDelegate> delegate;

//初始化滚动的数组
- (void)animationWithTexts:(NSArray *)textAry;
//停止滚动
- (void)stopAnimation;
//开始滚动
- (void)beginAnimation;

//适用于当前项目，滚动的文本有颜色，需要在初始化以及赋值的时候使用富文本
- (void)animationWithAttributedTexts:(NSArray <RollLabelInfo *>*)textAry;

//是否显示无数据时的提示
@property (nonatomic) BOOL isShowNoDateTip;
@property (nonatomic) NSString *noDateTipStr;
@property (nonatomic) BOOL isRefreshBegin;

@end
