//
//  TodayStudyDetialCell.h
//  LFBaseFrameTwo
//
//  Created by 曹奕程 on 2017/12/7.
//  Copyright © 2017年 admin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TodayStudyDetialCell : UITableViewCell

//图标
@property (weak, nonatomic) IBOutlet UIImageView *headImageView;

//标题
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

//来源
@property (weak, nonatomic) IBOutlet UILabel *fromLabel;

//时间
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

//图片
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;

//内容
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;

//来源
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;












@end
