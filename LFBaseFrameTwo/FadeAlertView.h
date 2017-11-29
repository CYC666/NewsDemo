//
//  fadeAlertView.h
//  YiYanYunGou
//
//  Created by admin on 16/3/25.
//  Copyright © 2016年 admin. All rights reserved.
//

#import <UIKit/UIKit.h>

//整个view的展示宽度
#define MBFadeWidth [UIScreen mainScreen].bounds.size.width - 120

@interface FadeAlertView : UIView

/**
 *  弹窗显示的文字
 */
@property (copy) NSString *showText;

/**
 *  弹窗字体大小
 */
@property(retain) UIFont *textFont;

/**
 *  整个FadeView的宽度
 */
@property(assign) CGFloat fadeWidth;

/**
 *  整个FadeView的背景色
 */
@property(retain) UIColor *fadeBGColor;

/**
 *  提示语颜色
 */
@property(retain) UIColor *titleColor;

/**
 *  宽度边框
 */
@property(assign) CGFloat textOffWidth;

/**
 *  高度边框
 */
@property(assign) CGFloat textOffHeight;

/**
 *  距离屏幕下方高度
 */
@property(assign) CGFloat textBottomHeight;

/**
 *  自动消失时间
 */
@property (assign) CGFloat fadeTime;

/**
 *  背景的透明度
 */
@property(assign) CGFloat FadeBGAlpha;





/**
 *  显示弹窗
 */
- (void)showAlertWith:(NSString *)str;


/**
 *  显示弹窗
 */
- (void)showAlertWithTwo:(NSString *)str;


@end
