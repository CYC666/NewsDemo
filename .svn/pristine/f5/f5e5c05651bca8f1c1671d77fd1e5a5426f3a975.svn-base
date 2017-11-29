//
//  LFChangeTextView.m
//  YiYanYunGou
//
//  Created by admin on 16/9/30.
//  Copyright © 2016年 admin. All rights reserved.
//

#import "LFChangeTextView.h"
#import "SmallFunctionTool.h"

#define DEALY_WHEN_TITLE_IN_MIDDLE  3.0
#define DEALY_WHEN_TITLE_IN_BOTTOM  0.0

//设置枚举类型
typedef NS_ENUM(NSUInteger, LFTitlePosition) {
    LFTitlePositionTop    = 1,
    LFTitlePositionMiddle = 2,
    LFTitlePositionBottom = 3
};

@interface LFChangeTextView ()

@property (nonatomic, strong) UILabel *textLabel;
//@property (nonatomic, strong) NSArray *contentsAry;  //原来的，不能显示富文本
@property (nonatomic, strong) NSArray <RollLabelInfo *>*contentsAry; //传来的是对象，以便使用富文本
@property (nonatomic, assign) CGPoint topPosition;
@property (nonatomic, assign) CGPoint middlePosition;
@property (nonatomic, assign) CGPoint bottomPosition;
/*
 *1.控制延迟时间，当文字在中间时，延时时间长一些，如5秒，这样可以让用户浏览清楚内容；
 *2.当文字隐藏在底部的时候，不需要延迟，这样衔接才流畅；
 *3.通过上面的宏定义去更改需要的值
 */
@property (nonatomic, assign) CGFloat needDealy;
@property (nonatomic, assign) NSInteger currentIndex;  /*当前播放到那个标题了*/
@property (nonatomic, assign) BOOL shouldStop;         /*是否停止*/

@end

@implementation LFChangeTextView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.topPosition    = CGPointMake(self.frame.size.width/2, -self.frame.size.height/2);
        self.middlePosition = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
        self.bottomPosition = CGPointMake(self.frame.size.width/2, self.frame.size.height/2*3);
        self.shouldStop = NO;
        _textLabel = [[UILabel alloc] init];
        _textLabel.layer.bounds = CGRectMake(0, 0, CGRectGetWidth(frame), CGRectGetHeight(frame));
        _textLabel.layer.position = self.middlePosition;
//        _textLabel.textAlignment = NSTextAlignmentCenter; //居中显示label
        _textLabel.textAlignment = NSTextAlignmentLeft; //居左显示label
        _textLabel.numberOfLines = 2; //设置最多2行
        _textLabel.font = [UIFont systemFontOfSize:15.0f]; //设置字体
        [self addSubview:_textLabel];
        self.clipsToBounds = YES;   /*保证文字不跑出视图*/
        self.needDealy = DEALY_WHEN_TITLE_IN_MIDDLE;    /*控制第一次显示时间*/
        self.currentIndex = 0;
        
        //自己定义的几个变量
        _isShowNoDateTip = NO;
        _isRefreshBegin = NO;
    }
    return self;
}

//直接显示的文本
- (void)animationWithTexts:(NSArray *)textAry {
    self.currentIndex = 0;
    self.contentsAry = textAry;
    self.textLabel.text = [textAry objectAtIndex:0];
    [self startAnimation];
}

//适用于当前项目，滚动的文本有颜色，需要在初始化以及赋值的时候使用富文本
- (void)animationWithAttributedTexts:(NSArray <RollLabelInfo *> *)textAry {
    
    self.shouldStop = NO;
    self.currentIndex = 0;
    self.contentsAry = textAry;

    self.textLabel.textColor=[UIColor colorWithRed:82/255.0 green:108/255.0 blue:136/255.0 alpha:1.0f];
    
    //显示无数据时的提示
    if (_isShowNoDateTip && _noDateTipStr != nil) {
        self.textLabel.text = _noDateTipStr;
    } else {
        self.textLabel.text = [self changeTextToAttributedString:textAry[0]];
    }
    
    
    if (_isRefreshBegin) {
        //解决60秒刷新时，动画效果叠加
        self.needDealy = DEALY_WHEN_TITLE_IN_MIDDLE;    /*控制第一次显示时间*/
        _isRefreshBegin = NO;
    } else {
        //开始动画
        [self startAnimation];
    }
}


