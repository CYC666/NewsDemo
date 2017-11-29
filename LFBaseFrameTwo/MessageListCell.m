//
//  MessageListCell.m
//  LFBaseFrameTwo
//
//  Created by 曹老师 on 2017/11/30.
//  Copyright © 2017年 admin. All rights reserved.
//

#import "MessageListCell.h"

@implementation MessageListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    
    self.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
