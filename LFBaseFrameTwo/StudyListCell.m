//
//  StudyListCell.m
//  LFBaseFrameTwo
//
//  Created by 曹奕程 on 2017/12/6.
//  Copyright © 2017年 admin. All rights reserved.
//

#import "StudyListCell.h"

@implementation StudyListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    
    self.selectionStyle = UITableViewCellSeparatorStyleNone;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
