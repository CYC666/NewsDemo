//
//  SellEnumCell.m
//  LFBaseFrameTwo
//
//  Created by 曹奕程 on 2017/9/25.
//  Copyright © 2017年 admin. All rights reserved.
//

// 类目单元格

#import "SellEnumCell.h"

@implementation SellEnumCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    _nameLabel.adjustsFontSizeToFitWidth = YES;
    
    // 底部线条的颜色
    _whileLine.backgroundColor = Publie_Color;
}


- (void)setIsSelect:(BOOL)isSelect {
    
    _isSelect = isSelect;
    
    if (isSelect) {
        [UIView animateWithDuration:0.35 animations:^{
            _whileLine.hidden = NO;
        }];
    } else {
        [UIView animateWithDuration:0.35 animations:^{
            _whileLine.hidden = YES;
        }];
    }
    
}


@end
