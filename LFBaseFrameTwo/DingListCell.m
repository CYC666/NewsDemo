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
    
    
    _nameLabel.userInteractionEnabled = NO;
    
    
    
}

- (void)setIsDidCell:(BOOL)isDidCell {
    
    _isDidCell = isDidCell;
    
    if (_isDidCell) {
        _nameLabel.textColor = [UIColor whiteColor];
        _cellButton.backgroundColor = Publie_Color;
//        [_cellButton setBackgroundImage:[self imageWithColor:Publie_Color] forState:UIControlStateNormal];
        
        // 添加长按手势
        UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressCellAction:)];
        longPress.minimumPressDuration = 1;
        [self addGestureRecognizer:longPress];
        
    } else {
        _nameLabel.textColor = Label_Color_B;
        _cellButton.backgroundColor = Background_Color;
//        [_cellButton setBackgroundImage:[self imageWithColor:Background_Color] forState:UIControlStateNormal];
    }
    
    
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

#pragma mark - 长按单元格发送通知
- (void)longPressCellAction:(UILongPressGestureRecognizer *)press {
    
    if (press.state == UIGestureRecognizerStateBegan) {
        // 发送通知
        [[NSNotificationCenter defaultCenter] postNotificationName:@"canEditNotificationAction" object:nil];
    }
    
    
}






@end
