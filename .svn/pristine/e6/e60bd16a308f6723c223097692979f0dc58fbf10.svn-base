//
//  BlockButton.h
//  YiYanYunGou
//
//  Created by admin on 16/11/1.
//  Copyright © 2016年 admin. All rights reserved.
//

/*!
 * 由于可能存在不能使用button的addTarget方法来添加事件的情况
 * 这里使用Block来回调添加的方法，例子如下：
 
 //正常的添加点击事件
 [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
 
 //使用block添加点击事件
 [btn addTapBlock:^(UIButton *button) {
    //收起键盘，0.3秒动画时间
    [UIView animateWithDuration:0.3 animations:^{
        [target.view endEditing:YES];
    }];
 }];
 
 */

#import <UIKit/UIKit.h>

//定义代码块block
typedef void (^ButtonBlock)(UIButton *);

@interface BlockButton : UIButton

//声明block对象
@property(nonatomic,copy)ButtonBlock block;

//封装原有的addTarget方法
- (void)addTapBlock:(ButtonBlock)block;


@end
