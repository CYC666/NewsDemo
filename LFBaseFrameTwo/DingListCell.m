//
//  DingListCell.m
//  LFBaseFrameTwo
//
//  Created by 曹奕程 on 2017/12/1.
//  Copyright © 2017年 admin. All rights reserved.
//

#import "DingListCell.h"

@implementation DingListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    
    _cellButton.layer.cornerRadius = 5;
    _cellButton.layer.borderWidth = 0.5;
    _cellButton.layer.borderColor = Label_Color_C.CGColor;
    _cellButton.clipsToBounds = YES;
    
    [_cellButton setTitleColor:Label_Color_B forState:UIControlStateNormal];
    [_cellButton setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    
    [_cellButton setBackgroundImage:[self imageWithColor:Background_Color] forState:UIControlStateNormal];
    [_cellButton setBackgroundImage:[self imageWithColor:Publie_Color] forState:UIControlStateHighlighted];
    
}

- (UIImage *)imageWithColor:(UIColor *)color {
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

@end
