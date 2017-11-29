//
//  PersonalListHeaderView.m
//  LFBaseFrameTwo
//
//  Created by 曹奕程 on 2017/11/29.
//  Copyright © 2017年 admin. All rights reserved.
//

#import "PersonalListHeaderView.h"
#import <CoreImage/CoreImage.h>

@implementation PersonalListHeaderView

- (void)awakeFromNib {
    
    [super awakeFromNib];
    
    _headImageView.layer.cornerRadius = 35;
    _headImageView.clipsToBounds = YES;
    
    // 毛玻璃
    UIBlurEffect *blur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];             // 特效
    UIVisualEffectView *visualEffectView = [[UIVisualEffectView alloc] initWithEffect:blur];// 承载特效的视图
    visualEffectView.frame = CGRectMake(0, 0, kScreenWidth, kScreenWidth);
    [_topImageView addSubview:visualEffectView];                                            // 在哪个视图添加特效视图
    _topImageView.clipsToBounds = YES;
    
//    UIVibrancyEffect *vibrancyEffect = [UIVibrancyEffect effectForBlurEffect:blur];
//    UIVisualEffectView *ano = [[UIVisualEffectView alloc] initWithEffect:vibrancyEffect];
//    ano.frame = _topImageView.frame;
//
//    [visualEffectView.contentView addSubview:ano];
//    [ano.contentView addSubview:label];
}

@end
