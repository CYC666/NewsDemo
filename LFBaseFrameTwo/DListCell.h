//
//  DListCell.h
//  LFBaseFrameTwo
//
//  Created by 曹奕程 on 2017/12/1.
//  Copyright © 2017年 admin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DListCell : UITableViewCell

// 图标
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;

// 名字
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

// 订阅按钮
@property (weak, nonatomic) IBOutlet UIButton *dingButton;


@end
