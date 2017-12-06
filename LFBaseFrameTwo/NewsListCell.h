//
//  NewsListCell.h
//  LFBaseFrameTwo
//
//  Created by 曹奕程 on 2017/11/28.
//  Copyright © 2017年 admin. All rights reserved.
//

// 主页新闻列表单元格

#import <UIKit/UIKit.h>

@interface NewsListCell : UITableViewCell

//标题
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

//内容
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;

//网页标识图片
@property (weak, nonatomic) IBOutlet UIImageView *signImageView;

//网页标题按钮
@property (weak, nonatomic) IBOutlet UIButton *signButton;

//小眼睛
@property (weak, nonatomic) IBOutlet UIImageView *seeImageView;

//浏览量
@property (weak, nonatomic) IBOutlet UILabel *seeLabel;

//收藏按钮
@property (weak, nonatomic) IBOutlet UIButton *collectButton;
@property (weak, nonatomic) IBOutlet UILabel *collectLabel;

//时间
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

//订阅图标
@property (weak, nonatomic) IBOutlet UIImageView *dingImageView;

//中标招标
@property (weak, nonatomic) IBOutlet UILabel *tipLabel;



@end
