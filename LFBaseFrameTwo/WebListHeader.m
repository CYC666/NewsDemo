//
//  WebListHeader.m
//  LFBaseFrameTwo
//
//  Created by 曹老师 on 2017/12/2.
//  Copyright © 2017年 admin. All rights reserved.
//

#import "WebListHeader.h"

@implementation WebListHeader

- (void)awakeFromNib {
    
    [super awakeFromNib];
    
    
    
    
    _iconImageView.layer.cornerRadius = 12.5;
    _iconImageView.clipsToBounds = YES;
    
    
    
}

@end
