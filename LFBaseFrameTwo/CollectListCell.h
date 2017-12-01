//
//  CollectListCell.h
//  LFBaseFrameTwo
//
//  Created by 曹奕程 on 2017/12/1.
//  Copyright © 2017年 admin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CollectListCell : UITableViewCell

//标题
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

//内容
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;

//网页标识图片
@property (weak, nonatomic) IBOutlet UIImageView *signImageView;

//网页标题按钮
@property (weak, nonatomic) IBOutlet UIButton *signButton;

//时间
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;




@end
