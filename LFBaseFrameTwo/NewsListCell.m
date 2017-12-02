//
//  NewsListCell.m
//  LFBaseFrameTwo
//
//  Created by 曹奕程 on 2017/11/28.
//  Copyright © 2017年 admin. All rights reserved.
//

#import "NewsListCell.h"

@implementation NewsListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    // 分割线偏移
    self.separatorInset = UIEdgeInsetsMake(0, kScreenWidth, 0, 0);
    _timeLabel.adjustsFontSizeToFitWidth = YES;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