- (void)startAnimation {
    
    __weak typeof(self) weakSelf = self;
    
    [UIView animateWithDuration:0.3 delay:self.needDealy options:UIViewAnimationOptionCurveEaseInOut animations:^{
        if ([weakSelf currentTitlePosition] == LFTitlePositionMiddle) {
            weakSelf.textLabel.layer.position = weakSelf.topPosition;
        } else if ([weakSelf currentTitlePosition] == LFTitlePositionBottom) {
            weakSelf.textLabel.layer.position = weakSelf.middlePosition;
        }
    } completion:^(BOOL finished) {
        if ([weakSelf currentTitlePosition] == LFTitlePositionTop) {
            weakSelf.textLabel.layer.position = weakSelf.bottomPosition;
            weakSelf.needDealy = DEALY_WHEN_TITLE_IN_BOTTOM;
            weakSelf.currentIndex ++;
            
            //显示无数据时的提示
            if (_isShowNoDateTip && _noDateTipStr != nil) {
                weakSelf.textLabel.text = _noDateTipStr;
            } else {
                //这里有一个崩溃的异常，可能出现weakSelf.contentsAry数组为空，而index不为0导致数组越界
                if (weakSelf.contentsAry.count > 0 && [weakSelf realCurrentIndex] < weakSelf.contentsAry.count) {
                    weakSelf.textLabel.text = [weakSelf changeTextToAttributedString:[weakSelf.contentsAry objectAtIndex:[weakSelf realCurrentIndex]]];
                }
                
            }
        } else {
            weakSelf.needDealy = DEALY_WHEN_TITLE_IN_MIDDLE;
        }
        
        if (!weakSelf.shouldStop) {
            [weakSelf startAnimation];
        } else { //停止动画后，要设置label位置和label显示内容
            weakSelf.textLabel.layer.position = weakSelf.middlePosition;
            
            //显示无数据时的提示
            if (_isShowNoDateTip && _noDateTipStr != nil) {
                weakSelf.textLabel.text = _noDateTipStr;
            } else {
                weakSelf.textLabel.text = [weakSelf changeTextToAttributedString:[weakSelf.contentsAry objectAtIndex:[weakSelf realCurrentIndex]]];
            }
        }
    }];
    
    
    
}

- (void)stopAnimation {
    self.shouldStop = YES;
}
- (void)beginAnimation {
    self.shouldStop = NO;
}

- (NSInteger)realCurrentIndex {
    return self.currentIndex % [self.contentsAry count];
}

- (LFTitlePosition)currentTitlePosition {
    if (self.textLabel.layer.position.y == self.topPosition.y) {
        return LFTitlePositionTop;
    } else if (self.textLabel.layer.position.y == self.middlePosition.y) {
        return LFTitlePositionMiddle;
    }
    return LFTitlePositionBottom;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    if ([self.delegate respondsToSelector:@selector(changeTextView:didTapedAtIndex:)]) {
        [self.delegate changeTextView:self didTapedAtIndex:[self realCurrentIndex]];
    }
    
    NSLog(@"12");
}

//设置颜色
- (NSString *)changeTextToAttributedString:(RollLabelInfo *)labelInfo {
    
    //昵称
   // NSString *aliasStr;
//    if ([labelInfo.Alias isEqualToString:@""] || labelInfo.Alias == nil) {
//        //没有昵称，使用加密的电话
//        aliasStr = [SmallFunctionTool lockMobileNumber:labelInfo.Mobile];
//    } else {
//        aliasStr = labelInfo.Alias;
//    }
    
    //金额
//    NSString *moneyStr = [NSString stringWithFormat:@"%@元",labelInfo.DetailsMoney];
//    //时间
//    NSString *dateStr = [NSString stringWithFormat:@"%@",labelInfo.CreateDate];
//    
//    
//    
//    NSString *allStr = [NSString stringWithFormat:@"%@ 获得了 %@ 佣金奖励    %@",aliasStr,moneyStr,dateStr];
//    NSMutableAttributedString *allString = [[NSMutableAttributedString alloc] initWithString:allStr];
//    [allString addAttribute:NSForegroundColorAttributeName value:[UIColor darkGrayColor] range:NSMakeRange(0, aliasStr.length + 5)];
//    [allString addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(aliasStr.length + 5, moneyStr.length)];
//    [allString addAttribute:NSForegroundColorAttributeName value:[UIColor darkGrayColor] range:NSMakeRange(aliasStr.length + 5 + moneyStr.length + 1, 4)];
//    [allString addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:18.0/255.0f green:183.0/255.0f blue:245.0/255.0f alpha:1.0f] range:NSMakeRange(allStr.length - dateStr.length, dateStr.length)];
    
    
    NSString *allStr = [NSString stringWithFormat:@"[%@] %@",labelInfo.category,labelInfo.fullhead];
    return allStr;
    
}


@end
