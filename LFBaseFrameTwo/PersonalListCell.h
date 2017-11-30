//
//  PersonalListCell.h
//  LFBaseFrameTwo
//
//  Created by 曹奕程 on 2017/11/29.
//  Copyright © 2017年 admin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PersonalListCell : UITableViewCell

// 图标
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;

// 名字
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

// 未读个数
@property (weak, nonatomic) IBOutlet UILabel *unReadLabel;
@property (copy, nonatomic) NSString *unreadNumber;


@end
