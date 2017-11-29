//
//  BlockButton.m
//  YiYanYunGou
//
//  Created by admin on 16/11/1.
//  Copyright © 2016年 admin. All rights reserved.
//

#import "BlockButton.h"

@implementation BlockButton

- (void)addTapBlock:(ButtonBlock)block
{
    _block = block;
    [self addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
}
- (void)buttonAction:(UIButton *)button
{
    _block(button);
}

@end
