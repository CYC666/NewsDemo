//
//  SellGoodsCell.h
//  LFBaseFrameTwo
//
//  Created by 曹奕程 on 2017/9/25.
//  Copyright © 2017年 admin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SellGoodsCell : UICollectionViewCell

//标题左边的图标
@property (weak, nonatomic) IBOutlet UIImageView *titleImageView;

//标题
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

//内容
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;

//网页标识图片
@property (weak, nonatomic) IBOutlet UIImageView *signImageView;

//网页标题按钮
@property (weak, nonatomic) IBOutlet UIButton *signButton;

//订阅图标
@property (weak, nonatomic) IBOutlet UIImageView *dingImageView;

//小眼睛
@property (weak, nonatomic) IBOutlet UIImageView *seeImageView;

//浏览量
@property (weak, nonatomic) IBOutlet UILabel *seeLabel;

//收藏按钮
@property (weak, nonatomic) IBOutlet UIButton *collectButton;

//时间
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;






@end
