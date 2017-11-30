//
//  PersonalInfoCell.h
//  LFBaseFrameTwo
//
//  Created by 曹奕程 on 2017/11/30.
//  Copyright © 2017年 admin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PersonalInfoCell : UITableViewCell


//头像
@property (weak, nonatomic) IBOutlet UIImageView *headImageView;
@property (weak, nonatomic) IBOutlet UIButton *headButton;

//昵称
@property (weak, nonatomic) IBOutlet UITextField *nickField;

//手机号
@property (weak, nonatomic) IBOutlet UITextField *phoneField;

//性别
@property (weak, nonatomic) IBOutlet UILabel *sexLabel;
@property (weak, nonatomic) IBOutlet UIButton *sexButton;

//生日
@property (weak, nonatomic) IBOutlet UILabel *birthLabel;
@property (weak, nonatomic) IBOutlet UIButton *birthButton;

//邮箱
@property (weak, nonatomic) IBOutlet UITextField *EmalField;







@end
