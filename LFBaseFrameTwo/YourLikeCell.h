//
//  YourLikeCell.h
//  LFBaseFrameTwo
//
//  Created by 曹老师 on 2017/12/5.
//  Copyright © 2017年 admin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YourLikeCell : UITableViewCell



//标题
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

//内容
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;

//图片
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;

//网站
@property (weak, nonatomic) IBOutlet UILabel *signLabel;

//时间
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;






@end
