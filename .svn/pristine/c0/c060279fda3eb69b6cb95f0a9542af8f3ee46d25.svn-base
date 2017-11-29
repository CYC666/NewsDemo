//
//  fadeAlertView.m
//  YiYanYunGou
//
//  Created by admin on 16/3/25.
//  Copyright © 2016年 admin. All rights reserved.
//

#import "fadeAlertView.h"
#import "AppDelegate.h"

@implementation FadeAlertView

//默认初始化
- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        //初始化
        self.textFont           =   [UIFont systemFontOfSize:13.0f];
        self.fadeWidth          =   MBFadeWidth;
        self.fadeBGColor        =   [UIColor colorWithRed:110.0/255.0f green:110.0/255.0f blue:110.0/255.0f alpha:1.0f];
        self.titleColor         =   [UIColor whiteColor];
        self.textOffWidth       =   80;
        self.textOffHeight      =   25;
        self.textBottomHeight   =   SCREEN_HEIGHT * 0.4;
        self.fadeTime           =   2.0;
        self.FadeBGAlpha        =   0.9;
    }
    return self;
}

//
- (void)showAlertWith:(NSString *)str
{
    self.alpha = 0;
    
    NSDictionary *attribute = @{NSFontAttributeName: self.textFont};
    CGRect rect = [str boundingRectWithSize:CGSizeMake(MBFadeWidth, FLT_MAX) options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attribute context:nil];
    
    CGFloat width  = rect.size.width  + self.textOffWidth;
    CGFloat height = rect.size.height + self.textOffHeight;
    
    
    self.frame = CGRectMake(([UIScreen mainScreen].bounds.size.width- width)/2, [UIScreen mainScreen].bounds.size.height - height - self.textBottomHeight, width, height);
    self.backgroundColor = self.fadeBGColor;
    
    //圆角
    self.layer.masksToBounds = YES;
    
//    //一行大圆角，超过一行小圆角
//    if (rect.size.height > 21) {
//        self.layer.cornerRadius = 10/2;
//    } else {
//        self.layer.cornerRadius = height/2;
//    }
    //e元乐吧都使用小圆角
    if (rect.size.height > 21) {
        self.layer.cornerRadius = 16/2;
    } else {
        self.layer.cornerRadius = 20/2;
    }

    
    //遍历并清除未消失的提示view
    for (UIView *subview in ((AppDelegate *)[[UIApplication sharedApplication] delegate]).window.subviews) {
        if ([subview isMemberOfClass:[FadeAlertView class]]) {
            [subview removeFromSuperview];
        }
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        // 主线程更新UI
        UILabel *tmpLabel = [[UILabel alloc] init];
        tmpLabel.text = str;
        tmpLabel.numberOfLines = 0;
        tmpLabel.backgroundColor = [UIColor clearColor];
        tmpLabel.textColor = self.titleColor;
        tmpLabel.textAlignment = NSTextAlignmentCenter;
        tmpLabel.font = self.textFont;
        tmpLabel.frame = CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height);
        [self addSubview:tmpLabel];
        
        [((AppDelegate *)[[UIApplication sharedApplication] delegate]).window addSubview:self];
        
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:.3f];
        self.alpha = self.FadeBGAlpha;
        [UIView commitAnimations];
        
        //存在时间
        [self performSelector:@selector(fadeAway) withObject:nil afterDelay:self.fadeTime];
    });

}

//
- (void)showAlertWithTwo:(NSString *)str
{
    self.alpha = 0;
    
    NSDictionary *attribute = @{NSFontAttributeName: self.textFont};
    CGRect rect = [str boundingRectWithSize:CGSizeMake(MBFadeWidth, FLT_MAX) options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attribute context:nil];
    
    CGFloat width  = rect.size.width  + self.textOffWidth;
    CGFloat height = rect.size.height + self.textOffHeight;
    
    
    self.frame = CGRectMake(([UIScreen mainScreen].bounds.size.width- width)/2, [UIScreen mainScreen].bounds.size.height - height - self.textBottomHeight - 44, width, height);
    self.backgroundColor = self.fadeBGColor;
    
    //圆角
    self.layer.masksToBounds = YES;
    
    //    //一行大圆角，超过一行小圆角
    //    if (rect.size.height > 21) {
    //        self.layer.cornerRadius = 10/2;
    //    } else {
    //        self.layer.cornerRadius = height/2;
    //    }
    //e元乐吧都使用小圆角
    if (rect.size.height > 21) {
        self.layer.cornerRadius = 16/2;
    } else {
        self.layer.cornerRadius = 20/2;
    }
    
    
    //遍历并清除未消失的提示view
    for (UIView *subview in ((AppDelegate *)[[UIApplication sharedApplication] delegate]).window.subviews) {
        if ([subview isMemberOfClass:[FadeAlertView class]]) {
            [subview removeFromSuperview];
        }
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        // 主线程更新UI
        UILabel *tmpLabel = [[UILabel alloc] init];
        tmpLabel.text = str;
        tmpLabel.numberOfLines = 0;
        tmpLabel.backgroundColor = [UIColor clearColor];
        tmpLabel.textColor = self.titleColor;
        tmpLabel.textAlignment = NSTextAlignmentCenter;
        tmpLabel.font = self.textFont;
        tmpLabel.frame = CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height);
        [self addSubview:tmpLabel];
        
        [((AppDelegate *)[[UIApplication sharedApplication] delegate]).window addSubview:self];
        
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:.3f];
        self.alpha = self.FadeBGAlpha;
        [UIView commitAnimations];
        
        //存在时间
        [self performSelector:@selector(fadeAway) withObject:nil afterDelay:self.fadeTime];
    });
    
}


// 渐变消失
- (void)fadeAway
{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.3f];
    self.alpha = .0;
    [UIView commitAnimations];
    [self performSelector:@selector(remove) withObject:nil afterDelay:0.3f];
}
// 从上层视图移除并释放
- (void)remove
{
    [self removeFromSuperview];
}


@end
