//
//  MessageListCell.h
//  LFBaseFrameTwo
//
//  Created by 曹老师 on 2017/11/30.
//  Copyright © 2017年 admin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MessageListCell : UITableViewCell


//标题
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

//时间
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

//内容
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;

//小红点
@property (weak, nonatomic) IBOutlet UIView *redPoint;


@end
