//
//  PersonalListCell.m
//  LFBaseFrameTwo
//
//  Created by 曹奕程 on 2017/11/29.
//  Copyright © 2017年 admin. All rights reserved.
//

#import "PersonalListCell.h"

@implementation PersonalListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    _unReadLabel.adjustsFontSizeToFitWidth = YES;
    
    
}

- (void)setUnreadNumber:(NSString *)unreadNumber {
    
    _unreadNumber = unreadNumber;
    
    _unReadLabel.text = unreadNumber;
    
    // 设置是否隐藏未读个数
    if ([unreadNumber isEqualToString:@""] || unreadNumber.integerValue == 0) {
        _unReadLabel.hidden = YES;
    } else {
        _unReadLabel.hidden = NO;
    }
    
    
}


@end
