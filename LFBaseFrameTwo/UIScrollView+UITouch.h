//
//  UIScrollView+UITouch.h
//  LFBaseFrameTwo
//
//  Created by admin on 16/12/19.
//  Copyright © 2016年 admin. All rights reserved.
//


//这个分类是用来，将VC基类中的Touch时间传递到self.view(ScrollView的父类)

#import <UIKit/UIKit.h>

@interface UIScrollView (UITouch)

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event;

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event;

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event;


@end
