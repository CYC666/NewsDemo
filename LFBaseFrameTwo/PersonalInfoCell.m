//
//  PersonalInfoCell.m
//  LFBaseFrameTwo
//
//  Created by 曹奕程 on 2017/11/30.
//  Copyright © 2017年 admin. All rights reserved.
//

#import "PersonalInfoCell.h"

@implementation PersonalInfoCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
