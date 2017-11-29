//
//  PersonalListHeaderView.h
//  LFBaseFrameTwo
//
//  Created by 曹奕程 on 2017/11/29.
//  Copyright © 2017年 admin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PersonalListHeaderView : UITableViewHeaderFooterView


//顶部背景图
@property (weak, nonatomic) IBOutlet UIImageView *topImageView;

//头像
@property (weak, nonatomic) IBOutlet UIImageView *headImageView;

//头像按钮
@property (weak, nonatomic) IBOutlet UIButton *headButton;

//名字-白色、前景色
@property (weak, nonatomic) IBOutlet UILabel *nameFrontLabel;

//名字-黑色、背景色
@property (weak, nonatomic) IBOutlet UILabel *nameBackLabel;

//订阅个数
@property (weak, nonatomic) IBOutlet UILabel *dingNumberLabel;

//订阅按钮
@property (weak, nonatomic) IBOutlet UIButton *dingButton;

//收藏个数
@property (weak, nonatomic) IBOutlet UILabel *collectNumberLabel;

//收藏按钮
@property (weak, nonatomic) IBOutlet UIButton *collectButton;

//历史浏览个数
@property (weak, nonatomic) IBOutlet UILabel *historyNumberLabel;

//历史浏览按钮
@property (weak, nonatomic) IBOutlet UIButton *historyButton;



@end
